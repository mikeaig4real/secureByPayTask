import 'api_client.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiClient _client;

  AuthService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await _client.post(
      '/auth/register',
      body: {
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'email': email.trim().toLowerCase(),
        'phone': phone.trim(),
        'password': password,
      },
    );

    if (response is Map<String, dynamic>) {
      final token = response['token'] as String?;
      if (token != null) {
        await _client.saveToken(token);
      }
      return UserModel.fromJson(response['user'] as Map<String, dynamic>? ?? {});
    }

    throw const FormatException('Invalid authentication response format');
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      '/auth/login',
      body: {
        'email': email.trim().toLowerCase(),
        'password': password,
      },
    );

    if (response is Map<String, dynamic>) {
      final token = response['token'] as String?;
      if (token != null) {
        await _client.saveToken(token);
      }
      return UserModel.fromJson(response['user'] as Map<String, dynamic>? ?? {});
    }

    throw const FormatException('Invalid login response format');
  }

  Future<UserModel> getProfile() async {
    final response = await _client.get('/auth/me');
    if (response is Map<String, dynamic>) {
      return UserModel.fromJson(response);
    }
    throw const FormatException('Invalid profile response format');
  }

  Future<void> logout() async {
    await _client.clearToken();
  }

  Future<bool> isAuthenticated() async {
    final token = await _client.getToken();
    return token != null && token.isNotEmpty;
  }
}
