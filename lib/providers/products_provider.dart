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
  String _token;
  String _userId;

  ProductsProvider([this._token,this._userId, this._items = const []]);

  List<ProductModel> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  List<ProductModel> get FavoriteItens {
    return _items.where((prod) => prod.isFavorite)?.toList();
  }

  Future<void> loadingProducts() async {
    final response = await http.get(Uri.parse('$_url?auth=$_token'));
    Map<String, dynamic> data = json.decode(response.body);
    final favResponse = await http.get(Uri.parse('${Constants.BASE_API_URL}/userFavorites/$_userId.json?auth=$_token'));
    final favMap = json.decode(favResponse.body);
    _items.clear();
    if (data != null) {
      data.forEach((productId, productData) {
        final isFavorite = favMap == null ? false : favMap[productId] ?? false;
        _items.add(
          ProductModel(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: isFavorite,
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
       Uri.parse("$_updateUrl/${product.id}.json?auth=$_token"),
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
      final response = await http.delete( Uri.parse("$_updateUrl/${product.id}.json?auth=$_token"));
      if(response.statusCode >= 400){
        _items.insert(index, product);
        notifyListeners(); 
        throw HttpException('Ocorreu um erro na exclusão do produto');
      }
    }
  }
}
