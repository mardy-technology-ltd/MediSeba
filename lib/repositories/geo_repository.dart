import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/geo_models.dart';
import '../services/cache_service.dart';

class GeoRepository {
  static const String baseUrl = 'https://geo-bd-apis.onrender.com/api';
  static const Duration _geoTTL = Duration(days: 7);

  // Memory Cache
  List<GeoDivision>? _cachedDivisions;
  final Map<int, List<GeoDistrict>> _cachedDistricts = {};
  final Map<int, List<GeoUpazila>> _cachedUpazilas = {};
  final Map<int, List<GeoUnion>> _cachedUnions = {};

  // Fetch Divisions
  Future<List<GeoDivision>> getDivisions() async {
    if (_cachedDivisions != null) return _cachedDivisions!;

    // Try Hive cache
    final cacheKey = 'geo_divisions';
    if (!CacheService.isExpired(cacheKey, _geoTTL)) {
      final cached = CacheService.get(cacheKey);
      if (cached is List && cached.isNotEmpty) {
        _cachedDivisions = cached.map((e) => GeoDivision.fromJson(Map<String, dynamic>.from(e as Map))).toList();
        return _cachedDivisions!;
      }
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/divisions'));
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        final List data = parsed is List ? parsed : (parsed['data'] ?? parsed['divisions'] ?? []);
        _cachedDivisions = data.map((e) => GeoDivision.fromJson(e)).toList();
        await CacheService.put(cacheKey, data);
        return _cachedDivisions!;
      }
    } catch (_) {}

    // Fallback to Hive cache even if expired
    final cached = CacheService.get(cacheKey);
    if (cached is List && cached.isNotEmpty) {
      _cachedDivisions = cached.map((e) => GeoDivision.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      return _cachedDivisions!;
    }

    throw Exception('Network error loading divisions');
  }

  // Fetch Districts by Division ID
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

    try {
      final response = await http.get(Uri.parse('$baseUrl/districts?division_id=$divisionId'));
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        final List data = parsed is List ? parsed : (parsed['data'] ?? parsed['districts'] ?? []);
        final districts = data.map((e) => GeoDistrict.fromJson(e)).toList();
        _cachedDistricts[divisionId] = districts;
        await CacheService.put(cacheKey, data);
        return districts;
      }
    } catch (_) {}

    final cached = CacheService.get(cacheKey);
    if (cached is List && cached.isNotEmpty) {
      final districts = cached.map((e) => GeoDistrict.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      _cachedDistricts[divisionId] = districts;
      return districts;
    }

    throw Exception('Network error loading districts');
  }

  // Fetch Upazilas by District ID
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

    try {
      final response = await http.get(Uri.parse('$baseUrl/upazilas?district_id=$districtId'));
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        final List data = parsed is List ? parsed : (parsed['data'] ?? parsed['upazilas'] ?? []);
        final upazilas = data.map((e) => GeoUpazila.fromJson(e)).toList();
        _cachedUpazilas[districtId] = upazilas;
        await CacheService.put(cacheKey, data);
        return upazilas;
      }
    } catch (_) {}

    final cached = CacheService.get(cacheKey);
    if (cached is List && cached.isNotEmpty) {
      final upazilas = cached.map((e) => GeoUpazila.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      _cachedUpazilas[districtId] = upazilas;
      return upazilas;
    }

    throw Exception('Network error loading upazilas');
  }

  // Fetch Unions by Upazila ID
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

    try {
      final response = await http.get(Uri.parse('$baseUrl/unions?upazila_id=$upazilaId'));
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        final List data = parsed is List ? parsed : (parsed['data'] ?? parsed['unions'] ?? []);
        final unions = data.map((e) => GeoUnion.fromJson(e)).toList();
        _cachedUnions[upazilaId] = unions;
        await CacheService.put(cacheKey, data);
        return unions;
      }
    } catch (_) {}

    final cached = CacheService.get(cacheKey);
    if (cached is List && cached.isNotEmpty) {
      final unions = cached.map((e) => GeoUnion.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      _cachedUnions[upazilaId] = unions;
      return unions;
    }

    throw Exception('Network error loading unions');
  }
}
