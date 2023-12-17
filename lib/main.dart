import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:speak/home.dart';
import 'package:speak/utils/methods.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Animate.restartOnHotReload = true;
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: load(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if(snapshot.hasData){return const Home();}
          else if(){}
          else {return }
        },
      ),
      theme: ThemeData.dark(),
    );
  }
}
