import 'dart:convert';
import '../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductModel with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  String imageUrl = '';
  bool isFavorite;

  ProductModel({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    _toggleFavorite();
    try {
      final _updateUrl = Uri.parse('${Constants.BASE_API_URL}/userFavorites');

      final response = await http.put(
          Uri.parse("$_updateUrl/$userId/$id.json?auth=$token"),
          body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (error) {
      _toggleFavorite();
    }
  }
}
