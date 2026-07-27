import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/geo_models.dart';

class GeoRepository {
  static const String baseUrl = 'https://geo-bd-apis.onrender.com/api';

  // Memory Cache
  List<GeoDivision>? _cachedDivisions;
  final Map<int, List<GeoDistrict>> _cachedDistricts = {};
  final Map<int, List<GeoUpazila>> _cachedUpazilas = {};
  final Map<int, List<GeoUnion>> _cachedUnions = {};

  // Fetch Divisions
  Future<List<GeoDivision>> getDivisions() async {
    if (_cachedDivisions != null) return _cachedDivisions!;

    try {
      final response = await http.get(Uri.parse('$baseUrl/divisions'));
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        final List data = parsed is List ? parsed : (parsed['data'] ?? parsed['divisions'] ?? []);
        _cachedDivisions = data.map((e) => GeoDivision.fromJson(e)).toList();
        return _cachedDivisions!;
      } else {
        throw Exception('Failed to load divisions');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Fetch Districts by Division ID
  Future<List<GeoDistrict>> getDistricts(int divisionId) async {
    if (_cachedDistricts.containsKey(divisionId)) {
      return _cachedDistricts[divisionId]!;
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/districts?division_id=$divisionId'));
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        final List data = parsed is List ? parsed : (parsed['data'] ?? parsed['districts'] ?? []);
        final districts = data.map((e) => GeoDistrict.fromJson(e)).toList();
        _cachedDistricts[divisionId] = districts;
        return districts;
      } else {
        throw Exception('Failed to load districts');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Fetch Upazilas by District ID
  Future<List<GeoUpazila>> getUpazilas(int districtId) async {
    if (_cachedUpazilas.containsKey(districtId)) {
      return _cachedUpazilas[districtId]!;
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/upazilas?district_id=$districtId'));
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        final List data = parsed is List ? parsed : (parsed['data'] ?? parsed['upazilas'] ?? []);
        final upazilas = data.map((e) => GeoUpazila.fromJson(e)).toList();
        _cachedUpazilas[districtId] = upazilas;
        return upazilas;
      } else {
        throw Exception('Failed to load upazilas');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Fetch Unions by Upazila ID
  Future<List<GeoUnion>> getUnions(int upazilaId) async {
    if (_cachedUnions.containsKey(upazilaId)) {
      return _cachedUnions[upazilaId]!;
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/unions?upazila_id=$upazilaId'));
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        final List data = parsed is List ? parsed : (parsed['data'] ?? parsed['unions'] ?? []);
        final unions = data.map((e) => GeoUnion.fromJson(e)).toList();
        _cachedUnions[upazilaId] = unions;
        return unions;
      } else {
        throw Exception('Failed to load unions');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
