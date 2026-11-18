import 'package:flutter/material.dart';

import 'chronologie_form.dart';

class ChronologieHome extends StatelessWidget {
  const ChronologieHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChronologieForm()),
            );
          },
          child: const Text(
            'Générateur de chronologie',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
