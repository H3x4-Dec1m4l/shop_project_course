import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../models/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/order_widget.dart';
class OrderScreen extends StatelessWidget {
  // const OrderScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Orders orders = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orders.itemsCount ,
        itemBuilder: (ctx, i) => OrderWidget(orders.orders[i]),
      )
    );
  }
}
