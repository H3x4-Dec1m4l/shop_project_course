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
                      'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          // color: Theme.of(context).primaryTextTheme.title.color,
                          ),
                    ),
                  ),
                  Spacer(),
                  OrderButton(cart: cart),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
    bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text(
        'COMPRAR',
        // style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      onPressed: widget.cart.totalAmount == 0 ? null : () async {
        setState(() {
          _isLoading = true;
        });
       await Provider.of<Orders>(context, listen: false)
            .addOrder(widget.cart);
            setState(() {
          _isLoading = false;
        });
            widget.cart.clear();
      }, 
    );
  }
}
