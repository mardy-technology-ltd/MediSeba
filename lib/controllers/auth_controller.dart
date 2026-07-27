import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/firebase_auth_repository.dart';
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
}
