import 'dart:convert';
import 'api_client.dart';

class AuthService {
  final ApiClient _api = ApiClient();

  // Login: Step 1
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    final response = await _api.post('/auth/login', {
      'identifier': identifier,
      'password': password,
    });

    final data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw data['message'] ?? 'Login failed';
    }
    return data;
  }

  // Register: Step 1
  Future<Map<String, dynamic>> register({
    required String fullName,
    String? email,
    required String mobile,
    required String password,
    required List<Map<String, dynamic>> securityAnswers,
  }) async {
    final response = await _api.post('/auth/register', {
      'fullName': fullName,
      'email': email,
      'mobile': mobile,
      'password': password,
      'securityAnswers': securityAnswers,
    });

    final data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw data['message'] ?? 'Registration failed';
    }
    return data;
  }

  // Verify OTP: Step 2
  Future<Map<String, dynamic>> verifyOtp({
    int? userId,
    required String otp,
    String? email,
    String? mobile,
  }) async {
    final response = await _api.post('/auth/verify-otp', {
      if (userId != null) 'userId': userId,
      'otp': otp,
      if (email != null) 'email': email,
      if (mobile != null) 'mobile': mobile,
    });

    final data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw data['message'] ?? 'Verification failed';
    }

    // Save token if verification successful
    if (data['token'] != null) {
      await _api.setToken(data['token']);
    }
    
    return data;
  }

  // Get current user profile
  Future<Map<String, dynamic>> getProfile() async {
    final response = await _api.get('/auth/profile');
    final data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw data['message'] ?? 'Failed to fetch profile';
    }
    return data;
  }

  // Logout
  Future<void> logout() async {
    await _api.logout();
  }

  // Check if session exists
  Future<bool> isLoggedIn() async {
    return await _api.isAuthenticated();
  }
}
