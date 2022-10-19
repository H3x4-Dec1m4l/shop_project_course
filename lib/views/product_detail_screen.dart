import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  // const ProductDetailScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductModel productModel =
        ModalRoute.of(context).settings.arguments as ProductModel;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(productModel.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(productModel.title),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                tag: productModel.id,
                child: Image.network(
                  productModel.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              DecoratedBox(decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0, 0.8),
                  end: Alignment(0, 0),
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.6),
                    Color.fromRGBO(0, 0, 0, 0)
                  ]
                )
              ))
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text('R\$ ${productModel.price}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  width: double.infinity,
                  child: Text(
                    productModel.description,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 1000)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
