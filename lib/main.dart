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
      title: 'PhotoBravo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
      ),
      home: const RegistroScreen(),
    );
  }
}
