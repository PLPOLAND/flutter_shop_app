import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

import 'providers/products_provider.dart';
import 'screens/products_overview_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsProvider(),
      child: MaterialApp(
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
          '/': (context) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
        },
        // home: Scaffold(
        //   appBar: AppBar(
        //     title: const Text('MyShop'),
        //   ),
        //   body: const Center(
        //     child: Text('Hello World!'),
        //   ),
        // ),
      ),
    );
  }
}
