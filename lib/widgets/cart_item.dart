import 'package:flutter/material.dart';
import '../models/cart.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatelessWidget {
  // const CartWidget({Key key}) : super(key: key);
  final CartItem cartItem;
  const CartWidget(this.cartItem);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size:40
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_){
        Provider.of<Cart>(context, listen: false).removeItem(cartItem.productId);
      },
      child: Card( 
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(1),
                child: FittedBox(
                  child: Text(
                    ' ${cartItem.price}',
                  ),
                ),
              ),
            ),
            title: Text(cartItem.title),
            subtitle: Text('total R\$ ${cartItem.price * cartItem.quantity}'),
            trailing: Text('${cartItem.quantity}x'),
          ),
        ),
      ),
    );
  }
}
