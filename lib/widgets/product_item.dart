import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart.dart';
import '../utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // const ProductItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductModel productModel =
        Provider.of<ProductModel>(context, listen: false);
    final Cart cart =
        Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(AppRoutes.PRODUCT_DETAIL, arguments: productModel);
          },
          child: Image.network(
            productModel.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<ProductModel>(
            builder: (ctx, productModel, _) => IconButton(
              icon: Icon(productModel.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                productModel.toggleFavorite();
              },
            ),
          ),
          title: Text(
            productModel.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(productModel);
            },
          ),
        ),
      ),
    );
  }
}
