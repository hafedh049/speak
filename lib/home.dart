import 'package:flutter/material.dart';
import 'package:speak/utils/globals.dart';
import 'package:speak/utils/methods.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Map<String, List<Map<String, dynamic>>> _translations = <String, List<Map<String, dynamic>>>{};

  @override
  void initState() {
    _translations.addAll(translationsBox!.get("translations"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            const Text("SPEAK", style: TextStyle(color: white, fontSize: 20, letterSpacing: 2)),
            const SizedBox(height: 20),
            ListView.builder(
              itemCount: _translations.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: isToday(_translations.keys[index])),
                  child: ,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
