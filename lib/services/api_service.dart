import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/doctor_model.dart';
import '../models/doctor_availability_model.dart';
import '../models/appointment_model.dart';
import '../models/medicine_model.dart';
import 'cache_service.dart';

class ApiService {
  static const String baseUrl = 'https://api.mediseba.org/api/v1';
  static const String doctorsEndpoint = 'https://api.mediseba.org/api/v1/doctors';
  static const String availabilitiesEndpoint = 'https://api.mediseba.org/api/v1/availabilities';
  static const String medicinesEndpoint = 'https://api.mediseba.org/api/v1/search-medicines?q=';
  static const String _doctorsCacheKey = 'doctors_list';
  static const String _availabilitiesCacheKey = 'availabilities_list';
  static const String _medicinesCacheKey = 'medicines_list';
  static const Duration _cacheTTL = Duration(minutes: 15);

  /// Fetch all doctor availabilities with Hive caching
  static Future<List<DoctorAvailabilityModel>> getDoctorAvailabilities({bool forceRefresh = false}) async {
    // 1. Check local Hive cache
    if (!forceRefresh && !CacheService.isExpired(_availabilitiesCacheKey, _cacheTTL)) {
      final cachedData = CacheService.get(_availabilitiesCacheKey);
      if (cachedData is List && cachedData.isNotEmpty) {
        try {
          final items = cachedData
              .map((item) => DoctorAvailabilityModel.fromJson(Map<String, dynamic>.from(item as Map)))
              .toList();
          debugPrint('Loaded ${items.length} availabilities from Hive cache.');
          return items;
        } catch (e) {
          debugPrint('Error parsing Hive cached availabilities: $e');
        }
      }
    }

    // 2. Fetch from Network API
    try {
      debugPrint('Fetching availabilities from network API...');
      final response = await http.get(
        Uri.parse(availabilitiesEndpoint),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'MediSebaApp/1.0',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] is List) {
          final List<dynamic> list = body['data'];
          final items = list.map((item) => DoctorAvailabilityModel.fromJson(item as Map<String, dynamic>)).toList();
          if (items.isNotEmpty) {
            await CacheService.put(_availabilitiesCacheKey, list);
            debugPrint('Successfully fetched & cached ${items.length} availabilities to Hive.');
            return items;
          }
        }
      }
    } catch (e) {
      debugPrint('ApiService.getDoctorAvailabilities exception: $e');
    }

    // 3. Network failed: Fallback to existing Hive cache if available
    final fallbackCache = CacheService.get(_availabilitiesCacheKey);
    if (fallbackCache is List && fallbackCache.isNotEmpty) {
      try {
        final items = fallbackCache
            .map((item) => DoctorAvailabilityModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        debugPrint('Fallback: Loaded ${items.length} availabilities from Hive cache.');
        return items;
      } catch (_) {}
    }

    return [];
  }

  static Future<List<DoctorModel>> getDoctors({bool forceRefresh = false}) async {
    // 1. Check local Hive cache if forceRefresh is false
    if (!forceRefresh && !CacheService.isExpired(_doctorsCacheKey, _cacheTTL)) {
      final cachedData = CacheService.get(_doctorsCacheKey);
      if (cachedData is List && cachedData.isNotEmpty) {
        try {
          final doctors = cachedData
              .map((item) => DoctorModel.fromJson(Map<String, dynamic>.from(item as Map)))
              .toList();
          debugPrint('Loaded ${doctors.length} doctors from Hive cache.');
          return doctors;
        } catch (e) {
          debugPrint('Error parsing Hive cached doctors: $e');
        }
      }
    }

    // 2. Fetch fresh data from API
    try {
      debugPrint('Fetching doctors from network API...');
      final response = await http.get(
        Uri.parse(doctorsEndpoint),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'MediSebaApp/1.0',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] is List) {
          final List<dynamic> list = body['data'];
          final doctors = list.map((item) => DoctorModel.fromJson(item as Map<String, dynamic>)).toList();
          if (doctors.isNotEmpty) {
            // Save to Hive cache
            await CacheService.put(_doctorsCacheKey, list);
            debugPrint('Successfully fetched & cached ${doctors.length} doctors to Hive.');
            return doctors;
          }
        }
      }
    } catch (e) {
      debugPrint('ApiService.getDoctors exception: $e.');
    }

    // 3. Network failed: Fallback to existing Hive cache if available
    final fallbackCache = CacheService.get(_doctorsCacheKey);
    if (fallbackCache is List && fallbackCache.isNotEmpty) {
      try {
        final doctors = fallbackCache
            .map((item) => DoctorModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        debugPrint('Fallback: Loaded ${doctors.length} doctors from Hive cache.');
        return doctors;
      } catch (_) {}
    }

    // 4. Default fallback sample doctors
    return getSampleDoctors();
  }

  // Mock Data for Doctors
  static List<DoctorModel> getSampleDoctors() {
    return [
      DoctorModel(
        id: 'doc_1',
        name: 'ডাঃ মোহাম্মাদ আরিফ রহমান',
        degree: 'MBBS, FCPS (Medicine), MD (Cardiology)',
        specialty: 'মেডিসিন (Medicine)',
        hospital: 'ঢাকা মেডিকেল কলেজ ও হাসপাতাল',
        rating: 4.9,
        totalReviews: 128,
        experienceYears: 12,
        consultationFee: 800,
        imageUrl: 'https://img.freepik.com/free-photo/doctor-offering-medical-teleconsultation_23-2149329007.jpg',
        isAvailableToday: true,
      ),
      DoctorModel(
        id: 'doc_2',
        name: 'ডাঃ ফারজানা আক্তার',
        degree: 'MBBS, MS (Gynecology & Obstetrics)',
        specialty: 'গাইনি ও স্ত্রী রোগ (Gynecology)',
        hospital: 'স্কয়ার হাসপাতাল, ঢাকা',
        rating: 4.8,
        totalReviews: 95,
        experienceYears: 9,
        consultationFee: 700,
        imageUrl: 'https://img.freepik.com/free-photo/female-doctor-hospital-with-stethoscope_23-2148827766.jpg',
        isAvailableToday: true,
      ),
      DoctorModel(
        id: 'doc_3',
        name: 'ডাঃ তামিম হাসান',
        degree: 'MBBS, DCH, MD (Pediatrics)',
        specialty: 'শিশু রোগ (Pediatrics)',
        hospital: 'বঙ্গবন্ধু শেখ মুজিব মেডিকেল বিশ্ববিদ্যালয়',
        rating: 4.7,
        totalReviews: 74,
        experienceYears: 8,
        consultationFee: 600,
        imageUrl: 'https://img.freepik.com/free-photo/young-handsome-physician-medical-robe-with-stethoscope_1303-17818.jpg',
        isAvailableToday: false,
      ),
      DoctorModel(
        id: 'doc_4',
        name: 'ডাঃ সায়মা পারভীন',
        degree: 'MBBS, DDV (Dermatology)',
        specialty: 'চর্ম ও যৌন (Dermatology)',
        hospital: 'পপুলার ডায়াগনস্টিক সেন্টার',
        rating: 4.9,
        totalReviews: 140,
        experienceYears: 14,
        consultationFee: 1000,
        imageUrl: 'https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-crossed-arms_409827-254.jpg',
        isAvailableToday: true,
      ),
      DoctorModel(
        id: 'doc_5',
        name: 'ডাঃ তানভীর আহমেদ',
        degree: 'MBBS, MS (Orthopedics)',
        specialty: 'অর্থোপেডিক্স (Orthopedics)',
        hospital: 'ল্যাবএইড হাসপাতাল, ধানমন্ডি',
        rating: 4.6,
        totalReviews: 62,
        experienceYears: 10,
        consultationFee: 800,
        imageUrl: 'https://img.freepik.com/free-photo/doctor-with-stethoscope-hospital_23-2148827775.jpg',
        isAvailableToday: true,
      ),
    ];
  }

  static List<AppointmentModel> getSampleAppointments() {
    return [
      AppointmentModel(
        id: 'apt_101',
        doctorId: 'doc_1',
        doctorName: 'ডাঃ মোহাম্মাদ আরিফ রহমান',
        doctorSpecialty: 'মেডিসিন (Medicine)',
        patientName: 'আহমেদ হাসান',
        patientPhone: '01712345678',
        appointmentDate: '2026-07-28',
        appointmentTime: '05:30 PM',
        status: 'Confirmed',
        fee: 800,
      ),
      AppointmentModel(
        id: 'apt_102',
        doctorId: 'doc_2',
        doctorName: 'ডাঃ ফারজানা আক্তার',
        doctorSpecialty: 'গাইনি ও স্ত্রী রোগ (Gynecology)',
        patientName: 'সুলতানা বেগম',
        patientPhone: '01898765432',
        appointmentDate: '2026-07-30',
        appointmentTime: '07:00 PM',
        status: 'Pending',
        fee: 700,
      ),
    ];
  }

  /// Search or fetch database medicines with Hive caching
  static Future<List<MedicineModel>> searchMedicines({String query = '', bool forceRefresh = false}) async {
    final cleanQuery = query.trim();
    final cacheKey = cleanQuery.isEmpty ? _medicinesCacheKey : '${_medicinesCacheKey}_$cleanQuery';

    // 1. Check local Hive cache
    if (!forceRefresh && !CacheService.isExpired(cacheKey, _cacheTTL)) {
      final cachedData = CacheService.get(cacheKey);
      if (cachedData is List && cachedData.isNotEmpty) {
        try {
          final items = cachedData
              .map((item) => MedicineModel.fromJson(Map<String, dynamic>.from(item as Map)))
              .toList();
          debugPrint('Loaded ${items.length} medicines from Hive cache.');
          return items;
        } catch (e) {
          debugPrint('Error parsing Hive cached medicines: $e');
        }
      }
    }

    // 2. Fetch fresh data from network API
    try {
      final encodedQuery = Uri.encodeComponent(cleanQuery);
      final url = '$medicinesEndpoint$encodedQuery';
      debugPrint('Fetching medicines from network API: $url');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'MediSebaApp/1.0',
        },
      ).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] is List) {
          final List<dynamic> list = body['data'];
          final items = list.map((item) => MedicineModel.fromJson(item as Map<String, dynamic>)).toList();
          if (items.isNotEmpty) {
            await CacheService.put(cacheKey, list);
            debugPrint('Successfully fetched & cached ${items.length} medicines to Hive.');
            return items;
          }
        }
      }
    } catch (e) {
      debugPrint('ApiService.searchMedicines exception: $e');
    }

    // 3. Fallback to existing Hive cache if network fails
    final fallbackCache = CacheService.get(cacheKey);
    if (fallbackCache is List && fallbackCache.isNotEmpty) {
      try {
        final items = fallbackCache
            .map((item) => MedicineModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        debugPrint('Fallback: Loaded ${items.length} medicines from Hive cache.');
        return items;
      } catch (_) {}
    }

    return [];
  }

  /// Fetch Admin Dashboard metrics
  static Future<Map<String, dynamic>?> getAdminDashboard(String token) async {
    try {
      debugPrint('Fetching admin dashboard data from API...');
      final response = await http.get(
        Uri.parse('https://api.mediseba.org/api/v1/admin/dashboard'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'User-Agent': 'MediSebaApp/1.0',
        },
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true || body['status'] == 'success') {
          return body['data'] as Map<String, dynamic>?;
        }
      }
    } catch (e) {
      debugPrint('ApiService.getAdminDashboard exception: $e');
    }
    return null;
  }

  /// 1. Fetch Sales Agents list
  static Future<List<Map<String, dynamic>>?> getSalesAgents({String? role, required String token}) async {
    try {
      String url = 'https://api.mediseba.org/api/v1/sales-agents';
      if (role != null && role.isNotEmpty) {
        url += '?role=$role';
      }
      debugPrint('🚀 [API REQ] GET: $url');
      debugPrint('Headers: {"Authorization": "Bearer $token"}');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'User-Agent': 'MediSebaApp/1.0',
        },
      ).timeout(const Duration(seconds: 8));

      debugPrint('👈 [API RES] STATUS: ${response.statusCode}');
      debugPrint('👈 [API RES] BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true || body['status'] == 'success') {
          final List list = body['data'] ?? [];
          return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      }
    } catch (e) {
      debugPrint('❌ ApiService.getSalesAgents exception: $e');
    }
    return null;
  }

  /// 2. Fetch Supervisors dropdown list
  static Future<List<Map<String, dynamic>>?> getSupervisors(String token) async {
    try {
      const url = 'https://api.mediseba.org/api/v1/sales-agents/supervisors';
      debugPrint('🚀 [API REQ] GET: $url');
      debugPrint('Headers: {"Authorization": "Bearer $token"}');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'User-Agent': 'MediSebaApp/1.0',
        },
      ).timeout(const Duration(seconds: 8));

      debugPrint('👈 [API RES] STATUS: ${response.statusCode}');
      debugPrint('👈 [API RES] BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true || body['status'] == 'success') {
          final List list = body['data'] ?? [];
          return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      }
    } catch (e) {
      debugPrint('❌ ApiService.getSupervisors exception: $e');
    }
    return null;
  }

  /// 3. Create a new Sales Agent
  static Future<bool> createSalesAgent({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    int? supervisorId,
    required String token,
  }) async {
    try {
      const url = 'https://api.mediseba.org/api/v1/sales-agents';
      final payload = {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'role': role,
        if (supervisorId != null) 'supervisor_id': supervisorId,
      };

      debugPrint('🚀 [API REQ] POST: $url');
      debugPrint('Headers: {"Authorization": "Bearer $token"}');
      debugPrint('Body: ${jsonEncode(payload)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'User-Agent': 'MediSebaApp/1.0',
        },
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 8));

      debugPrint('👈 [API RES] STATUS: ${response.statusCode}');
      debugPrint('👈 [API RES] BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['success'] == true || body['status'] == 'success';
      }
    } catch (e) {
      debugPrint('❌ ApiService.createSalesAgent exception: $e');
    }
    return false;
  }

  /// 4. Assign or change supervisor
  static Future<bool> assignSupervisor({
    required int userId,
    required int supervisorId,
    required String token,
  }) async {
    try {
      final url = 'https://api.mediseba.org/api/v1/sales-agents/$userId/assign-supervisor';
      final payload = {
        'supervisor_id': supervisorId,
      };

      debugPrint('🚀 [API REQ] PATCH: $url');
      debugPrint('Headers: {"Authorization": "Bearer $token"}');
      debugPrint('Body: ${jsonEncode(payload)}');

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'User-Agent': 'MediSebaApp/1.0',
        },
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 8));

      debugPrint('👈 [API RES] STATUS: ${response.statusCode}');
      debugPrint('👈 [API RES] BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['success'] == true || body['status'] == 'success';
      }
    } catch (e) {
      debugPrint('❌ ApiService.assignSupervisor exception: $e');
    }
    return false;
  }

  /// 5. Update agent role/promotion
  static Future<bool> updateAgentRole({
    required int userId,
    required String role,
    required String token,
  }) async {
    try {
      final url = 'https://api.mediseba.org/api/v1/sales-agents/$userId/role';
      final payload = {
        'role': role,
      };

      debugPrint('🚀 [API REQ] PATCH: $url');
      debugPrint('Headers: {"Authorization": "Bearer $token"}');
      debugPrint('Body: ${jsonEncode(payload)}');

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'User-Agent': 'MediSebaApp/1.0',
        },
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 8));

      debugPrint('👈 [API RES] STATUS: ${response.statusCode}');
      debugPrint('👈 [API RES] BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['success'] == true || body['status'] == 'success';
      }
    } catch (e) {
      debugPrint('❌ ApiService.updateAgentRole exception: $e');
    }
    return false;
  }

  /// 6. Delete Sales Agent
  static Future<bool> deleteSalesAgent({
    required int userId,
    required String token,
  }) async {
    try {
      const url = 'https://api.mediseba.org/api/v1/sales-agents';
      final payload = {
        'user_id': userId,
      };

      debugPrint('🚀 [API REQ] DELETE: $url');
      debugPrint('Headers: {"Authorization": "Bearer $token"}');
      debugPrint('Body: ${jsonEncode(payload)}');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'User-Agent': 'MediSebaApp/1.0',
        },
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 8));

      debugPrint('👈 [API RES] STATUS: ${response.statusCode}');
      debugPrint('👈 [API RES] BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['success'] == true || body['status'] == 'success';
      }
    } catch (e) {
      debugPrint('❌ ApiService.deleteSalesAgent exception: $e');
    }
    return false;
  }

  /// 7. HBP Field Agent Patient Registration
  static Future<bool> hbpRegisterPatient({
    required String name,
    required String phone,
    required int age,
    required String gender,
    required String token,
  }) async {
    try {
      const url = 'https://api.mediseba.org/api/v1/hbp/register-patient';
      final payload = {
        'name': name,
        'phone': phone,
        'age': age,
        'gender': gender,
      };

      debugPrint('🚀 [API REQ] POST: $url');
      debugPrint('Headers: {"Authorization": "Bearer $token"}');
      debugPrint('Body: ${jsonEncode(payload)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'User-Agent': 'MediSebaApp/1.0',
        },
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 8));

      debugPrint('👈 [API RES] STATUS: ${response.statusCode}');
      debugPrint('👈 [API RES] BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['success'] == true || body['status'] == 'success';
      }
    } catch (e) {
      debugPrint('❌ ApiService.hbpRegisterPatient exception: $e');
    }
    return false;
  }

  /// 8. Get Admin Doctors List
  static Future<List<Map<String, dynamic>>> getAdminDoctors({
    required String token,
    String? search,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      String url = 'https://api.mediseba.org/api/v1/admin/doctors?page=$page&per_page=$perPage';
      if (search != null && search.trim().isNotEmpty) {
        url += '&search=${Uri.encodeComponent(search.trim())}';
      }

      debugPrint('🚀 [API REQ] GET: $url');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'User-Agent': 'MediSebaApp/1.0',
        },
      ).timeout(const Duration(seconds: 8));

      debugPrint('👈 [API RES] STATUS: ${response.statusCode}');
      debugPrint('👈 [API RES] BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] is List) {
          return List<Map<String, dynamic>>.from(
            (body['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ ApiService.getAdminDoctors exception: $e');
    }
    return [];
  }

  /// 9. Create Admin Doctor
  static Future<bool> createAdminDoctor({
    required String token,
    required Map<String, dynamic> payload,
  }) async {
    try {
      const url = 'https://api.mediseba.org/api/v1/admin/doctors';
      debugPrint('🚀 [API REQ] POST: $url');
      debugPrint('Body: ${jsonEncode(payload)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'User-Agent': 'MediSebaApp/1.0',
        },
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 8));

      debugPrint('👈 [API RES] STATUS: ${response.statusCode}');
      debugPrint('👈 [API RES] BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['success'] == true;
      }
    } catch (e) {
      debugPrint('❌ ApiService.createAdminDoctor exception: $e');
    }
    return false;
  }

  /// 10. Update Admin Doctor
  static Future<bool> updateAdminDoctor({
    required String token,
    required Map<String, dynamic> payload,
  }) async {
    try {
      const url = 'https://api.mediseba.org/api/v1/admin/doctors';
      debugPrint('🚀 [API REQ] PUT: $url');
      debugPrint('Body: ${jsonEncode(payload)}');

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'User-Agent': 'MediSebaApp/1.0',
        },
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 8));

      debugPrint('👈 [API RES] STATUS: ${response.statusCode}');
      debugPrint('👈 [API RES] BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['success'] == true;
      }
    } catch (e) {
      debugPrint('❌ ApiService.updateAdminDoctor exception: $e');
    }
    return false;
  }

  /// 11. Delete Admin Doctor
  static Future<bool> deleteAdminDoctor({
    required String token,
    required String idOrUuid,
  }) async {
    try {
      final url = 'https://api.mediseba.org/api/v1/admin/doctors?id=$idOrUuid';
      debugPrint('🚀 [API REQ] DELETE: $url');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'User-Agent': 'MediSebaApp/1.0',
        },
      ).timeout(const Duration(seconds: 8));

      debugPrint('👈 [API RES] STATUS: ${response.statusCode}');
      debugPrint('👈 [API RES] BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['success'] == true;
      }
    } catch (e) {
      debugPrint('❌ ApiService.deleteAdminDoctor exception: $e');
    }
    return false;
  }

  // ===========================================================================
  // 🌐 HBP PORTAL API ENDPOINTS (Developer Documentation Integration)
  // ===========================================================================

  /// 1️⃣ Fetch HBP Dashboard Metrics & Sales History
  static Future<Map<String, dynamic>?> fetchHbpMetrics(String token) async {
    try {
      // 1. Try primary endpoint: /hbp/metrics
      var url = '$baseUrl/hbp/metrics';
      debugPrint('🚀 [API REQ] GET HBP Metrics: $url');

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'User-Agent': 'MediSebaApp/1.0',
        },
      ).timeout(const Duration(seconds: 8));

      debugPrint('👈 [API RES] HBP Metrics STATUS: ${response.statusCode}');
      debugPrint('👈 [API RES] HBP Metrics BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == 'success' || body['success'] == true) {
          return body['data'] as Map<String, dynamic>?;
        }
      }

      // 2. Try fallback endpoint: /hbp/dashboard (as noted in developer documentation)
      url = '$baseUrl/hbp/dashboard';
      debugPrint('🚀 [API REQ] GET HBP Dashboard (Fallback): $url');

      response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'User-Agent': 'MediSebaApp/1.0',
        },
      ).timeout(const Duration(seconds: 8));

      debugPrint('👈 [API RES] HBP Dashboard STATUS: ${response.statusCode}');
      debugPrint('👈 [API RES] HBP Dashboard BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == 'success' || body['success'] == true) {
          return body['data'] as Map<String, dynamic>?;
        }
      }
    } catch (e) {
      debugPrint('❌ ApiService.fetchHbpMetrics exception: $e');
    }
    return null;
  }

  /// 2️⃣ Register New Patient Account by HBP Field Agent
  static Future<Map<String, dynamic>> registerPatientByHbp({
    required String token,
    required String name,
    required String phone,
    required String password,
    String? email,
    required String packageId,
    required String paymentMethod,
  }) async {
    try {
      final url = '$baseUrl/hbp/register-patient';
      final payload = {
        'name': name,
        'phone': phone,
        'password': password,
        if (email != null && email.isNotEmpty) 'email': email,
        'package_id': packageId,
        'payment_method': paymentMethod,
      };

      debugPrint('🚀 [API REQ] POST HBP Register Patient: $url');
      debugPrint('👉 PAYLOAD: ${jsonEncode(payload)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'User-Agent': 'MediSebaApp/1.0',
        },
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 10));

      debugPrint('👈 [API RES] HBP Register STATUS: ${response.statusCode}');
      debugPrint('👈 [API RES] HBP Register BODY: ${response.body}');

      final Map<String, dynamic> body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': body['message'] ?? 'Patient account registered successfully.',
          'data': body['data'],
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'রেজিস্ট্রেশন ব্যর্থ হয়েছে (কোড ${response.statusCode})',
        };
      }
    } catch (e) {
      debugPrint('❌ ApiService.registerPatientByHbp exception: $e');
      return {
        'success': false,
        'message': 'নেটওয়ার্ক ত্রুটি: $e',
      };
    }
  }

  /// 3️⃣ Fetch Health Packages List
  static Future<List<Map<String, dynamic>>> fetchHealthPackages() async {
    try {
      final url = '$baseUrl/packages';
      debugPrint('🚀 [API REQ] GET Packages: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'MediSebaApp/1.0',
        },
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['data'] is List) {
          return List<Map<String, dynamic>>.from(body['data'] as List);
        }
      }
    } catch (e) {
      debugPrint('❌ ApiService.fetchHealthPackages exception: $e');
    }
    return [];
  }

  /// 4️⃣ Fetch HBP Agent Profile
  static Future<Map<String, dynamic>?> fetchHbpProfile(String token) async {
    try {
      final url = '$baseUrl/user/profile';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['data'] as Map<String, dynamic>?;
      }
    } catch (e) {
      debugPrint('❌ ApiService.fetchHbpProfile exception: $e');
    }
    return null;
  }
}
