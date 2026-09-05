import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static const String boxName = 'mediseba_cache';
  static Box? _box;

  /// Flag to enable/disable local response cache DB connection (default: true)
  static bool isCacheEnabled = true;

  /// In-memory cache for active session parameters during app lifecycle
  static final Map<String, dynamic> _memoryCache = {};

  /// Keys that are critical session/auth data which must always stay persistent on disk
  static const Set<String> _sessionKeys = {
    'auth_token',
    'auth_user',
    'auth_user_role',
    'auth_login_identifier',
    'has_seen_onboarding',
  };

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

  /// Reconnect local database cache
  static void enableCache() {
    isCacheEnabled = true;
    debugPrint('Local Cache Database Reconnected.');
  }

  /// Disconnect local database cache
  static void disableCache() {
    isCacheEnabled = false;
    debugPrint('Local Cache Database Disconnected.');
  }

  static Box get _getBox {
    if (_box == null || !_box!.isOpen) {
      throw Exception('HiveCacheService box is not opened yet. Call CacheService.init() first.');
    }
    return _box!;
  }

  /// Save JSON data or primitive value with timestamp
  static Future<void> put(String key, dynamic data) async {
    // Always store in memory RAM for runtime availability
    _memoryCache[key] = data;

    if (!isCacheEnabled && !_sessionKeys.contains(key)) return;
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
    if (_memoryCache.containsKey(key)) {
      return _memoryCache[key];
    }
    if (!isCacheEnabled && !_sessionKeys.contains(key)) return null;
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
    if (!isCacheEnabled && !_sessionKeys.contains(key)) return true;
    try {
      if (!_getBox.containsKey(key)) return !_memoryCache.containsKey(key);
      final payload = _getBox.get(key);
      if (payload != null && payload is Map) {
        final rawTimestamp = payload['timestamp'];
        if (rawTimestamp != null) {
          final int timestamp = rawTimestamp is int
              ? rawTimestamp
              : (int.tryParse(rawTimestamp.toString()) ?? 0);
          if (timestamp > 0) {
            final savedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
            final difference = DateTime.now().difference(savedTime);
            final expired = difference > ttl;
            debugPrint('Cache check for key "$key": age=${difference.inSeconds}s, isExpired=$expired');
            return expired;
          }
        }
      }
      return !_memoryCache.containsKey(key);
    } catch (e) {
      debugPrint('CacheService.isExpired error for key $key: $e');
      return true;
    }
  }

  /// Delete cached key
  static Future<void> delete(String key) async {
    _memoryCache.remove(key);
    try {
      if (_box != null && _box!.isOpen) {
        await _getBox.delete(key);
      }
    } catch (e) {
      debugPrint('CacheService.delete error: $e');
    }
  }

  /// Clear all local cache
  static Future<void> clearAll() async {
    _memoryCache.clear();
    try {
      if (_box != null && _box!.isOpen) {
        await _getBox.clear();
      }
    } catch (e) {
      debugPrint('CacheService.clearAll error: $e');
    }
  }
}
