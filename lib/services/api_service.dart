import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/doctor_model.dart';
import '../models/doctor_availability_model.dart';
import '../models/appointment_model.dart';
import '../models/medicine_model.dart';
import '../utils/api_logger.dart';
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

    final stopwatch = Stopwatch()..start();
    final headers = {
      'Accept': 'application/json',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Doctor Availabilities View',
      trigger: 'initState() / Screen Load',
      functionName: 'getDoctorAvailabilities',
      isUserAction: false,
      method: 'GET',
      url: availabilitiesEndpoint,
      headers: headers,
    );

    try {
      final response = await http.get(
        Uri.parse(availabilitiesEndpoint),
        headers: headers,
      ).timeout(const Duration(seconds: 4));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] is List) {
          final List<dynamic> list = body['data'];
          final items = list.map((item) => DoctorAvailabilityModel.fromJson(item as Map<String, dynamic>)).toList();
          if (items.isNotEmpty) {
            await CacheService.put(_availabilitiesCacheKey, list);
            return items;
          }
        }
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Doctor Availabilities View',
        trigger: 'initState() / Screen Load',
        functionName: 'getDoctorAvailabilities',
        method: 'GET',
        url: availabilitiesEndpoint,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }

    final fallbackCache = CacheService.get(_availabilitiesCacheKey);
    if (fallbackCache is List && fallbackCache.isNotEmpty) {
      try {
        final items = fallbackCache
            .map((item) => DoctorAvailabilityModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        return items;
      } catch (_) {}
    }

    return [];
  }

  static Future<List<DoctorModel>> getDoctors({bool forceRefresh = false}) async {
    if (!forceRefresh && !CacheService.isExpired(_doctorsCacheKey, _cacheTTL)) {
      final cachedData = CacheService.get(_doctorsCacheKey);
      if (cachedData is List && cachedData.isNotEmpty) {
        try {
          final doctors = cachedData
              .map((item) => DoctorModel.fromJson(Map<String, dynamic>.from(item as Map)))
              .toList();
          return doctors;
        } catch (e) {
          debugPrint('Error parsing Hive cached doctors: $e');
        }
      }
    }

    final stopwatch = Stopwatch()..start();
    final headers = {
      'Accept': 'application/json',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Doctor Catalog View',
      trigger: 'initState() / Screen Load',
      functionName: 'getDoctors',
      isUserAction: false,
      method: 'GET',
      url: doctorsEndpoint,
      headers: headers,
    );

    try {
      final response = await http.get(
        Uri.parse(doctorsEndpoint),
        headers: headers,
      ).timeout(const Duration(seconds: 4));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] is List) {
          final List<dynamic> list = body['data'];
          final doctors = list.map((item) => DoctorModel.fromJson(item as Map<String, dynamic>)).toList();
          if (doctors.isNotEmpty) {
            await CacheService.put(_doctorsCacheKey, list);
            return doctors;
          }
        }
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Doctor Catalog View',
        trigger: 'initState() / Screen Load',
        functionName: 'getDoctors',
        method: 'GET',
        url: doctorsEndpoint,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }

    final fallbackCache = CacheService.get(_doctorsCacheKey);
    if (fallbackCache is List && fallbackCache.isNotEmpty) {
      try {
        final doctors = fallbackCache
            .map((item) => DoctorModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        return doctors;
      } catch (_) {}
    }

    return getSampleDoctors();
  }

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

  static Future<List<MedicineModel>> searchMedicines({String query = '', bool forceRefresh = false}) async {
    final cleanQuery = query.trim();
    final cacheKey = cleanQuery.isEmpty ? _medicinesCacheKey : '${_medicinesCacheKey}_$cleanQuery';

    if (!forceRefresh && !CacheService.isExpired(cacheKey, _cacheTTL)) {
      final cachedData = CacheService.get(cacheKey);
      if (cachedData is List && cachedData.isNotEmpty) {
        try {
          final items = cachedData
              .map((item) => MedicineModel.fromJson(Map<String, dynamic>.from(item as Map)))
              .toList();
          return items;
        } catch (e) {
          debugPrint('Error parsing Hive cached medicines: $e');
        }
      }
    }

    final stopwatch = Stopwatch()..start();
    final encodedQuery = Uri.encodeComponent(cleanQuery);
    final url = '$medicinesEndpoint$encodedQuery';
    final headers = {
      'Accept': 'application/json',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Medicine Inventory Search',
      trigger: cleanQuery.isEmpty ? 'initState()' : 'Search Query Input',
      functionName: 'searchMedicines',
      isUserAction: cleanQuery.isNotEmpty,
      method: 'GET',
      url: url,
      headers: headers,
    );

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 6));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] is List) {
          final List<dynamic> list = body['data'];
          final items = list.map((item) => MedicineModel.fromJson(item as Map<String, dynamic>)).toList();
          if (items.isNotEmpty) {
            await CacheService.put(cacheKey, list);
            return items;
          }
        }
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Medicine Inventory Search',
        trigger: cleanQuery.isEmpty ? 'initState()' : 'Search Query Input',
        functionName: 'searchMedicines',
        method: 'GET',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }

    final fallbackCache = CacheService.get(cacheKey);
    if (fallbackCache is List && fallbackCache.isNotEmpty) {
      try {
        final items = fallbackCache
            .map((item) => MedicineModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        return items;
      } catch (_) {}
    }

    return [];
  }

  static Future<Map<String, dynamic>?> getAdminDashboard(String token) async {
    final stopwatch = Stopwatch()..start();
    const url = 'https://api.mediseba.org/api/v1/admin/dashboard';
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Admin Dashboard View',
      trigger: 'initState() / Refresh',
      functionName: 'getAdminDashboard',
      isUserAction: false,
      method: 'GET',
      url: url,
      headers: headers,
    );

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 8));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true || body['status'] == 'success') {
          return body['data'] as Map<String, dynamic>?;
        }
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Admin Dashboard View',
        trigger: 'initState() / Refresh',
        functionName: 'getAdminDashboard',
        method: 'GET',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> getSalesAgents({String? role, required String token}) async {
    final stopwatch = Stopwatch()..start();
    String url = 'https://api.mediseba.org/api/v1/sales-agents';
    if (role != null && role.isNotEmpty) {
      url += '?role=$role';
    }
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Admin Sales Agents View',
      trigger: 'initState() / Filter Role',
      functionName: 'getSalesAgents',
      isUserAction: role != null,
      method: 'GET',
      url: url,
      headers: headers,
    );

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 8));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true || body['status'] == 'success') {
          final List list = body['data'] ?? [];
          return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Admin Sales Agents View',
        trigger: 'initState() / Filter Role',
        functionName: 'getSalesAgents',
        method: 'GET',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> getSupervisors(String token) async {
    final stopwatch = Stopwatch()..start();
    const url = 'https://api.mediseba.org/api/v1/sales-agents/supervisors';
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Supervisors List',
      trigger: 'Dropdown Init',
      functionName: 'getSupervisors',
      isUserAction: false,
      method: 'GET',
      url: url,
      headers: headers,
    );

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 8));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true || body['status'] == 'success') {
          final List list = body['data'] ?? [];
          return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Supervisors List',
        trigger: 'Dropdown Init',
        functionName: 'getSupervisors',
        method: 'GET',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }
    return null;
  }

  static Future<bool> createSalesAgent({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    int? supervisorId,
    required String token,
  }) async {
    final stopwatch = Stopwatch()..start();
    const url = 'https://api.mediseba.org/api/v1/sales-agents';
    final payload = {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
      if (supervisorId != null) 'supervisor_id': supervisorId,
    };
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Create Sales Agent Form',
      trigger: 'Create Agent Button',
      functionName: 'createSalesAgent',
      isUserAction: true,
      method: 'POST',
      url: url,
      headers: headers,
      body: payload,
    );

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 8));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['success'] == true || body['status'] == 'success';
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Create Sales Agent Form',
        trigger: 'Create Agent Button',
        functionName: 'createSalesAgent',
        method: 'POST',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }
    return false;
  }

  static Future<bool> assignSupervisor({
    required int userId,
    required int supervisorId,
    required String token,
  }) async {
    final stopwatch = Stopwatch()..start();
    final url = 'https://api.mediseba.org/api/v1/sales-agents/$userId/assign-supervisor';
    final payload = {
      'supervisor_id': supervisorId,
    };
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Sales Agent Details',
      trigger: 'Assign Supervisor Button',
      functionName: 'assignSupervisor',
      isUserAction: true,
      method: 'PATCH',
      url: url,
      headers: headers,
      body: payload,
    );

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 8));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['success'] == true || body['status'] == 'success';
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Sales Agent Details',
        trigger: 'Assign Supervisor Button',
        functionName: 'assignSupervisor',
        method: 'PATCH',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }
    return false;
  }

  static Future<bool> updateAgentRole({
    required int userId,
    required String role,
    required String token,
  }) async {
    final stopwatch = Stopwatch()..start();
    final url = 'https://api.mediseba.org/api/v1/sales-agents/$userId/role';
    final payload = {
      'role': role,
    };
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Sales Agent Details',
      trigger: 'Update Role Button',
      functionName: 'updateAgentRole',
      isUserAction: true,
      method: 'PATCH',
      url: url,
      headers: headers,
      body: payload,
    );

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 8));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['success'] == true || body['status'] == 'success';
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Sales Agent Details',
        trigger: 'Update Role Button',
        functionName: 'updateAgentRole',
        method: 'PATCH',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }
    return false;
  }

  static Future<bool> deleteSalesAgent({
    required int userId,
    required String token,
  }) async {
    final stopwatch = Stopwatch()..start();
    const url = 'https://api.mediseba.org/api/v1/sales-agents';
    final payload = {
      'user_id': userId,
    };
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Sales Agent Management',
      trigger: 'Delete Agent Button',
      functionName: 'deleteSalesAgent',
      isUserAction: true,
      method: 'DELETE',
      url: url,
      headers: headers,
      body: payload,
    );

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 8));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['success'] == true || body['status'] == 'success';
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Sales Agent Management',
        trigger: 'Delete Agent Button',
        functionName: 'deleteSalesAgent',
        method: 'DELETE',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }
    return false;
  }

  static Future<List<Map<String, dynamic>>> getAdminDoctors({
    required String token,
    String? search,
    int page = 1,
    int perPage = 15,
  }) async {
    final stopwatch = Stopwatch()..start();
    String url = 'https://api.mediseba.org/api/v1/admin/doctors?page=$page&per_page=$perPage';
    if (search != null && search.trim().isNotEmpty) {
      url += '&search=${Uri.encodeComponent(search.trim())}';
    }
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Admin Doctors Management',
      trigger: search != null ? 'Search Input' : 'initState()',
      functionName: 'getAdminDoctors',
      isUserAction: search != null,
      method: 'GET',
      url: url,
      headers: headers,
    );

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 8));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] is List) {
          return List<Map<String, dynamic>>.from(
            (body['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)),
          );
        }
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Admin Doctors Management',
        trigger: 'initState()',
        functionName: 'getAdminDoctors',
        method: 'GET',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }
    return [];
  }

  static Future<bool> createAdminDoctor({
    required String token,
    required Map<String, dynamic> payload,
  }) async {
    final stopwatch = Stopwatch()..start();
    const url = 'https://api.mediseba.org/api/v1/admin/doctors';
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Admin Doctors Management',
      trigger: 'Add Doctor Button',
      functionName: 'createAdminDoctor',
      isUserAction: true,
      method: 'POST',
      url: url,
      headers: headers,
      body: payload,
    );

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 8));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['success'] == true;
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Admin Doctors Management',
        trigger: 'Add Doctor Button',
        functionName: 'createAdminDoctor',
        method: 'POST',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }
    return false;
  }

  static Future<bool> updateAdminDoctor({
    required String token,
    required Map<String, dynamic> payload,
  }) async {
    final stopwatch = Stopwatch()..start();
    const url = 'https://api.mediseba.org/api/v1/admin/doctors';
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Admin Doctors Management',
      trigger: 'Update Doctor Button',
      functionName: 'updateAdminDoctor',
      isUserAction: true,
      method: 'PUT',
      url: url,
      headers: headers,
      body: payload,
    );

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 8));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['success'] == true;
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Admin Doctors Management',
        trigger: 'Update Doctor Button',
        functionName: 'updateAdminDoctor',
        method: 'PUT',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }
    return false;
  }

  static Future<bool> deleteAdminDoctor({
    required String token,
    required String idOrUuid,
  }) async {
    final stopwatch = Stopwatch()..start();
    final url = 'https://api.mediseba.org/api/v1/admin/doctors?id=$idOrUuid';
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Admin Doctors Management',
      trigger: 'Delete Doctor Button',
      functionName: 'deleteAdminDoctor',
      isUserAction: true,
      method: 'DELETE',
      url: url,
      headers: headers,
    );

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 8));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['success'] == true;
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Admin Doctors Management',
        trigger: 'Delete Doctor Button',
        functionName: 'deleteAdminDoctor',
        method: 'DELETE',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }
    return false;
  }

  // ===========================================================================
  // 🌐 HBP PORTAL API ENDPOINTS (Developer Documentation Integration)
  // ===========================================================================

  static Future<Map<String, dynamic>?> fetchHbpMetrics(String token) async {
    final stopwatch = Stopwatch()..start();
    var url = '$baseUrl/hbp/metrics';
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'HBP Agent Dashboard',
      trigger: 'initState() / Metrics Sync',
      functionName: 'fetchHbpMetrics',
      isUserAction: false,
      method: 'GET',
      url: url,
      headers: headers,
    );

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 8));

      stopwatch.stop();

      if (response.statusCode == 200) {
        ApiLogger.logResponse(
          requestId: reqId,
          statusCode: response.statusCode,
          body: response.body,
          durationMs: stopwatch.elapsedMilliseconds,
        );
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == 'success' || body['success'] == true) {
          return body['data'] as Map<String, dynamic>?;
        }
      }

      // Try fallback endpoint: /hbp/dashboard
      url = '$baseUrl/hbp/dashboard';
      final fallbackStopwatch = Stopwatch()..start();
      final fallbackReqId = ApiLogger.logRequest(
        screen: 'HBP Agent Dashboard (Fallback)',
        trigger: 'Primary Endpoint Failed (500)',
        functionName: 'fetchHbpMetricsFallback',
        isUserAction: false,
        method: 'GET',
        url: url,
        headers: headers,
      );

      response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 8));

      fallbackStopwatch.stop();

      ApiLogger.logResponse(
        requestId: fallbackReqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: fallbackStopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == 'success' || body['success'] == true) {
          return body['data'] as Map<String, dynamic>?;
        }
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'HBP Agent Dashboard',
        trigger: 'initState() / Metrics Sync',
        functionName: 'fetchHbpMetrics',
        method: 'GET',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }
    return null;
  }

  static Future<Map<String, dynamic>> registerPatientByHbp({
    required String token,
    required String name,
    required String phone,
    required String password,
    String? email,
    required String packageId,
    required String paymentMethod,
  }) async {
    final stopwatch = Stopwatch()..start();
    final url = '$baseUrl/hbp/register-patient';
    final payload = {
      'name': name,
      'phone': phone,
      'password': password,
      if (email != null && email.isNotEmpty) 'email': email,
      'package_id': packageId,
      'payment_method': paymentMethod,
    };
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'HBP Register Customer Dialog',
      trigger: 'অ্যাকাউন্ট ও প্যাকেজ নিশ্চিত করুন',
      functionName: 'registerPatientByHbp',
      isUserAction: true,
      method: 'POST',
      url: url,
      headers: headers,
      body: payload,
    );

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 10));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

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
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'HBP Register Customer Dialog',
        trigger: 'অ্যাকাউন্ট ও প্যাকেজ নিশ্চিত করুন',
        functionName: 'registerPatientByHbp',
        method: 'POST',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
      return {
        'success': false,
        'message': 'নেটওয়ার্ক ত্রুটি: $e',
      };
    }
  }

  static Future<List<Map<String, dynamic>>> fetchHealthPackages() async {
    final stopwatch = Stopwatch()..start();
    final url = '$baseUrl/packages';
    final headers = {
      'Accept': 'application/json',
      'User-Agent': 'MediSebaApp/1.0',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Health Packages List',
      trigger: 'initState() / Dialog Load',
      functionName: 'fetchHealthPackages',
      isUserAction: false,
      method: 'GET',
      url: url,
      headers: headers,
    );

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 8));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['data'] is List) {
          return List<Map<String, dynamic>>.from(body['data'] as List);
        }
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Health Packages List',
        trigger: 'initState() / Dialog Load',
        functionName: 'fetchHealthPackages',
        method: 'GET',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }
    return [];
  }

  static Future<Map<String, dynamic>?> fetchHbpProfile(String token) async {
    final stopwatch = Stopwatch()..start();
    final url = '$baseUrl/user/profile';
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'HBP Agent Profile View',
      trigger: 'initState() / Drawer Sync',
      functionName: 'fetchHbpProfile',
      isUserAction: false,
      method: 'GET',
      url: url,
      headers: headers,
    );

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 8));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['data'] as Map<String, dynamic>?;
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'HBP Agent Profile View',
        trigger: 'initState() / Drawer Sync',
        functionName: 'fetchHbpProfile',
        method: 'GET',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }
    return null;
  }

  /// Fetch Patient Dashboard & Overview metrics from API: GET /patient/dashboard
  static Future<Map<String, dynamic>?> fetchPatientDashboard(String token) async {
    final stopwatch = Stopwatch()..start();
    final String url = '$baseUrl/patient/dashboard';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Patient Portal View',
      trigger: 'initState() / Dynamic Fetch',
      functionName: 'fetchPatientDashboard',
      isUserAction: false,
      method: 'GET',
      url: url,
      headers: headers,
    );

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 8));

      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 'success' || body['data'] != null) {
          return Map<String, dynamic>.from(body['data'] ?? body);
        }
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Patient Portal View',
        trigger: 'initState() / Dynamic Fetch',
        functionName: 'fetchPatientDashboard',
        method: 'GET',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }
    return null;
  }
}
