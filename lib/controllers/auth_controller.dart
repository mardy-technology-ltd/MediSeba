import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../repositories/firebase_auth_repository.dart';
import '../repositories/cloudinary_repository.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuthRepository _authRepository = FirebaseAuthRepository();
  
  User? _currentUser;
  UserModel? _currentUserData;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  UserModel? get currentUserData => _currentUserData;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthController() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    _currentUser = _authRepository.currentUser;
    if (_currentUser != null) {
      await _fetchUserData(_currentUser!.uid);
    }
    notifyListeners();
  }

  Future<void> _fetchUserData(String uid) async {
    _currentUserData = await _authRepository.getUserData(uid);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _setError(null);

    try {
      final user = await _authRepository.signInWithGoogle();
      if (user == null) {
        _setLoading(false);
        return false; // User cancelled
      }
      _currentUser = user;
      await _fetchUserData(user.uid);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> login(String phone, String password) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final user = await _authRepository.login(phone, password);
      _currentUser = user;
      if (user != null) {
        await _fetchUserData(user.uid);
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signUp({
    required String name,
    required String phone,
    required String password,
    required String division,
    required String district,
    required String upazila,
    required String union,
    String? referId,
  }) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final user = await _authRepository.signUp(
        name: name,
        phone: phone,
        password: password,
        division: division,
        district: district,
        upazila: upazila,
        union: union,
        referId: referId,
      );
      _currentUser = user;
      if (user != null) {
        await _fetchUserData(user.uid);
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _currentUser = null;
    _currentUserData = null;
    notifyListeners();
  }

  Future<bool> updateProfilePicture(BuildContext context) async {
    if (_currentUser == null) return false;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Compress image
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image == null) return false; // User canceled

      _setLoading(true);
      _setError(null);

      // Upload to Cloudinary
      final cloudinaryRepo = CloudinaryRepository();
      final String secureUrl = await cloudinaryRepo.uploadImage(File(image.path));

      // Save URL to Firestore
      await _authRepository.updateUserProfileImage(_currentUser!.uid, secureUrl);
      
      // Update local state
      await _fetchUserData(_currentUser!.uid);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image: $_errorMessage'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => updateProfilePicture(context),
            ),
          ),
        );
      }
      return false;
    }
  }
}
