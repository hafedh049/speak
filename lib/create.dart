import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:speak/utils/globals.dart';
import 'package:speak/utils/methods.dart';
import 'package:translator/translator.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final TextEditingController _inputController = TextEditingController();

  final GlobalKey<State> _inputClearKey = GlobalKey<State>();
  final GlobalKey<State> _inputClipboardKey = GlobalKey<State>();
  final GlobalKey<State> _outputSpeakKey = GlobalKey<State>();
  final GlobalKey<State> _outputClipboardKey = GlobalKey<State>();
  final GlobalKey<State> _outputKey = GlobalKey<State>();

   final GoogleTranslator _translator = GoogleTranslator();



  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              Row(
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: orange),
                    child: IconButton(padding: EdgeInsets.zero, onPressed: () => Navigator.pop(context), icon: const Icon(Bootstrap.chevron_bar_left, size: 20, color: white)),
                  ),
                  const SizedBox(width: 10),
                  const Text("SPEAK", style: TextStyle(color: white, fontSize: 20, letterSpacing: 2)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {},
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(color: orange, borderRadius: BorderRadius.circular(5)),
                      child: const Row(
                        children: <Widget>[
                          Icon(Bootstrap.save, size: 20, color: white),
                          SizedBox(width: 5),
                          Text("SAVE", style: TextStyle(color: white, fontSize: 18, letterSpacing: 1.5)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    controller: _inputController,
                    onChanged: (String value) {
                      if (value.trim().length <= 1) {
                        _inputClearKey.currentState!.setState(() {});
                        _inputClipboardKey.currentState!.setState(() {});
                        _outputClipboardKey.currentState!.setState(() {});
                        _outputSpeakKey.currentState!.setState(() {});
                      }
                      _outputKey.currentState!.setState(() {});
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      hintText: "Type something.",
                      suffix: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          StatefulBuilder(
                            key: _inputClearKey,
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return Container(
                                decoration: BoxDecoration(shape: BoxShape.circle, color: _inputController.text.trim().isEmpty ? orange.withOpacity(.6) : orange),
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      _inputController.clear();
                                    },
                                    icon: const Icon(Bootstrap.x, size: 20, color: white)),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          StatefulBuilder(
                            key: _inputClipboardKey,
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return Container(
                                decoration: BoxDecoration(shape: BoxShape.circle, color: _inputController.text.trim().isEmpty ? orange.withOpacity(.6) : orange),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    await Clipboard.setData(ClipboardData(text: _inputController.text));
                                    showToast("Text Copied");
                                  },
                                  icon: const Icon(Bootstrap.clipboard, size: 20, color: white),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: StatefulBuilder(
                          key: _outputKey,
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return FutureBuilder(
                              future: _translator.translate(sourceText),
                              builder: (BuildContext context,AsyncSnapshot<> snapshot) {
                                return AnimatedTextKit(
                                  animatedTexts: <AnimatedText>[
                                    TypewriterAnimatedText(_inputController.text),
                                  ],
                                );
                              }
                            );
                          },
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          StatefulBuilder(
                            key: _outputClipboardKey,
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return Container(
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: orange),
                                child: IconButton(padding: EdgeInsets.zero, onPressed: () {}, icon: const Icon(Bootstrap.clipboard, size: 20, color: white)),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          StatefulBuilder(
                            key: _outputSpeakKey,
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return Container(
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: orange),
                                child: IconButton(padding: EdgeInsets.zero, onPressed: () {}, icon: const Icon(Bootstrap.soundwave, size: 20, color: white)),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
