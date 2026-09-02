import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/geo_models.dart';
import '../services/cache_service.dart';
import '../utils/api_logger.dart';

class GeoRepository {
  static const String baseUrl = 'https://geo-bd-apis.onrender.com/api';
  static const Duration _geoTTL = Duration(days: 7);

  List<GeoDivision>? _cachedDivisions;
  final Map<int, List<GeoDistrict>> _cachedDistricts = {};
  final Map<int, List<GeoUpazila>> _cachedUpazilas = {};
  final Map<int, List<GeoUnion>> _cachedUnions = {};

  Future<List<GeoDivision>> getDivisions() async {
    if (_cachedDivisions != null) return _cachedDivisions!;

    const cacheKey = 'geo_divisions';
    if (!CacheService.isExpired(cacheKey, _geoTTL)) {
      final cached = CacheService.get(cacheKey);
      if (cached is List && cached.isNotEmpty) {
        _cachedDivisions = cached.map((e) => GeoDivision.fromJson(Map<String, dynamic>.from(e as Map))).toList();
        return _cachedDivisions!;
      }
    }

    final stopwatch = Stopwatch()..start();
    const url = '$baseUrl/divisions';
    final reqId = ApiLogger.logRequest(
      screen: 'Location Selector',
      trigger: 'Division Dropdown Load',
      functionName: 'getDivisions',
      isUserAction: false,
      method: 'GET',
      url: url,
    );

    try {
      final response = await http.get(Uri.parse(url));
      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        final List data = parsed is List ? parsed : (parsed['data'] ?? parsed['divisions'] ?? []);
        _cachedDivisions = data.map((e) => GeoDivision.fromJson(e)).toList();
        await CacheService.put(cacheKey, data);
        return _cachedDivisions!;
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Location Selector',
        trigger: 'Division Dropdown Load',
        functionName: 'getDivisions',
        method: 'GET',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }

    final cached = CacheService.get(cacheKey);
    if (cached is List && cached.isNotEmpty) {
      _cachedDivisions = cached.map((e) => GeoDivision.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      return _cachedDivisions!;
    }

    throw Exception('Network error loading divisions');
  }

  Future<List<GeoDistrict>> getDistricts(int divisionId) async {
    if (_cachedDistricts.containsKey(divisionId)) {
      return _cachedDistricts[divisionId]!;
    }

    final cacheKey = 'geo_districts_$divisionId';
    if (!CacheService.isExpired(cacheKey, _geoTTL)) {
      final cached = CacheService.get(cacheKey);
      if (cached is List && cached.isNotEmpty) {
        final districts = cached.map((e) => GeoDistrict.fromJson(Map<String, dynamic>.from(e as Map))).toList();
        _cachedDistricts[divisionId] = districts;
        return districts;
      }
    }

    final stopwatch = Stopwatch()..start();
    final url = '$baseUrl/districts?division_id=$divisionId';
    final reqId = ApiLogger.logRequest(
      screen: 'Location Selector',
      trigger: 'Division Selection',
      functionName: 'getDistricts',
      isUserAction: true,
      method: 'GET',
      url: url,
    );

    try {
      final response = await http.get(Uri.parse(url));
      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        final List data = parsed is List ? parsed : (parsed['data'] ?? parsed['districts'] ?? []);
        final districts = data.map((e) => GeoDistrict.fromJson(e)).toList();
        _cachedDistricts[divisionId] = districts;
        await CacheService.put(cacheKey, data);
        return districts;
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Location Selector',
        trigger: 'Division Selection',
        functionName: 'getDistricts',
        method: 'GET',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }

    final cached = CacheService.get(cacheKey);
    if (cached is List && cached.isNotEmpty) {
      final districts = cached.map((e) => GeoDistrict.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      _cachedDistricts[divisionId] = districts;
      return districts;
    }

    throw Exception('Network error loading districts');
  }

  Future<List<GeoUpazila>> getUpazilas(int districtId) async {
    if (_cachedUpazilas.containsKey(districtId)) {
      return _cachedUpazilas[districtId]!;
    }

    final cacheKey = 'geo_upazilas_$districtId';
    if (!CacheService.isExpired(cacheKey, _geoTTL)) {
      final cached = CacheService.get(cacheKey);
      if (cached is List && cached.isNotEmpty) {
        final upazilas = cached.map((e) => GeoUpazila.fromJson(Map<String, dynamic>.from(e as Map))).toList();
        _cachedUpazilas[districtId] = upazilas;
        return upazilas;
      }
    }

    final stopwatch = Stopwatch()..start();
    final url = '$baseUrl/upazilas?district_id=$districtId';
    final reqId = ApiLogger.logRequest(
      screen: 'Location Selector',
      trigger: 'District Selection',
      functionName: 'getUpazilas',
      isUserAction: true,
      method: 'GET',
      url: url,
    );

    try {
      final response = await http.get(Uri.parse(url));
      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        final List data = parsed is List ? parsed : (parsed['data'] ?? parsed['upazilas'] ?? []);
        final upazilas = data.map((e) => GeoUpazila.fromJson(e)).toList();
        _cachedUpazilas[districtId] = upazilas;
        await CacheService.put(cacheKey, data);
        return upazilas;
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Location Selector',
        trigger: 'District Selection',
        functionName: 'getUpazilas',
        method: 'GET',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }

    final cached = CacheService.get(cacheKey);
    if (cached is List && cached.isNotEmpty) {
      final upazilas = cached.map((e) => GeoUpazila.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      _cachedUpazilas[districtId] = upazilas;
      return upazilas;
    }

    throw Exception('Network error loading upazilas');
  }

  Future<List<GeoUnion>> getUnions(int upazilaId) async {
    if (_cachedUnions.containsKey(upazilaId)) {
      return _cachedUnions[upazilaId]!;
    }

    final cacheKey = 'geo_unions_$upazilaId';
    if (!CacheService.isExpired(cacheKey, _geoTTL)) {
      final cached = CacheService.get(cacheKey);
      if (cached is List && cached.isNotEmpty) {
        final unions = cached.map((e) => GeoUnion.fromJson(Map<String, dynamic>.from(e as Map))).toList();
        _cachedUnions[upazilaId] = unions;
        return unions;
      }
    }

    final stopwatch = Stopwatch()..start();
    final url = '$baseUrl/unions?upazila_id=$upazilaId';
    final reqId = ApiLogger.logRequest(
      screen: 'Location Selector',
      trigger: 'Upazila Selection',
      functionName: 'getUnions',
      isUserAction: true,
      method: 'GET',
      url: url,
    );

    try {
      final response = await http.get(Uri.parse(url));
      stopwatch.stop();

      ApiLogger.logResponse(
        requestId: reqId,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        final List data = parsed is List ? parsed : (parsed['data'] ?? parsed['unions'] ?? []);
        final unions = data.map((e) => GeoUnion.fromJson(e)).toList();
        _cachedUnions[upazilaId] = unions;
        await CacheService.put(cacheKey, data);
        return unions;
      }
    } catch (e) {
      stopwatch.stop();
      ApiLogger.logError(
        requestId: reqId,
        screen: 'Location Selector',
        trigger: 'Upazila Selection',
        functionName: 'getUnions',
        method: 'GET',
        url: url,
        statusCode: 500,
        errorDetails: e.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
      );
    }

    final cached = CacheService.get(cacheKey);
    if (cached is List && cached.isNotEmpty) {
      final unions = cached.map((e) => GeoUnion.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      _cachedUnions[upazilaId] = unions;
      return unions;
    }

    throw Exception('Network error loading unions');
  }
}
