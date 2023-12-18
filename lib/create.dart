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
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(_from.replaceFirst(" ", "\n"), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                    const SizedBox(height: 5),
                    AnimatedContainer(duration: 500.ms, width: 60, height: 2, color: orange),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  StatefulBuilder(
                    key: _sourceEnglishKey,
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return IgnorePointer(
                        ignoring: !_isSourceEnglish,
                        child: AnimatedOpacity(
                          duration: 500.ms,
                          opacity: _isSourceEnglish ? 1 : .5,
                          child: Iconed(
                            icon: Bootstrap.mic,
                            callbackDown: () async => await _startListening(),
                            callbackUp: () async => await _stopListening(),
                          ),
                        ),
                      );
                    },
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
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(_to.replaceFirst(" ", "\n"), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                  const SizedBox(height: 5),
                  AnimatedContainer(duration: 500.ms, width: 60, height: 2, color: orange),
                ],
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
              Flexible(
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
