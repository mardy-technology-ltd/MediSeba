import 'dart:convert';
import 'package:flutter/foundation.dart';

class ApiLogger {
  static int _requestIdCounter = 0;
  static final Map<String, DateTime> _recentRequests = {};
  static final Map<int, String> _requestScreen = {};
  static final Map<int, String> _requestButton = {};
  static final Map<int, String> _requestFunction = {};
  static final Map<int, bool> _requestIsUserAction = {};

  /// Generate next unique Request ID
  static int nextRequestId() {
    _requestIdCounter++;
    return _requestIdCounter;
  }

  /// Format Request ID to 3 digits (e.g., #001)
  static String formatId(int id) {
    return '#${id.toString().padLeft(3, '0')}';
  }

  /// Redact sensitive information from headers, body, or strings
  static String _redactSensitiveData(String input) {
    var text = input;

    // Redact Bearer Tokens in headers
    text = text.replaceAll(
      RegExp(r'Bearer\s+[A-Za-z0-9\-\._~+\/]+=*', caseSensitive: false),
      'Bearer {TOKEN}',
    );

    // Redact sensitive JSON fields
    text = text.replaceAll(
      RegExp(r'"(password|token|access_token|refresh_token|auth_token|api_key|secret)"\s*:\s*"[^"]*"', caseSensitive: false),
      r'"$1": "{REDACTED}"',
    );
    text = text.replaceAll(
      RegExp(r'"(password|token|access_token|refresh_token|auth_token|api_key|secret)"\s*:\s*\d+', caseSensitive: false),
      r'"$1": "{REDACTED}"',
    );

    return text;
  }

  /// Format JSON nicely with 2 spaces indent
  static String _formatJson(dynamic data) {
    if (data == null) return 'null';
    try {
      if (data is String) {
        final decoded = jsonDecode(data);
        return const JsonEncoder.withIndent('  ').convert(decoded);
      }
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  /// Helper to extract Base URL and Endpoint
  static Map<String, String> parseUrl(String fullUrl) {
    try {
      final uri = Uri.parse(fullUrl);
      final baseUrl = '${uri.scheme}://${uri.host}${uri.hasPort && uri.port != 80 && uri.port != 443 ? ':${uri.port}' : ''}';
      final endpoint = uri.path + (uri.hasQuery ? '?${uri.query}' : '');
      return {
        'baseUrl': baseUrl,
        'endpoint': endpoint,
        'fullUrl': fullUrl,
      };
    } catch (_) {
      return {
        'baseUrl': '',
        'endpoint': fullUrl,
        'fullUrl': fullUrl,
      };
    }
  }

  /// Log User Action or Automatic Trigger
  static int logAction({
    required String screen,
    required String trigger,
    required String functionName,
    bool isUserAction = true,
  }) {
    final requestId = nextRequestId();
    _requestScreen[requestId] = screen;
    _requestButton[requestId] = trigger;
    _requestFunction[requestId] = functionName;
    _requestIsUserAction[requestId] = isUserAction;

    return requestId;
  }

  /// Log API Request
  static int logRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
    int? requestId,
    String? screen,
    String? trigger,
    String? functionName,
    bool isUserAction = true,
  }) {
    final reqId = requestId ?? nextRequestId();

    final screenName = screen ?? _requestScreen[reqId] ?? 'System Service';
    final buttonName = trigger ?? _requestButton[reqId] ?? 'Automatic Call';
    final funcName = functionName ?? _requestFunction[reqId] ?? 'executeApiCall()';
    final userActionFlag = isUserAction && (_requestIsUserAction[reqId] ?? isUserAction);

    final actionHeader = userActionFlag ? '🔘 USER ACTION' : '🔄 AUTOMATIC API CALL';

    debugPrint('');
    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('$actionHeader');
    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('Screen       : $screenName');
    debugPrint('${userActionFlag ? 'Button      ' : 'Trigger     '} : $buttonName');
    debugPrint('Function     : $funcName()');

    // Duplicate detection check
    final reqKey = '${method.toUpperCase()}:$url';
    if (_recentRequests.containsKey(reqKey)) {
      final prevTime = _recentRequests[reqKey]!;
      final diff = DateTime.now().difference(prevTime);
      if (diff.inSeconds < 2) {
        debugPrint('');
        debugPrint('⚠️ POSSIBLE DUPLICATE API CALL');
        debugPrint('URL              : $url');
        debugPrint('Time Since Prev  : ${diff.inMilliseconds} ms');
        debugPrint('Possible Reason  : Screen initialization or listener triggered the API twice.');
      }
    }
    _recentRequests[reqKey] = DateTime.now();

    final urlParts = parseUrl(url);

    debugPrint('');
    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('📤 API REQUEST ${formatId(reqId)}');
    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('Method       : ${method.toUpperCase()}');
    debugPrint('Base URL     : ${urlParts['baseUrl']}');
    debugPrint('Endpoint     : ${urlParts['endpoint']}');
    debugPrint('FULL URL     : ${urlParts['fullUrl']}');
    debugPrint('');

    if (headers != null && headers.isNotEmpty) {
      debugPrint('Headers:');
      headers.forEach((key, value) {
        final redactedValue = _redactSensitiveData(value);
        debugPrint('  $key: $redactedValue');
      });
      debugPrint('');
    }

    if (body != null && body.toString().isNotEmpty && body.toString() != '{}') {
      debugPrint('Request Body:');
      final formattedBody = _redactSensitiveData(_formatJson(body));
      debugPrint(formattedBody);
      debugPrint('');
    }

    return reqId;
  }

