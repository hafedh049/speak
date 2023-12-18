import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:speak/utils/globals.dart';
import 'package:speak/utils/helpers/iconed.dart';
import 'package:speak/utils/methods.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
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
  final GlobalKey<State> _micStateKey = GlobalKey<State>();
  final GlobalKey<State> _recordStateKey = GlobalKey<State>();
  final GlobalKey<State> _sourceEnglishKey = GlobalKey<State>();
  final GlobalKey<State> _fromKey = GlobalKey<State>();
  final GlobalKey<State> _toKey = GlobalKey<State>();
  final GlobalKey<State> _saveKey = GlobalKey<State>();

  final GoogleTranslator _translator = GoogleTranslator();

  final FlutterTts _flutterTts = FlutterTts();

  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  bool _record = false;

  String _from = "English (United States)";
  String _to = "Arabic";

  String _output = "";

  bool _isSourceEnglish = true;

  @override
  void dispose() {
    _flutterTts.stop();
    _inputController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    _micStateKey.currentState!.setState(() {});
  }

  Future<void> _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult, cancelOnError: true);
    _recordStateKey.currentState!.setState(() => _record = true);
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    _recordStateKey.currentState!.setState(() => _record = false);
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _inputController.text = result.recognizedWords;
    _inputClearKey.currentState!.setState(() {});
    _inputClipboardKey.currentState!.setState(() {});
    _outputClipboardKey.currentState!.setState(() {});
    _outputSpeakKey.currentState!.setState(() {});
    _outputKey.currentState!.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 90,
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)), color: secondaryColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) => Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: orange)),
                              child: TextField(
                                onChanged: (String value) {},
                                decoration: const InputDecoration(contentPadding: EdgeInsets.all(8), border: InputBorder.none, hintText: "Type a langugage"),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: languageMap.length,
                              itemBuilder: (BuildContext context, int index) => GestureDetector(
                                onTap: () {
                                  if (_from != languageMap.keys.elementAt(index)) {
                                    _fromKey.currentState!.setState(() => _from = languageMap.keys.elementAt(index));
                                    _sourceEnglishKey.currentState!.setState(() => _isSourceEnglish = _from == "English (United States)");
                                    if (_from == _to) {
                                      int indx = 0;
                                      while (indx == index) {
                                        indx = Random().nextInt(languageMap.length);
                                      }
                                      _toKey.currentState!.setState(() => _to = languageMap.keys.elementAt(indx));
                                    }
                                  }
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: _from == languageMap.keys.elementAt(index) ? const EdgeInsets.all(8) : const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(color: _from == languageMap.keys.elementAt(index) ? orange.withOpacity(.6) : null, borderRadius: BorderRadius.circular(5)),
                                  child: Text(languageMap.keys.elementAt(index)),
                                ),
                              ),
                              separatorBuilder: (BuildContext context, int index) => AnimatedContainer(duration: 700.ms, width: MediaQuery.sizeOf(context).width, height: 2, color: orange, margin: const EdgeInsets.symmetric(vertical: 8)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StatefulBuilder(
                      key: _fromKey,
                      builder: (BuildContext context, void Function(void Function()) _) {
                        return Text(_from.replaceFirst(" ", "\n"), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center);
                      },
                    ),
                    const SizedBox(height: 5),
                    AnimatedContainer(duration: 500.ms, width: 60, height: 2, color: orange),
                  ],
                ),
              ),
              StatefulBuilder(
                key: _sourceEnglishKey,
                builder: (BuildContext context, void Function(void Function()) _) {
                  return IgnorePointer(
                    ignoring: !_isSourceEnglish,
                    child: AnimatedOpacity(
                      duration: 500.ms,
                      opacity: _isSourceEnglish ? 1 : .5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Iconed(
                            icon: Bootstrap.mic,
                            callbackDown: () async => await _startListening(),
                            callbackUp: () async => await _stopListening(),
                          ),
                          StatefulBuilder(
                            key: _micStateKey,
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return AnimatedContainer(duration: 500.ms, width: 30, height: 2, color: _speechEnabled ? Colors.lightBlueAccent : Colors.redAccent);
                            },
                          ),
                          const SizedBox(height: 5),
                          StatefulBuilder(
                            key: _recordStateKey,
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return AnimatedContainer(duration: 500.ms, width: 60, height: _record ? 2 : 0, color: Colors.lightGreenAccent);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) => Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: orange)),
                              child: TextField(
                                onChanged: (String value) {},
                                decoration: const InputDecoration(contentPadding: EdgeInsets.all(8), border: InputBorder.none, hintText: "Type a langugage"),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: languageMap.length,
                              itemBuilder: (BuildContext context, int index) => GestureDetector(
                                onTap: () {
                                  if (_to != languageMap.keys.elementAt(index)) {
                                    _toKey.currentState!.setState(() => _to = languageMap.keys.elementAt(index));
                                    if (_to == _from) {
                                      int indx = 0;
                                      while (indx == index) {
                                        indx = Random().nextInt(languageMap.length);
                                      }
                                      _fromKey.currentState!.setState(() => _from = languageMap.keys.elementAt(indx));
                                      _sourceEnglishKey.currentState!.setState(() => _isSourceEnglish = _from == "English (United States)");
                                    }
                                  }
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: _to == languageMap.keys.elementAt(index) ? const EdgeInsets.all(8) : const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(color: _to == languageMap.keys.elementAt(index) ? orange.withOpacity(.6) : null, borderRadius: BorderRadius.circular(5)),
                                  child: Text(languageMap.keys.elementAt(index)),
                                ),
                              ),
                              separatorBuilder: (BuildContext context, int index) => AnimatedContainer(duration: 700.ms, width: MediaQuery.sizeOf(context).width, height: 2, color: orange, margin: const EdgeInsets.symmetric(vertical: 8)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StatefulBuilder(
                      key: _toKey,
                      builder: (BuildContext context, void Function(void Function()) _) {
                        return Text(_to.replaceFirst(" ", "\n"), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center);
                      },
                    ),
                    const SizedBox(height: 5),
                    AnimatedContainer(duration: 500.ms, width: 60, height: 2, color: orange),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                  StatefulBuilder(
                      key: _saveKey,
                      builder: (BuildContext context, void Function(void Function()) _) {
                        return GestureDetector(
                          onTap: _inputController.text.trim().isEmpty
                              ? null
                              : () async {
                                  final Map<String, dynamic> data = translationsBox!.get("translations");
                                  if (isToday(data.keys.first)) {
                                    data.values.last.add(
                                      <String, dynamic>{
                                        "createdAt": DateTime.now(),
                                        "input": _inputController.text.trim(),
                                        "output": _output,
                                      },
                                    );
                                  }
                                  await translationsBox!.put("translations", data);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                },
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
                        );
                      }),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
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
                        _saveKey.currentState!.setState(() {});
                      }
                      _outputKey.currentState!.setState(() {});
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      hintText: "Type something.",
                      suffixIcon: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          StatefulBuilder(
                            key: _inputClearKey,
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: _inputController.text.trim().isEmpty ? orange.withOpacity(.6) : orange),
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: _inputController.text.trim().isEmpty
                                        ? null
                                        : () {
                                            _inputController.clear();
                                            _inputClearKey.currentState!.setState(() {});
                                            _inputClipboardKey.currentState!.setState(() {});
                                            _outputClipboardKey.currentState!.setState(() {});
                                            _outputSpeakKey.currentState!.setState(() {});
                                            _outputKey.currentState!.setState(() {});
                                            _saveKey.currentState!.setState(() {});
                                            _output = "";
                                          },
                                    icon: const Icon(Bootstrap.x, size: 20, color: white)),
                              );
                            },
                          ),
                          StatefulBuilder(
                            key: _inputClipboardKey,
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: _inputController.text.trim().isEmpty ? orange.withOpacity(.6) : orange),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: _inputController.text.trim().isEmpty
                                      ? null
                                      : () async {
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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: StatefulBuilder(
                          key: _outputKey,
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return _inputController.text.trim().isEmpty
                                ? const SizedBox()
                                : FutureBuilder<Translation>(
                                    future: _translator.translate(_inputController.text, from: languageMap[_from]!.split("-")[0], to: languageMap[_to]!.split("-")[0]),
                                    builder: (BuildContext context, AsyncSnapshot<Translation> snapshot) {
                                      if (snapshot.hasError) {
                                        return Text(snapshot.error.toString());
                                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Text("...");
                                      }
                                      _output = snapshot.data!.text;
                                      return AnimatedTextKit(
                                        key: ValueKey<String>(snapshot.hasData ? snapshot.data!.text : _inputController.text),
                                        totalRepeatCount: 1,
                                        animatedTexts: <AnimatedText>[
                                          TypewriterAnimatedText(snapshot.data!.text),
                                        ],
                                      );
                                    },
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
                                decoration: BoxDecoration(shape: BoxShape.circle, color: _inputController.text.trim().isEmpty ? orange.withOpacity(.6) : orange),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: _inputController.text.trim().isEmpty
                                      ? null
                                      : () async {
                                          await Clipboard.setData(ClipboardData(text: _output));
                                          showToast("Text Copied");
                                        },
                                  icon: const Icon(Bootstrap.clipboard, size: 20, color: white),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          StatefulBuilder(
                            key: _outputSpeakKey,
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return Container(
                                decoration: BoxDecoration(shape: BoxShape.circle, color: _inputController.text.trim().isEmpty ? orange.withOpacity(.6) : orange),
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: _inputController.text.trim().isEmpty
                                        ? null
                                        : () async {
                                            _flutterTts.setLanguage(languageMap[_to]!);
                                            await _flutterTts.speak(_output);
                                          },
                                    icon: const Icon(Bootstrap.soundwave, size: 20, color: white)),
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
