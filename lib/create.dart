import 'package:flutter/material.dart';
import 'package:speak/utils/globals.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            Row(
              children: <Widget>[
                const Text("SPEAK", style: TextStyle(color: white, fontSize: 20, letterSpacing: 2)),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
