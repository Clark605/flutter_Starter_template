import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_starter/core/config/app_config.dart';
import 'package:flutter_starter/core/utils/app_logger.dart';

class SafeLoggingInterceptor extends Interceptor {
  static const Set<String> _sensitiveHeaders = {
    'authorization',
    'token',
    'x-api-key',
    'cookie',
    'set-cookie',
  };

  static const Set<String> _sensitiveBodyKeys = {
    'password',
    'token',
    'accesstoken',
    'refreshtoken',
    'secret',
    'creditcard',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kReleaseMode || !AppConfig.enableLogging) {
      return handler.next(options);
    }

    final sanitizedHeaders = _sanitizeHeaders(options.headers);
    final sanitizedData = _sanitizeData(options.data);

    AppLogger.debug(
      '🌐 REQUEST --> ${options.method} ${options.uri}\n'
      'Headers: $sanitizedHeaders\n'
      'Body: $sanitizedData',
      tag: 'HTTP',
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kReleaseMode || !AppConfig.enableLogging) {
      return handler.next(response);
    }

    final sanitizedData = _sanitizeData(response.data);

    AppLogger.debug(
      '🌐 RESPONSE <-- ${response.statusCode} ${response.requestOptions.uri}\n'
      'Body: $sanitizedData',
      tag: 'HTTP',
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    final uri = err.requestOptions.uri;

    AppLogger.warning(
      '🌐 ERROR <-- ${status ?? 'NO_RESPONSE'} $uri (${err.type}): ${err.message}',
      tag: 'HTTP',
      error: err,
    );

    handler.next(err);
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final result = <String, dynamic>{};
    for (final entry in headers.entries) {
      if (_sensitiveHeaders.contains(entry.key.toLowerCase())) {
        result[entry.key] = '[REDACTED]';
      } else {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }

  dynamic _sanitizeData(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      final sanitized = <String, dynamic>{};
      for (final entry in data.entries) {
        final key = entry.key.toString();
        if (_sensitiveBodyKeys.contains(key.toLowerCase())) {
          sanitized[key] = '[REDACTED]';
        } else if (entry.value is Map || entry.value is List) {
          sanitized[key] = _sanitizeData(entry.value);
        } else {
          sanitized[key] = entry.value;
        }
      }
      return sanitized;
    }
    if (data is List) {
      return data.map(_sanitizeData).toList();
    }
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        return jsonEncode(_sanitizeData(decoded));
      } on FormatException catch (_) {
        return data;
      }
    }
    return data;
  }
}
