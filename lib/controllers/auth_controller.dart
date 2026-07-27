import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/firebase_auth_repository.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuthRepository _authRepository = FirebaseAuthRepository();
  
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthController() {
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    _currentUser = _authRepository.currentUser;
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
    required String thana,
    required String village,
    required String birthYear,
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
        thana: thana,
        village: village,
        birthYear: birthYear,
        referId: referId,
      );
      _currentUser = user;
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
    notifyListeners();
  }
}
