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
    final cleanQuery = _searchQuery.trim().toLowerCase();

    // Generic keywords for doctor search that should match all doctors
    const genericDoctorKeywords = {
      'doctor',
      'doctors',
      'dr',
      'dr.',
      'doc',
      'ডাক্তার',
      'ডাক্তারগণ',
      'ডাক্তাররা',
      'দাক্তার',
      'চিকিৎসক',
      'বিশেষজ্ঞ',
    };

    final bool isGenericDoctorSearch = genericDoctorKeywords.contains(cleanQuery);

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

      if (cleanQuery.isEmpty || isGenericDoctorSearch) {
        return matchesSpecialty;
      }

      final String docName = doctor.name.toLowerCase();
      final String docSpecialty = doctor.specialty.toLowerCase();
      final String docHospital = doctor.hospital.toLowerCase();
      final String docDegree = doctor.degree.toLowerCase();

      bool matchesSearch = docName.contains(cleanQuery) ||
          docSpecialty.contains(cleanQuery) ||
          docHospital.contains(cleanQuery) ||
          docDegree.contains(cleanQuery);

      // Transliteration and partial name match support
      if (!matchesSearch) {
        if ((cleanQuery.contains('arif') || cleanQuery.contains('আরিফ')) && docName.contains('আরিফ')) {
          matchesSearch = true;
        } else if ((cleanQuery.contains('farzana') || cleanQuery.contains('ফারজানা')) && docName.contains('ফারজানা')) {
          matchesSearch = true;
        } else if ((cleanQuery.contains('tamim') || cleanQuery.contains('তামিম')) && docName.contains('তামিম')) {
          matchesSearch = true;
        } else if ((cleanQuery.contains('saima') || cleanQuery.contains('সায়মা')) && docName.contains('সায়মা')) {
          matchesSearch = true;
        } else if ((cleanQuery.contains('tanvir') || cleanQuery.contains('তানভীর')) && docName.contains('তানভীর')) {
          matchesSearch = true;
        }
      }

      return matchesSpecialty && matchesSearch;
    }).toList();

    notifyListeners();
  }
}
