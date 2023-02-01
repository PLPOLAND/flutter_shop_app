import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: const ColorScheme.light(
            primary: Color.fromARGB(255, 255, 35, 35),
            onPrimary: Colors.white,
            secondary: Color.fromARGB(255, 243, 100, 33),
            onSecondary: Colors.black,
            background: Color.fromARGB(255, 255, 173, 167)),
      ),
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          title: const Text('MyShop'),
        ),
        body: const Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
