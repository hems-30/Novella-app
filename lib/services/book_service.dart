import 'dart:convert';
import 'package:http/http.dart' as http;

class BookService {
  static Future<List<dynamic>> searchBooks(String query) async {
    final url = "https://openlibrary.org/search.json?q=$query";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["docs"];
    } else {
      throw Exception("Failed to load books");
    }
  }

  static Future<String> getBookDescription(String workKey) async {
    final url = "https://openlibrary.org$workKey.json";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final desc = data["description"];

      if (desc == null) return "No description available";

      if (desc is String) return desc;

      return desc["value"] ?? "No description available";
    }

    return "No description available";
  }
}