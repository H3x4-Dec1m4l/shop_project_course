import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../utils/app_routes.dart';
import '../providers/products_provider.dart';
import '../widgets/product_item.dart';
class ProductsScreen extends StatelessWidget {

  Future<void> _refreshProducts(BuildContext context)  {
    return Provider.of<ProductsProvider>(context,listen: false).loadingProducts();
  }
  // const ProductsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context);
    final productItems =  products.items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCTS_FORM);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: (() => _refreshProducts(context)) ,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: products.itemsCount,
            itemBuilder: ((context, index) => Column(
              children: [
                 ProductItem(productItems[index]),
                 Divider(),
              ],
            )),
          ),
        ),
      ),
    );
  }
}