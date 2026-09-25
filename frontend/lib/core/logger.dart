import 'dart:convert';
import 'package:flutter/foundation.dart';

enum LogLevel {
  debug(0, 'DEBUG'),
  info(1, 'INFO'),
  warn(2, 'WARN'),
  error(3, 'ERROR'),
  none(4, 'NONE');

  final int priority;
  final String label;
  const LogLevel(this.priority, this.label);

  static LogLevel fromString(String? level, {bool isProduction = false}) {
    switch (level?.toLowerCase().trim()) {
      case 'debug':
        return LogLevel.debug;
      case 'info':
        return LogLevel.info;
      case 'warn':
      case 'warning':
        return LogLevel.warn;
      case 'error':
        return LogLevel.error;
      case 'none':
      case 'off':
        return LogLevel.none;
      default:
        return (isProduction || kReleaseMode) ? LogLevel.error : LogLevel.debug;
    }
  }
}

class AppLogger {
  static LogLevel currentLevel = kReleaseMode ? LogLevel.error : LogLevel.debug;
  static bool isDevelopment = !kReleaseMode;

  static const Set<String> _sensitiveKeys = {
    'password',
    'token',
    'authorization',
    'secret',
    'apikey',
    'jwt',
    'refreshtoken',
  };

  static void initialize({String? environment, String? configuredLevel}) {
    final isProd = (environment ?? '').toLowerCase() == 'production' || kReleaseMode;
    isDevelopment = !isProd;
    currentLevel = LogLevel.fromString(configuredLevel, isProduction: isProd);
  }

  static void debug(String message, [dynamic data]) {
    _log(LogLevel.debug, message, data);
  }

  static void info(String message, [dynamic data]) {
    _log(LogLevel.info, message, data);
  }

  static void warn(String message, [dynamic data, StackTrace? stackTrace]) {
    _log(LogLevel.warn, message, data, stackTrace);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  static void logApiRequest({
    required String method,
    required Uri uri,
    Map<String, dynamic>? queryParams,
    dynamic body,
  }) {
    if (!isLevelEnabled(LogLevel.debug)) return;

    final sanitizedQuery = _sanitize(queryParams);
    final sanitizedBody = _sanitize(body);

    final buffer = StringBuffer();
    buffer.writeln('[API REQUEST] $method ${uri.path}');
    if (sanitizedQuery != null && sanitizedQuery.isNotEmpty) {
      buffer.writeln('  Query: ${_formatJson(sanitizedQuery)}');
    }
    if (sanitizedBody != null) {
      buffer.writeln('  Input: ${_formatJson(sanitizedBody)}');
    }

    _output(LogLevel.debug, buffer.toString().trimRight());
  }

  static void logApiResponse({
    required String method,
    required Uri uri,
    required int statusCode,
    dynamic data,
    Duration? duration,
  }) {
    final isSuccess = statusCode >= 200 && statusCode < 300;
    final targetLevel = isSuccess ? LogLevel.debug : LogLevel.warn;

    if (!isLevelEnabled(targetLevel)) return;

    final sanitizedData = _sanitize(data);
    final timeStr = duration != null ? ' (${duration.inMilliseconds}ms)' : '';

    final buffer = StringBuffer();
    buffer.writeln('[API RESPONSE] $method ${uri.path} -> Status $statusCode$timeStr');
    // Only output payload bodies in development with debug enabled
    if (sanitizedData != null && isLevelEnabled(LogLevel.debug) && isDevelopment) {
      buffer.writeln('  Output: ${_formatJson(sanitizedData)}');
    }

    _output(targetLevel, buffer.toString().trimRight());
  }

  static bool isLevelEnabled(LogLevel level) {
    return level.priority >= currentLevel.priority && currentLevel != LogLevel.none;
  }

  static void _log(LogLevel level, String message, [dynamic data, StackTrace? stackTrace]) {
    if (!isLevelEnabled(level)) return;

    final buffer = StringBuffer();
    buffer.write('[${level.label}] $message');
    if (data != null) {
      buffer.write(' | ${_formatJson(_sanitize(data))}');
    }
    // Only print stack traces for error logs or in development mode
    if (stackTrace != null && (isDevelopment || level == LogLevel.error)) {
      buffer.write('\n$stackTrace');
    }

    _output(level, buffer.toString());
  }

  static void _output(LogLevel level, String line) {
    debugPrint(line);
  }

  static dynamic _sanitize(dynamic value) {
    if (value == null) return null;

    if (value is Map) {
      final sanitized = <String, dynamic>{};
      for (final entry in value.entries) {
        final keyStr = entry.key.toString();
        if (_sensitiveKeys.contains(keyStr.toLowerCase())) {
          sanitized[keyStr] = '***REDACTED***';
        } else {
          sanitized[keyStr] = _sanitize(entry.value);
        }
      }
      return sanitized;
    }

    if (value is List) {
      return value.map(_sanitize).toList();
    }

    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map || decoded is List) {
          return _sanitize(decoded);
        }
      } catch (_) {}
    }

    return value;
  }

  static String _formatJson(dynamic value) {
    try {
      if (value is Map || value is List) {
        return jsonEncode(value);
      }
      return value.toString();
    } catch (_) {
      return value.toString();
    }
  }
}
