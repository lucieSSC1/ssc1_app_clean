// lib/screens/chronologie/chronologie_home_screen.dart

import 'package:flutter/material.dart';
import 'chronologie_screen.dart';

class ChronologieHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestionnaire chronologique")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChronologieScreen()),
            );
          },
          child: Text("Gestionnaire chronologique"),
        ),
      ),
    );
  }
}