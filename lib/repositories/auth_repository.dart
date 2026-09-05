import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../services/cache_service.dart';
import '../utils/api_logger.dart';

class AuthRepository {
  static const String baseUrl = 'https://api.mediseba.org/api/v1';
  
  String? _token;
  String? _loginIdentifier;
  UserModel? _currentUserData;

  String? get token => _token;
  String? get loginIdentifier => _loginIdentifier;
  UserModel? get currentUserData => _currentUserData;

  AuthRepository() {
    _loadSession();
  }

  void _loadSession() {
    try {
      _token = CacheService.get('auth_token') as String?;
      _loginIdentifier = CacheService.get('auth_login_identifier') as String?;
      final cachedUser = CacheService.get('auth_user');
      if (cachedUser != null) {
        _currentUserData = UserModel.fromMap(
          Map<String, dynamic>.from(cachedUser as Map),
          cachedUser['uid'] ?? 'user_id',
        );
      }
    } catch (e) {
      debugPrint('Error loading auth session: $e');
    }
  }

  Future<bool> login(String emailOrPhone, String password) async {
    final stopwatch = Stopwatch()..start();
    final String url = '$baseUrl/auth/login';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final Map<String, dynamic> payload = {
      'login': emailOrPhone,
      'password': password,
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Login View',
      trigger: 'Login Button',
      functionName: 'login',
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

      final Map<String, dynamic> body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = body['token'] ?? body['data']?['token'];
        final userJson = body['user'] ?? body['data']?['user'];
        
        if (token != null) {
          _token = token.toString();
          _loginIdentifier = emailOrPhone;
          await CacheService.put('auth_token', _token);
          await CacheService.put('auth_login_identifier', _loginIdentifier);

          if (userJson != null) {
            final Map<String, dynamic> map = Map<String, dynamic>.from(userJson as Map);
            final String uid = map['id']?.toString() ?? map['uuid']?.toString() ?? 'user_id';
            final String role = map['role']?.toString() ??
                map['user_type']?.toString() ??
                map['type']?.toString() ??
                (emailOrPhone.toLowerCase().contains('hbp') ? 'hbp' : 'patient');

            _currentUserData = UserModel(
              uid: uid,
              name: map['name']?.toString() ?? 'User',
              phone: map['phone']?.toString() ?? emailOrPhone,
              division: map['division']?.toString() ?? '',
              district: map['district']?.toString() ?? '',
              upazila: map['upazila']?.toString() ?? '',
              union: map['union']?.toString() ?? '',
              referId: map['referId']?.toString(),
              profileImageUrl: map['profileImageUrl']?.toString() ?? map['avatar']?.toString(),
              role: role,
              createdAt: DateTime.now(),
            );
            await CacheService.put('auth_user_role', role);
          } else {
            final String inferredRole = emailOrPhone.toLowerCase().contains('hbp') ? 'hbp' : 'patient';
            _currentUserData = UserModel(
              uid: 'user_id',
              name: 'User',
              phone: emailOrPhone,
              division: '',
              district: '',
              upazila: '',
              union: '',
              role: inferredRole,
              createdAt: DateTime.now(),
            );
            await CacheService.put('auth_user_role', inferredRole);
          }
          await CacheService.put('auth_user', _currentUserData!.toMap());
          return true;
        }
      }
      
      final msg = body['message'] ?? body['error'] ?? 'Login failed';
      throw Exception(msg);
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Login View',
        trigger: 'Login Button',
        functionName: 'login',
        method: 'POST',
        url: url,
        statusCode: 401,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
      rethrow;
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
    final stopwatch = Stopwatch()..start();
    final String url = '$baseUrl/auth/register';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final Map<String, dynamic> payload = {
      'name': name,
      'email': phone.contains('@') ? phone : '$phone@mediseba.com',
      'phone': phone,
      'password': password,
      'password_confirmation': password,
    };

    final reqId = ApiLogger.logRequest(
      screen: 'Register View',
      trigger: 'Register Button',
      functionName: 'signUp',
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

      final Map<String, dynamic> body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = body['token'] ?? body['data']?['token'];
        final userJson = body['user'] ?? body['data']?['user'];
        
        if (token != null) {
          _token = token.toString();
          _loginIdentifier = phone;
          await CacheService.put('auth_token', _token);
          await CacheService.put('auth_login_identifier', _loginIdentifier);

          _currentUserData = UserModel(
            uid: userJson?['id']?.toString() ?? userJson?['uid']?.toString() ?? 'user_id',
            name: name,
            phone: phone,
            division: division,
            district: district,
            upazila: upazila,
            union: union,
            referId: referId,
            createdAt: DateTime.now(),
          );
          await CacheService.put('auth_user', _currentUserData!.toMap());
          return true;
        }
      }

      final msg = body['message'] ?? body['error'] ?? 'Registration failed';
      throw Exception(msg);
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Register View',
        trigger: 'Register Button',
        functionName: 'signUp',
        method: 'POST',
        url: url,
        statusCode: 400,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
      rethrow;
    }
  }

  Future<void> updateUserProfileImage(String uid, String imageUrl) async {
    if (_currentUserData != null) {
      _currentUserData = UserModel(
        uid: _currentUserData!.uid,
        name: _currentUserData!.name,
        phone: _currentUserData!.phone,
        division: _currentUserData!.division,
        district: _currentUserData!.district,
        upazila: _currentUserData!.upazila,
        union: _currentUserData!.union,
        referId: _currentUserData!.referId,
        profileImageUrl: imageUrl,
        createdAt: _currentUserData!.createdAt,
      );
      await CacheService.put('auth_user', _currentUserData!.toMap());
    }
  }

  Future<void> updateUserProfile({
    required String uid,
    required String name,
    required String phone,
    required String division,
    required String district,
    required String upazila,
    required String union,
    String? referId,
  }) async {
    if (_currentUserData != null) {
      _currentUserData = UserModel(
        uid: uid,
        name: name,
        phone: phone,
        division: division,
        district: district,
        upazila: upazila,
        union: union,
        referId: referId ?? _currentUserData!.referId,
        profileImageUrl: _currentUserData!.profileImageUrl,
        createdAt: _currentUserData!.createdAt,
      );
      await CacheService.put('auth_user', _currentUserData!.toMap());
    }
  }

  Future<void> logout() async {
    _token = null;
    _loginIdentifier = null;
    _currentUserData = null;
    await CacheService.delete('auth_token');
    await CacheService.delete('auth_user');
    await CacheService.delete('auth_login_identifier');
    await CacheService.delete('has_seen_onboarding');
  }
}
