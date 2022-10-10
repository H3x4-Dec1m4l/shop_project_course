import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../data/dummy_data.dart';



class ProductsProvider with ChangeNotifier{
  List<ProductModel> _itens = DUMMY_PRODUCTS;
  
  List<ProductModel> get itens => [..._itens];
  List<ProductModel> get FavoriteItens {
    return _itens.where((prod)=> prod.isFavorite)?.toList();
  }

  void addProduct(ProductModel product){
    _itens.add(product);
    notifyListeners();
  }

}