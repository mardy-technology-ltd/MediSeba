import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static const String boxName = 'mediseba_cache';
  static Box? _box;

  /// Initialize Hive and open the default cache box
  static Future<void> init() async {
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox(boxName);
      debugPrint('HiveCacheService initialized successfully.');
    } catch (e) {
      debugPrint('Error initializing HiveCacheService: $e');
    }
  }

  static Box get _getBox {
    if (_box == null || !_box!.isOpen) {
      throw Exception('HiveCacheService box is not opened yet. Call CacheService.init() first.');
    }
    return _box!;
  }

  /// Save JSON data or primitive value with timestamp
  static Future<void> put(String key, dynamic data) async {
    try {
      final payload = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'data': data is String ? data : jsonEncode(data),
      };
      await _getBox.put(key, payload);
    } catch (e) {
      debugPrint('CacheService.put error for key $key: $e');
    }
  }

  /// Read cached data
  static dynamic get(String key) {
    try {
      if (!_getBox.containsKey(key)) return null;
      final payload = _getBox.get(key);
      if (payload is Map) {
        final rawData = payload['data'];
        if (rawData is String) {
          try {
            return jsonDecode(rawData);
          } catch (_) {
            return rawData;
          }
        }
        return rawData;
      }
      return payload;
    } catch (e) {
      debugPrint('CacheService.get error for key $key: $e');
      return null;
    }
  }

  /// Check if cached data for [key] has exceeded [ttl]
  static bool isExpired(String key, Duration ttl) {
    try {
      if (!_getBox.containsKey(key)) return true;
      final payload = _getBox.get(key);
      if (payload is Map && payload.containsKey('timestamp')) {
        final int timestamp = payload['timestamp'] as int;
        final savedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        return DateTime.now().difference(savedTime) > ttl;
      }
      return true;
    } catch (e) {
      return true;
    }
  }

  /// Delete cached key
  static Future<void> delete(String key) async {
    try {
      await _getBox.delete(key);
    } catch (e) {
      debugPrint('CacheService.delete error: $e');
    }
  }

  /// Clear all cache
  static Future<void> clearAll() async {
    try {
      await _getBox.clear();
    } catch (e) {
      debugPrint('CacheService.clearAll error: $e');
    }
  }
}
