import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReviewProvider extends ChangeNotifier {
  final String baseUrl =
      'https://6a0843b8fa9b27c848facbc9.mockapi.io/reviews';

  List<Map<String, dynamic>> _reviews = [];
  bool isLoading = false;
  bool hasError = false;

  List<Map<String, dynamic>> get reviews => _reviews;

  
  Future<void> fetchReviews() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _reviews = List<Map<String, dynamic>>.from(data);
      } else {
        hasError = true;
      }
    } catch (e) {
      hasError = true;
      debugPrint("Fetch error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  
  Future<void> addReview(Map<String, dynamic> review) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(review),
      );

      if (response.statusCode == 201) {
        _reviews.add(jsonDecode(response.body));
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Add error: $e");
    }
  }


  Future<void> updateReview(String id, Map<String, dynamic> review) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(review),
      );

      if (response.statusCode == 200) {
        final index = _reviews.indexWhere((r) => r['id'] == id);

        if (index != -1) {
          _reviews[index] = jsonDecode(response.body);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("Update error: $e");
    }
  }

 
  Future<void> deleteReview(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        _reviews.removeWhere((r) => r['id'] == id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Delete error: $e");
    }
  }
}