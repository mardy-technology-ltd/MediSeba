import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class FirebaseAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Convert phone number to a dummy email for Firebase Email/Password Auth
  String _phoneToEmail(String phone) {
    // Remove any spaces or special characters if needed
    String cleanPhone = phone.replaceAll(RegExp(r'\s+'), '');
    return '$cleanPhone@mediseba.com';
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled the sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Check if user already exists in Firestore
        final docSnapshot = await _firestore.collection('users').doc(user.uid).get();
        if (!docSnapshot.exists) {
          // Create user document for first time google login
          final userModel = UserModel(
            uid: user.uid,
            name: user.displayName ?? 'Google User',
            phone: user.phoneNumber ?? user.email ?? '',
            division: '',
            district: '',
            upazila: '',
            union: '',
            profileImageUrl: user.photoURL,
            createdAt: DateTime.now(),
          );

          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userModel.toMap());
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  Future<User?> login(String phone, String password) async {
    try {
      final String email = _phoneToEmail(phone);
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<User?> signUp({
    required String name,
    required String phone,
    required String password,
    required String division,
    required String district,
    required String upazila,
    required String union,
    String? referId,
  }) async {
    try {
      final String email = _phoneToEmail(phone);
      
      // Create user in Firebase Auth
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final User? user = userCredential.user;
      
      if (user != null) {
        // Update Firebase profile with the user's name
        await user.updateDisplayName(name);
        await user.reload();
        
        // Save additional details to Cloud Firestore
        final userModel = UserModel(
          uid: user.uid,
          name: name,
          phone: phone,
          division: division,
          district: district,
          upazila: upazila,
          union: union,
          referId: referId,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());
      }
      
      return _firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserModel?> getUserData(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        return UserModel.fromMap(docSnapshot.data()!, docSnapshot.id);
      }
      return null;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> updateUserProfileImage(String uid, String imageUrl) async {
    try {
      await _firestore.collection('users').doc(uid).set(
        {'profileImageUrl': imageUrl},
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to update profile image in database: $e');
    }
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found for that phone number.');
      case 'wrong-password':
        return Exception('Wrong password provided for that phone number.');
      case 'email-already-in-use':
        return Exception('An account already exists with that phone number.');
      case 'weak-password':
        return Exception('The password provided is too weak.');
      case 'invalid-email':
        return Exception('The phone number is invalid.');
      default:
        return Exception(e.message ?? 'Authentication failed.');
    }
  }
}
