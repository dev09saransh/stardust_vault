import '../api_client.dart';

class SecurityService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Map<String, dynamic>>> getLogs() async {
    final response = await _apiClient.get('/security-logs');
    if (response is List) {
      return response.map((e) => e as Map<String, dynamic>).toList();
    }
    return [];
  }
}
