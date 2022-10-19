import 'dart:io';

import 'package:shop/providers/products_provider.dart';

import '../models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  // const ProductItem({Key key}) : super(key: key);
  final ProductModel product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    confirmed() {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Tem certeza?'),
          content: Text('Quer remover o Item do carrinho?'),
          actions: [
            TextButton(
              child: Text('não'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('sim'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      ).then((value) async {
        if (value) {
          try {
         await Provider.of<ProductsProvider>(context, listen: false)
              .deleteProduct(product.id);
        }on HttpException catch(error){
          scaffold.showSnackBar(
            SnackBar(content: Text('Ocorreu um erro ao excluir'))
          );
        }
        }
      });
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.PRODUCTS_FORM, arguments: product);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                confirmed();
              },
            ),
          ],
        ),
      ),
    );
  }
}
