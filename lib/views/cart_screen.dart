// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  // const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final cartItems = cart.item.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho de compras'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      'R\$ ${cart.totalAmount}',
                      style: TextStyle(
                          // color: Theme.of(context).primaryTextTheme.title.color,
                          ),
                    ),
                  ),
                  Spacer(),
                  FlatButton(
                    child: Text(
                      'COMPRAR',
                      // style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false)
                          .addOrder(cart);
                          cart.clear();
                    }, 
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.itemCount,
                  itemBuilder: (cxt, index) => CartWidget(cartItems[index]))),
        ],
      ),
    );
  }
}
