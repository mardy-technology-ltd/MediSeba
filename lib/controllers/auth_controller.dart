import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../repositories/auth_repository.dart';
import '../repositories/cloudinary_repository.dart';
import '../models/user_model.dart';

class AuthUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  AuthUser({required this.uid, this.email, this.displayName, this.photoURL});
}

class AuthController extends ChangeNotifier {
  static AuthController? instance;
  final AuthRepository _authRepository = AuthRepository();

  AuthUser? _currentUser;
  UserModel? _currentUserData;
  bool _isLoading = false;
  String? _errorMessage;

  AuthUser? get currentUser => _currentUser;
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
    if (name.isNotEmpty && name != 'User') {
      percentage += 20.0;
    }

    // 3. Profile Picture (20%)
    final photo = _currentUserData?.profileImageUrl ?? _currentUser?.photoURL;
    if (photo != null && photo.isNotEmpty) {
      percentage += 20.0;
    }

    // 4. Phone Number (20%)
    final phone = _currentUserData?.phone ?? '';
    final isRealPhone = phone.isNotEmpty && 
                        !phone.contains('@') && 
                        (RegExp(r'^01[3-9]\d{8}$').hasMatch(phone.replaceAll(RegExp(r'\s+'), '')) || phone.length >= 10);
    
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
    instance = this;
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    final token = _authRepository.token;
    final userData = _authRepository.currentUserData;
    if (token != null && userData != null) {
      _currentUserData = userData;
      _currentUser = AuthUser(
        uid: userData.uid,
        email: userData.phone.contains('@') ? userData.phone : '${userData.phone}@mediseba.com',
        displayName: userData.name,
        photoURL: userData.profileImageUrl,
      );
    }
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
    // Stubbed since REST API is primary, return false.
    return false;
  }

  Future<bool> login(String phone, String password) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final success = await _authRepository.login(phone, password);
      if (success) {
        final userData = _authRepository.currentUserData;
        if (userData != null) {
          _currentUserData = userData;
          _currentUser = AuthUser(
            uid: userData.uid,
            email: userData.phone.contains('@') ? userData.phone : '${userData.phone}@mediseba.com',
            displayName: userData.name,
            photoURL: userData.profileImageUrl,
          );
        }
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
      final success = await _authRepository.signUp(
        name: name,
        phone: phone,
        password: password,
        division: division,
        district: district,
        upazila: upazila,
        union: union,
        referId: referId,
      );
      if (success) {
        final userData = _authRepository.currentUserData;
        if (userData != null) {
          _currentUserData = userData;
          _currentUser = AuthUser(
            uid: userData.uid,
            email: userData.phone.contains('@') ? userData.phone : '${userData.phone}@mediseba.com',
            displayName: userData.name,
            photoURL: userData.profileImageUrl,
          );
        }
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
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image == null) return false;

      _setLoading(true);
      _setError(null);

      // Upload to Cloudinary
      final cloudinaryRepo = CloudinaryRepository();
      final String secureUrl = await cloudinaryRepo.uploadImage(File(image.path));

      // Save URL to local database/caching via repository
      await _authRepository.updateUserProfileImage(_currentUser!.uid, secureUrl);
      
      // Update local state
      _currentUserData = _authRepository.currentUserData;
      if (_currentUserData != null) {
        _currentUser = AuthUser(
          uid: _currentUserData!.uid,
          email: _currentUserData!.phone.contains('@') ? _currentUserData!.phone : '${_currentUserData!.phone}@mediseba.com',
          displayName: _currentUserData!.name,
          photoURL: _currentUserData!.profileImageUrl,
        );
      }

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
      _currentUserData = _authRepository.currentUserData;
      if (_currentUserData != null) {
        _currentUser = AuthUser(
          uid: _currentUserData!.uid,
          email: _currentUserData!.phone.contains('@') ? _currentUserData!.phone : '${_currentUserData!.phone}@mediseba.com',
          displayName: _currentUserData!.name,
          photoURL: _currentUserData!.profileImageUrl,
        );
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }
}
