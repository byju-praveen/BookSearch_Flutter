import 'package:flutter/material.dart';
import 'Routes/homepage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Book Search",
      home: BookList(),
    );
  }
}
