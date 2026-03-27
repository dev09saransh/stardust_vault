import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';

class UploadResult {
  final String key;
  final String location;

  UploadResult({required this.key, required this.location});
}

class UploadService {
  static const String _baseUrl = 'http://localhost:5002/api/uploads';
  final AuthService _authService = AuthService();

  Future<UploadResult> uploadFile(File file, {String folder = 'documents'}) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Authentication required');

    var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['folder'] = folder;
    
    request.files.add(await http.MultipartFile.fromPath(
      'file', 
      file.path,
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return UploadResult(
        key: data['file_key'],
        location: data['location'],
      );
    } else {
      throw Exception('Upload failed: ${response.body}');
    }
  }

  Future<String> getViewUrl(String key) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Authentication required');

    final response = await http.get(
      Uri.parse('$_baseUrl/view?key=$key'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['url'];
    } else {
      throw Exception('Failed to get view URL');
    }
  }
}
