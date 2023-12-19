import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:speak/create.dart';
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
  final GlobalKey<State> _selectionKey = GlobalKey<State>();

  int _activeDay = 0;

  @override
  void initState() {
    final Map<dynamic, dynamic> data = translationsBox!.get("translations");
    _translations.addAll(data);
    _activeDay = data.length - 1;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: Container(
          decoration: const BoxDecoration(shape: BoxShape.circle, color: orange),
          child: IconButton(
            onPressed: () {
              flutterTts.stop();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Create()));
            },
            icon: const Icon(Bootstrap.plus, size: 20, color: white),
          ),
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
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _translations.length,
                        separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10),
                        itemBuilder: (BuildContext context, int index) {
                          final String key = _translations.keys.elementAt(index);
                          final List<String> date = key.split("-");
                          return GestureDetector(
                            onTap: () async {
                              _selectionKey.currentState!.setState(() => _activeDay = index);
                              _pageController.jumpToPage(index);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
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
                                StatefulBuilder(
                                  key: _selectionKey,
                                  builder: (BuildContext context, void Function(void Function()) _) {
                                    return AnimatedContainer(duration: 500.ms, width: 60, height: _activeDay == index ? 2 : 0, color: orange);
                                  },
                                ),
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
                    final List<dynamic> items = _translations.values.elementAt(indexI);
                    if (items.isEmpty) {
                      return const Center(child: Text("NOT YET", style: TextStyle(color: white, fontSize: 20, letterSpacing: 2)));
                    }
                    items.sort((dynamic a, dynamic b) => a["createdAt"].millisecondsSinceEpoch <= b["createdAt"].millisecondsSinceEpoch ? 1 : -1);
                    return StepperListView(
                      stepperData: items.map((dynamic e) => StepperItemData(content: e)).toList(),
                      stepAvatar: (BuildContext context, dynamic value) => const PreferredSize(preferredSize: Size.square(30), child: Icon(FontAwesome.paper_plane, color: orange, size: 25)),
                      stepContentWidget: (BuildContext context, dynamic value) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: secondaryColor),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(16),
                                    hintText: value.content["input"],
                                    suffixIcon: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: orange),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              await Clipboard.setData(ClipboardData(text: value.content["input"]));
                                              showToast("Text Copied");
                                            },
                                            icon: const Icon(Bootstrap.clipboard, size: 20, color: white),
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: orange),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              flutterTts.setLanguage(languageMap[value.content["inputLanguage"]]!);
                                              await flutterTts.speak(value.content["input"]);
                                            },
                                            icon: const Icon(Bootstrap.soundwave, size: 20, color: white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Divider(height: 1, thickness: 1, color: gray, indent: 25, endIndent: 25),
                              const SizedBox(height: 10),
                              Flexible(
                                child: TextField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(16),
                                    hintText: value.content["output"],
                                    suffixIcon: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: orange),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              await Clipboard.setData(ClipboardData(text: value.content["output"]));
                                              showToast("Text Copied");
                                            },
                                            icon: const Icon(Bootstrap.clipboard, size: 20, color: white),
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: orange),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              flutterTts.setLanguage(languageMap[value.content["outputLanguage"]]!);
                                              await flutterTts.speak(value.content["output"]);
                                            },
                                            icon: const Icon(Bootstrap.soundwave, size: 20, color: white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
