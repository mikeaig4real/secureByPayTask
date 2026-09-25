import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/logger.dart';
import 'package:frontend/core/config.dart';

void main() {
  group('LogLevel & AppLogger Production Behavior Tests', () {
    tearDown(() {
      // Reset logger state after each test
      AppLogger.initialize(environment: 'development', configuredLevel: 'debug');
    });

    test('LogLevel.fromString respects production fallback', () {
      expect(LogLevel.fromString('debug'), LogLevel.debug);
      expect(LogLevel.fromString('info'), LogLevel.info);
      expect(LogLevel.fromString('warn'), LogLevel.warn);
      expect(LogLevel.fromString('error'), LogLevel.error);
      expect(LogLevel.fromString('none'), LogLevel.none);

      // Unknown or empty level in development
      expect(LogLevel.fromString('', isProduction: false), LogLevel.debug);
      expect(LogLevel.fromString(null, isProduction: false), LogLevel.debug);

      // Unknown or empty level in production
      expect(LogLevel.fromString('', isProduction: true), LogLevel.error);
      expect(LogLevel.fromString(null, isProduction: true), LogLevel.error);
    });

    test('AppLogger initializes to error level and disables isDevelopment in production', () {
      AppLogger.initialize(environment: 'production');

      expect(AppLogger.isDevelopment, isFalse);
      expect(AppLogger.currentLevel, LogLevel.error);
      expect(AppLogger.isLevelEnabled(LogLevel.debug), isFalse);
      expect(AppLogger.isLevelEnabled(LogLevel.info), isFalse);
      expect(AppLogger.isLevelEnabled(LogLevel.warn), isFalse);
      expect(AppLogger.isLevelEnabled(LogLevel.error), isTrue);
    });

    test('AppLogger in development enables debug logging and isDevelopment flag', () {
      AppLogger.initialize(environment: 'development', configuredLevel: 'debug');

      expect(AppLogger.isDevelopment, isTrue);
      expect(AppLogger.currentLevel, LogLevel.debug);
      expect(AppLogger.isLevelEnabled(LogLevel.debug), isTrue);
      expect(AppLogger.isLevelEnabled(LogLevel.info), isTrue);
      expect(AppLogger.isLevelEnabled(LogLevel.error), isTrue);
    });

    test('AppLogger respects explicitly configured level even if in production', () {
      AppLogger.initialize(environment: 'production', configuredLevel: 'warn');

      expect(AppLogger.isDevelopment, isFalse);
      expect(AppLogger.currentLevel, LogLevel.warn);
      expect(AppLogger.isLevelEnabled(LogLevel.debug), isFalse);
      expect(AppLogger.isLevelEnabled(LogLevel.info), isFalse);
      expect(AppLogger.isLevelEnabled(LogLevel.warn), isTrue);
      expect(AppLogger.isLevelEnabled(LogLevel.error), isTrue);
    });

    test('AppLogger disables all logging when configured to none', () {
      AppLogger.initialize(environment: 'production', configuredLevel: 'none');

      expect(AppLogger.currentLevel, LogLevel.none);
      expect(AppLogger.isLevelEnabled(LogLevel.debug), isFalse);
      expect(AppLogger.isLevelEnabled(LogLevel.info), isFalse);
      expect(AppLogger.isLevelEnabled(LogLevel.warn), isFalse);
      expect(AppLogger.isLevelEnabled(LogLevel.error), isFalse);
    });

    test('AppConfig initializes with valid defaults and sets production flag', () {
      final config = AppConfig.initialize();

      expect(config.apiBaseUrl, isNotEmpty);
      expect(config.tokenStorageKey, 'securebypay_jwt_token');
      expect(config.environment, isNotEmpty);
    });
  });
}
