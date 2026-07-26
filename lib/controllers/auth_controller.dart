import 'package:flutter/material.dart';
import '../models/patient_model.dart';

class AuthController extends ChangeNotifier {
  PatientModel? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  PatientModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  AuthController() {
    // Mock auto-login with default patient for demo
    _currentUser = PatientModel(
      id: 'patient_01',
      name: 'আহমেদ হাসান',
      email: 'ahmed.hasan@example.com',
      phone: '01712345678',
      age: 29,
      gender: 'পুরুষ',
      bloodGroup: 'B+',
    );
    _isLoggedIn = true;
  }

  Future<bool> login(String phone, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // Simulate network

    _currentUser = PatientModel(
      id: 'patient_01',
      name: 'আহমেদ হাসান',
      email: 'ahmed.hasan@example.com',
      phone: phone,
      age: 29,
      gender: 'পুরুষ',
      bloodGroup: 'B+',
    );
    _isLoggedIn = true;

    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
