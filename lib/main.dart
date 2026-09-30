import 'package:flutter/material.dart';

import 'screens/home_page.dart';
import 'theme.dart';

void main() {
  runApp(const PetoteApp());
}

class PetoteApp extends StatelessWidget {
  const PetoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pétote – Catalogue',
      debugShowCheckedModeBanner: false,
      theme: construireTheme(),
      home: const HomePage(),
    );



    
  }
}
