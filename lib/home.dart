import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:speak/utils/globals.dart';
import 'package:speak/utils/methods.dart';
import 'package:stepper_list_view/stepper_list_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Map<dynamic, dynamic> _translations = <dynamic, dynamic>{};
  final PageController _pageController = PageController();
  int _activeDay = 0;

  @override
  void initState() {
    final Map<dynamic, dynamic> data = translationsBox!.get("translations");
    _translations.addAll(data);
    _activeDay = data.length;
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
      floatingActionButton: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle, color: orange),
        child: IconButton(onPressed: () async {}, icon: const Icon(Bootstrap.plus, size: 20, color: white)),
      ),
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
                : SizedBox(
                    height: 70,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _translations.length,
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10),
                      itemBuilder: (BuildContext context, int index) {
                        final String key = _translations.keys.elementAt(index);
                        final List<String> date = key.split("-");
                        return GestureDetector(
                          onTap: () async {
                            _activeDay = index;
                            _pageController.jumpToPage(index);
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
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
                                          Text(date[2], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                          Text(months[int.parse(date[1]) - 1], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                          Text(date[0], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                              ),
                              const SizedBox(height: 5),
                              AnimatedContainer(duration: 500.ms, height: 2, color: orange),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * .7,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _translations.length,
                itemBuilder: (BuildContext context, int indexI) {
                  final List<Map<String, dynamic>> items = _translations.values.elementAt(indexI);
                  if (items.isEmpty) {
                    return const Center(child: Text("NOT YET", style: TextStyle(color: white, fontSize: 20, letterSpacing: 2)));
                  }
                  return StepperListView(
                    stepperData: items.map((Map<String, dynamic> e) => StepperItemData(content: e)).toList(),
                    stepAvatar: (BuildContext context, dynamic value) {
                      return const PreferredSize(preferredSize: Size.fromRadius(10), child: Icon(FontAwesome.radio_solid, color: orange, size: 15));
                    },
                    stepContentWidget: (BuildContext context, dynamic value) {
                      return Container();
                    },
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
