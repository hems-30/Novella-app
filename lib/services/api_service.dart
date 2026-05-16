import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Map<String, dynamic>> getRequest(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> postRequest(
    String url,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }

  Future<Map<String, dynamic>> putRequest(
    String url,
    Map<String, dynamic> body,
  ) async {
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<void> deleteRequest(String url) async {
    final response = await http.delete(
      Uri.parse(url),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete data');
    }
  }
}