import 'package:flutter/material.dart';
import 'package:speak/utils/globals.dart';
import 'package:speak/utils/methods.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Map<String, Map<String, dynamic>> _translations = <String, Map<String, dynamic>>{};
  final PageController _pageController = PageController();

  @override
  void initState() {
    _translations.addAll(translationsBox!.get("translations"));
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
            _translations.isEmpty
                ? const Center(child: Text("NO ENTRY", style: TextStyle(color: white, fontSize: 20, letterSpacing: 2)))
                : Flexible(
                    child: ListView.builder(
                      itemCount: _translations.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String key = _translations.keys.elementAt(index);
                        final List<String> date = key.split("-");
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: isToday(key) ? orange : secondaryColor,
                          ),
                          child: isToday(key)
                              ? const Text("TODAY", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(date[0], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    Text(date[1], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                    Text(date[2], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.sizeOf(context),
              child: PageView.builder(
                controller: _pageController,
                itemCount: _translations.length,
                itemBuilder: (BuildContext context, int indexI) {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int indexJ) {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
