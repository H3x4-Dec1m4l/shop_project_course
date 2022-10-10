import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../utils/app_routes.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions { Favorite, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // const ProductsOverviewScreen({Key key}) : super(key: key);

  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Minha loja')),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions?.Favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente Favoritos'),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.All,
              )
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.CART),
              ),
            builder: (_, cart, child) => Badge(
              value: cart.itemCount.toString(),
              child: child,
            ),
          )
        ],
      ),
      body: ProductGrid(_showFavoriteOnly),
      drawer: AppDrawer(),
    );
  }
}
