import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import 'product_grid_item.dart';

class ProductGrid extends StatelessWidget {
  bool _showFavoriteOnly;

  ProductGrid(this._showFavoriteOnly);
  @override
  Widget build(BuildContext context) {
    final  productsProvider  = Provider.of<ProductsProvider>(context);
    final List<ProductModel> products  =  _showFavoriteOnly
        ? productsProvider.FavoriteItens
        : productsProvider.items;
    return GridView.builder(
      
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: products[index], child: ProductGridItem()),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
