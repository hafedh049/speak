import 'package:flutter/material.dart';
import 'package:speak/utils/globals.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            Text("SPEAK", style: TextStyle(color: white, fontSize: 20, letterSpacing: 2)),
          ],
        ),
      ),
    );
  }
}
