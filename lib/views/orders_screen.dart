import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../models/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/order_widget.dart';

class OrderScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
        appBar: AppBar(
          title: Text('Meus Pedidos'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder<void>(
          future: Provider.of<Orders>(context,listen: false).loadingOrders(),
          builder:  (ctx, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }else if (snapshot.error != null) {
              return Center(child: Text('Ocorreu um erro ao acessar os pedidos'),);
            }else{
            return  Consumer<Orders>(
                builder: (ctx, orders, child){
                  return ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, i) => OrderWidget(orders.orders[i]),
                );
                }
                
              );}
            }
          ));}
        
      
}