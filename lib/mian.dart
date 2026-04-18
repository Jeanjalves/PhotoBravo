import 'package:flutter/material.dart';
import 'screens/registro_screen.dart';

void main() {
  runApp(const PhotoBravoApp());
}

class PhotoBravoApp extends StatelessWidget {
  const PhotoBravoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PhotoBravo',
      home: const RegistroScreen(),
    );
  }
}
