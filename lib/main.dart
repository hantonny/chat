// ignore_for_file: unused_import

import 'package:chat/pages/auth_or_app_page.dart';
import 'package:chat/pages/auth_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const AuthOrAppPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
