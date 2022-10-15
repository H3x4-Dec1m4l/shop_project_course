import 'dart:convert';
import '../utils/constants.dart';
import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.id,
    this.total,
    this.products,
    this.date,
  });
}

class Orders with ChangeNotifier {
  final _baseUrl = Uri.parse(
      '${Constants.BASE_API_URL}/orders');
  String _token;
  String _userId;


  List<Order> _items = [];

  Orders([this._token, this._userId, this._items = const []]);

  List<Order> get orders {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadingOrders() async {
    List<Order> loadedItems = [];
    final response = await http.get(Uri.parse('$_baseUrl/$_userId.json?auth=$_token'));
    Map<String, dynamic> data = json.decode(response.body);
    loadedItems.clear();
    if (data != null) {
      data.forEach((orderId, orderData) {
        loadedItems.add(
          Order(
            id: orderId,
            total: orderData['total'],
            date: DateTime.parse(orderData['date']),
            products: (orderData['products'] as List<dynamic>).map((item) {
              return CartItem(
                id: item['id'],
                price: item['price'],
                productId: item['productId'],
                quantity: item['quantity'],
                title: item['title'],
              );
            }).toList(),
          ),
        );
      });
      notifyListeners();
    }
    _items = loadedItems.reversed.toList();
    return Future.value();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(Uri.parse('$_baseUrl/$_userId.json?auth=$_token'),
        body: json.encode({
          'total': cart.totalAmount,
          'date': date.toIso8601String(),
          'products': cart.item.values
              .map((cartItem) => {
                    'id': cartItem.id,
                    'productId': cartItem.productId,
                    'title': cartItem.title,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                  })
              .toList()
        }));

    _items.insert(
        0,
        Order(
          id: json.decode(response.body)['name'],
          total: cart.totalAmount,
          date: date,
          products: cart.item.values.toList(),
        ));
    notifyListeners();
  }
}
