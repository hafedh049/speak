import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
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
                Container(
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: orange),
                  child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Bootstrap.chevron_bar_left, size: 20, color: white)),
                ),
                const SizedBox(width: 10),
                const Text("SPEAK", style: TextStyle(color: white, fontSize: 20, letterSpacing: 2)),
                const Spacer(),
                Container(
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: orange),
                  child: IconButton(onPressed: () async {}, icon: const Icon(Bootstrap.plus, size: 20, color: white)),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(color: orange, borderRadius: BorderRadius.circular(5)),
                  child: IconButton(onPressed: () async {}, icon: const Icon(Bootstrap.plus, size: 20, color: white)),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
