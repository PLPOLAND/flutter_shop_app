import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/screens/auth_screen.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/screens/orders_screen.dart';
import 'package:flutter_shop_app/screens/product_detail_screen.dart';
import 'package:flutter_shop_app/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

import 'providers/orders.dart';
import 'providers/products_provider.dart';
import 'screens/cart_screen.dart';
import 'screens/products_overview_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update: (context, auth, prev) =>
              ProductsProvider(auth.token, prev!.items),
          create: (context) => ProductsProvider('', []),
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, prev) => Orders(auth.token, prev!.orders),
          create: (context) => Orders('', []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, value, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.red,
            colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(255, 255, 35, 35),
                onPrimary: Colors.white,
                secondary: Color.fromARGB(255, 243, 100, 33),
                onSecondary: Colors.black,
                background: Color.fromARGB(255, 255, 173, 167)),
            fontFamily: 'Lato',
          ),
          routes: {
            '/': (context) =>
                value.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
