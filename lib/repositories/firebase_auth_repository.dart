import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Convert phone number to a dummy email for Firebase Email/Password Auth
  String _phoneToEmail(String phone) {
    // Remove any spaces or special characters if needed
    String cleanPhone = phone.replaceAll(RegExp(r'\s+'), '');
    return '$cleanPhone@mediseba.com';
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
    required String thana,
    required String village,
    required String birthYear,
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
          thana: thana,
          village: village,
          birthYear: birthYear,
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
