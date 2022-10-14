import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './utils/app_routes.dart';
import './providers/products_provider.dart';
import './views/products_overview_screen.dart';
import './views/product_form_screen.dart';
import './views/product_detail_screen.dart';
import './views/cart_screen.dart';
import './views/orders_screen.dart';
import './views/products_screen.dart';
import './models/cart.dart';
import './models/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => new ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => new Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => new Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        // home: ProductsOverviewScreen(),
        routes: {
          AppRoutes.HOME: (ctx) => ProductsOverviewScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS_SCREEN: (ctx) => OrderScreen(),
          AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
          AppRoutes.PRODUCTS_FORM: (ctx) => ProductFormScreen(),
        },
      ),
    );
  }
}
