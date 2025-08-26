import 'package:flutter/material.dart';
import 'package:flutter_api_explorer/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Api Explorer",
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
