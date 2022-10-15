import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/views/auth_screen.dart';
import '../providers/auth.dart';
import '../views/products_overview_screen.dart';

class AuthOrHomeScreen extends StatelessWidget {
  // const AuthOrHome({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(
            child: Text('Ocorreu um erro ao acessar os pedidos'),
          );
        } else {
          return auth.isAuth ? ProductsOverviewScreen() : AutenticatorScreen();
        }
      },
    );
  }
}
