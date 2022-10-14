import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../utils/constants.dart';
// import '../data/dummy_data.dart';

class ProductsProvider with ChangeNotifier {
  final Uri _url = Uri.https(
      '${Constants.BASE_API_URI}', '/products.json');
      final _updateUrl = Uri.parse(
      '${Constants.BASE_API_URL}/products'
      );
  
  List<ProductModel> _items = [];

  List<ProductModel> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  List<ProductModel> get FavoriteItens {
    return _items.where((prod) => prod.isFavorite)?.toList();
  }

  Future<void> loadingProducts() async {
    final response = await http.get(_url);
    Map<String, dynamic> data = json.decode(response.body);
    _items.clear();
    if (data != null) {
      data.forEach((productId, productData) {
        _items.add(
          ProductModel(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'],
          ),
        );
      });
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> addProduct(ProductModel newProduct) async {
    final response = await http.post(
      _url,
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite,
      }),
    );
    _items.add(ProductModel(
        id: json.decode(response.body)['name'],
        title: newProduct.title,
        description: newProduct.description,
        price: newProduct.price,
        imageUrl: newProduct.imageUrl));
    notifyListeners();
  }

  Future<void> updateProduct(ProductModel product) async {
    if (product == null || product.id == null) {
      return;
    }
  
    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      await http.patch( 
       Uri.parse("$_updateUrl/${product.id}.json"),
        body: json.encode({
          'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final product = _items [index];
      _items.remove(product);
      notifyListeners();
      final response = await http.delete( Uri.parse("$_updateUrl/${product.id}.json"));
      if(response.statusCode >= 400){
        _items.insert(index, product);
        notifyListeners(); 
        throw HttpException('Ocorreu um erro na exclusão do produto');
      }
    }
  }
}
