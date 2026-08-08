import 'package:flutter/material.dart';
import '../models/doctor_model.dart';
import '../services/api_service.dart';

class DoctorController extends ChangeNotifier {
  List<DoctorModel> _allDoctors = [];
  List<DoctorModel> _filteredDoctors = [];
  String _selectedSpecialty = 'সকল (All)';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  List<DoctorModel> get doctors => _filteredDoctors;
  String get selectedSpecialty => _selectedSpecialty;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  DoctorController() {
    fetchDoctors();
  }

  Future<void> fetchDoctors({bool forceRefresh = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allDoctors = await ApiService.getDoctors(forceRefresh: forceRefresh);
      _applyFilters();
    } catch (e) {
      _errorMessage = 'নেটওয়ার্ক ত্রুটি: $e';
      _allDoctors = [];
      _applyFilters();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterBySpecialty(String specialty) {
    _selectedSpecialty = specialty;
    _applyFilters();
  }

  void searchDoctors(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredDoctors = _allDoctors.where((doctor) {
      bool matchesSpecialty = _selectedSpecialty == 'সকল (All)';
      if (!matchesSpecialty) {
        final categoryBengali = _selectedSpecialty.split(' ')[0].toLowerCase();
        String categoryEnglish = '';
        if (_selectedSpecialty.contains('(') && _selectedSpecialty.contains(')')) {
          categoryEnglish = _selectedSpecialty
              .split('(')
              .last
              .replaceAll(')', '')
              .trim()
              .toLowerCase();
        }

        final docSpecialty = doctor.specialty.toLowerCase();
        matchesSpecialty = docSpecialty.contains(categoryBengali) ||
            (categoryEnglish.isNotEmpty && docSpecialty.contains(categoryEnglish));
      }

      bool matchesSearch = _searchQuery.isEmpty ||
          doctor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doctor.specialty.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doctor.hospital.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesSpecialty && matchesSearch;
    }).toList();

    notifyListeners();
  }
}
