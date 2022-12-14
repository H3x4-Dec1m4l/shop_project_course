import 'package:flutter/material.dart';
import 'package:shop/providers/products_provider.dart';
// import 'package:shop/views/products_screen.dart';
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
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    Provider.of<ProductsProvider>(context, listen: false)
        .loadingProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Center(child: Text('GG Gamer')),
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
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : ProductGrid(_showFavoriteOnly),
      drawer: AppDrawer(),
    );
  }
}
