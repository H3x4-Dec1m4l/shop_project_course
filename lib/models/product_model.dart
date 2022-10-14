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

  Future<void> toggleFavorite() async {
    _toggleFavorite();
    try {
      final _updateUrl = Uri.parse(
          '${Constants.BASE_API_URL}/products');

      final response = await http.patch(Uri.parse("$_updateUrl/$id.json"),
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (error) {
      _toggleFavorite();
    }
  }
}