  /// Log API Response
  static void logResponse({
    required int requestId,
    required int statusCode,
    required String body,
    required int durationMs,
  }) {
    final screenName = _requestScreen[requestId] ?? 'App Context';
    final buttonName = _requestButton[requestId] ?? 'User Action / Auto';
    final funcName = _requestFunction[requestId] ?? 'apiCall()';
    final userActionFlag = _requestIsUserAction[requestId] ?? true;

    debugPrint('');
    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('📥 API RESPONSE ${formatId(requestId)}');
    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('Screen       : $screenName');
    debugPrint('${userActionFlag ? 'Button      ' : 'Trigger     '} : $buttonName');
    debugPrint('Function     : $funcName()');
    debugPrint('Status Code  : $statusCode');
    debugPrint('Response Time: $durationMs ms');
    debugPrint('');
    debugPrint('Response Body:');
    debugPrint(_redactSensitiveData(_formatJson(body)));
    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('');
  }

  /// Log API Error
  static void logError({
    required int requestId,
    required String method,
    required String url,
    required int statusCode,
    dynamic errorResponse,
    required int durationMs,
    String? errorDetails,
    String? screen,
    String? trigger,
    String? functionName,
  }) {
    final screenName = screen ?? _requestScreen[requestId] ?? 'App Context';
    final buttonName = trigger ?? _requestButton[requestId] ?? 'User Action / Auto';
    final funcName = functionName ?? _requestFunction[requestId] ?? 'apiCall()';

    debugPrint('');
    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('❌ API ERROR ${formatId(requestId)}');
    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('Screen       : $screenName');
    debugPrint('Button/Action: $buttonName');
    debugPrint('Function     : $funcName()');
    debugPrint('Method       : ${method.toUpperCase()}');
    debugPrint('FULL URL     : $url');
    debugPrint('Status Code  : $statusCode');
    debugPrint('Response Time: $durationMs ms');
    if (errorDetails != null && errorDetails.isNotEmpty) {
      debugPrint('Exception    : $errorDetails');
    }
    debugPrint('');
    if (errorResponse != null) {
      debugPrint('Error Response:');
      debugPrint(_redactSensitiveData(_formatJson(errorResponse)));
    }
    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('');
  }
}
