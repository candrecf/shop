import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/products_overview_page.dart';

import '../models/auth.dart';
import 'auth_page.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    // return auth.isAuth ? ProductsOverviewPage() : AuthPage();
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        //  else if (snapshot.error != null) {
        //   return Center(
        //     child: Text('Ocorreu um erro!'),
        //   );
        else if (snapshot.hasError) {
          print('Erro: ${snapshot.error}');
          return Center(
            child: Text('Erro: ${snapshot.error}'),
          );
        } else {
          return auth.isAuth ? ProductsOverviewPage() : AuthPage();
        }
      },
    );
  }
}
