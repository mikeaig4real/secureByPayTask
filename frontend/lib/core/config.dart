import 'logger.dart';

class AppConfig {
  final String apiBaseUrl;
  final String tokenStorageKey;
  final String environment;
  final String logLevel;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  const AppConfig({
    required this.apiBaseUrl,
    this.tokenStorageKey = 'securebypay_jwt_token',
    this.environment = 'development',
    this.logLevel = 'debug',
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 15),
  });

  /// Validates the runtime configuration and returns an initialized [AppConfig].
  /// Throws [FormatException] if the environment or fallback URL is malformed.
  static AppConfig initialize() {
    const rawUrl = String.fromEnvironment(
      'API_URL',
      defaultValue: 'http://localhost:5000/api',
    );
    const rawTokenKey = String.fromEnvironment(
      'TOKEN_STORAGE_KEY',
      defaultValue: 'securebypay_jwt_token',
    );
    const rawEnv = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'development',
    );
    const rawLogLevel = String.fromEnvironment(
      'LOG_LEVEL',
      defaultValue: 'debug',
    );

    final validatedUrl = _validateUrl(rawUrl);

    final config = AppConfig(
      apiBaseUrl: validatedUrl,
      tokenStorageKey: rawTokenKey.trim().isEmpty ? 'securebypay_jwt_token' : rawTokenKey.trim(),
      environment: rawEnv.trim().toLowerCase(),
      logLevel: rawLogLevel.trim().toLowerCase(),
    );

    AppLogger.initialize(
      environment: config.environment,
      configuredLevel: config.logLevel,
    );

    return config;
  }

  static String _validateUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('API base URL cannot be empty.');
    }

    // Support relative paths (e.g., '/api') for unified same-origin web deployments
    if (trimmed.startsWith('/')) {
      return trimmed.endsWith('/') ? trimmed.substring(0, trimmed.length - 1) : trimmed;
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      throw FormatException(
        'Invalid API base URL: "$trimmed". Must be a valid absolute URI (e.g., http://localhost:5000/api) or a relative path (e.g., /api).',
      );
    }

    if (uri.scheme != 'http' && uri.scheme != 'https') {
      throw FormatException(
        'Unsupported URL scheme: "${uri.scheme}". Must be http or https.',
      );
    }

    return trimmed.endsWith('/') ? trimmed.substring(0, trimmed.length - 1) : trimmed;
  }
}
