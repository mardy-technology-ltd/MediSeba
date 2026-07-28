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

  /// Calculates profile completion percentage (0 to 100)
  double get profileCompletionPercentage {
    if (_currentUser == null) return 0.0;
    double percentage = 0.0;

    // 1. Account / Auth (10%)
    percentage += 10.0;

    // 2. Name (20%)
    final name = _currentUserData?.name ?? _currentUser?.displayName ?? '';
    if (name.isNotEmpty && name != 'User' && name != 'Google User') {
      percentage += 20.0;
    }

    // 3. Profile Picture (20%)
    final photo = _currentUserData?.profileImageUrl ?? _currentUser?.photoURL;
    if (photo != null && photo.isNotEmpty) {
      percentage += 20.0;
    }

    // 4. Phone Number (20%)
    // Check if user has a valid phone number (not an email pretending to be phone)
    final phone = _currentUserData?.phone ?? '';
    final email = _currentUser?.email ?? '';
    final isRealPhone = phone.isNotEmpty && 
                        !phone.contains('@') && 
                        (RegExp(r'^01[3-9]\d{8}$').hasMatch(phone.replaceAll(RegExp(r'\s+'), '')) || phone.length >= 10);
    
    // Also if email is not ending in @mediseba.com but phone is set, or user logged in via phone
    if (isRealPhone) {
      percentage += 20.0;
    }

    // 5. Address (30% total -> Division 7.5%, District 7.5%, Upazila 7.5%, Union 7.5%)
    if (_currentUserData != null) {
      if (_currentUserData!.division.isNotEmpty) percentage += 7.5;
      if (_currentUserData!.district.isNotEmpty) percentage += 7.5;
      if (_currentUserData!.upazila.isNotEmpty) percentage += 7.5;
      if (_currentUserData!.union.isNotEmpty) percentage += 7.5;
    }

    return percentage.clamp(0.0, 100.0);
  }

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

  Future<bool> updateProfileDetails({
    required String name,
    required String phone,
    required String division,
    required String district,
    required String upazila,
    required String union,
    String? referId,
  }) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _setError(null);

    try {
      await _authRepository.updateUserProfile(
        uid: _currentUser!.uid,
        name: name,
        phone: phone,
        division: division,
        district: district,
        upazila: upazila,
        union: union,
        referId: referId,
      );

      // Refresh local user data
      await _fetchUserData(_currentUser!.uid);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }
}
