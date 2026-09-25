import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/config.dart';
import '../core/errors.dart';
import '../core/logger.dart';

class ApiClient {
  final AppConfig config;
  final http.Client _httpClient;

  ApiClient({AppConfig? config, http.Client? httpClient})
      : config = config ?? AppConfig.initialize(),
        _httpClient = httpClient ?? http.Client();

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(config.tokenStorageKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(config.tokenStorageKey, token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(config.tokenStorageKey);
  }

  Future<Map<String, String>> _buildHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Cache-Control': 'no-cache',
      'Pragma': 'no-cache',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? queryParams}) async {
    final uri = _buildUri(endpoint, queryParams);
    final headers = await _buildHeaders();
    final stopwatch = Stopwatch()..start();

    AppLogger.logApiRequest(
      method: 'GET',
      uri: uri,
      queryParams: queryParams,
    );

    try {
      final response = await _httpClient
          .get(uri, headers: headers)
          .timeout(config.receiveTimeout);
      stopwatch.stop();
      return _handleResponse(response, uri, 'GET', stopwatch.elapsed);
    } on http.ClientException {
      stopwatch.stop();
      AppLogger.error('GET ${uri.path} network failure', null);
      throw const NetworkException();
    } catch (e, st) {
      stopwatch.stop();
      AppLogger.error('GET ${uri.path} request failed', e, st);
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = _buildUri(endpoint);
    final headers = await _buildHeaders();
    final stopwatch = Stopwatch()..start();

    AppLogger.logApiRequest(
      method: 'POST',
      uri: uri,
      body: body,
    );

    try {
      final response = await _httpClient
          .post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(config.receiveTimeout);
      stopwatch.stop();
      return _handleResponse(response, uri, 'POST', stopwatch.elapsed);
    } on http.ClientException {
      stopwatch.stop();
      AppLogger.error('POST ${uri.path} network failure', null);
      throw const NetworkException();
    } catch (e, st) {
      stopwatch.stop();
      AppLogger.error('POST ${uri.path} request failed', e, st);
      rethrow;
    }
  }

  Uri _buildUri(String endpoint, [Map<String, String>? queryParams]) {
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final fullUrl = '${config.apiBaseUrl}$cleanEndpoint';

    final uri = Uri.parse(fullUrl);
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  dynamic _handleResponse(
    http.Response response,
    Uri uri,
    String method,
    Duration duration,
  ) {
    dynamic decodedBody;
    try {
      decodedBody = jsonDecode(response.body);
    } catch (_) {
      decodedBody = response.body.isNotEmpty ? response.body : null;
    }

    AppLogger.logApiResponse(
      method: method,
      uri: uri,
      statusCode: response.statusCode,
      data: decodedBody,
      duration: duration,
    );

    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

    if (isSuccess) {
      if (decodedBody is Map<String, dynamic> && decodedBody.containsKey('data')) {
        return decodedBody['data'];
      }
      return decodedBody;
    }

    String errorMessage = 'Request failed with status: ${response.statusCode}';
    if (decodedBody is Map<String, dynamic>) {
      if (decodedBody['error'] is String) {
        errorMessage = decodedBody['error'] as String;
      } else if (decodedBody['message'] is String) {
        errorMessage = decodedBody['message'] as String;
      }
    }

    throw ApiException(
      errorMessage,
      statusCode: response.statusCode,
      details: decodedBody,
    );
  }
}
