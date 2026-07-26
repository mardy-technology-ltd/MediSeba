import 'package:flutter/material.dart';
import '../models/doctor_model.dart';
import '../services/api_service.dart';

class DoctorController extends ChangeNotifier {
  List<DoctorModel> _allDoctors = [];
  List<DoctorModel> _filteredDoctors = [];
  String _selectedSpecialty = 'সকল (All)';
  String _searchQuery = '';
  bool _isLoading = false;

  List<DoctorModel> get doctors => _filteredDoctors;
  String get selectedSpecialty => _selectedSpecialty;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  DoctorController() {
    fetchDoctors();
  }

  void fetchDoctors() {
    _isLoading = true;
    notifyListeners();

    _allDoctors = ApiService.getSampleDoctors();
    _filteredDoctors = List.from(_allDoctors);

    _isLoading = false;
    notifyListeners();
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
      bool matchesSpecialty = _selectedSpecialty == 'সকল (All)' || 
          doctor.specialty.contains(_selectedSpecialty.split(' ')[0]);
      bool matchesSearch = _searchQuery.isEmpty ||
          doctor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doctor.specialty.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doctor.hospital.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesSpecialty && matchesSearch;
    }).toList();

    notifyListeners();
  }
}
