import 'dart:math';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speak/utils/globals.dart';

Future<bool> load() async {
  try {
    Hive.init((await getApplicationDocumentsDirectory()).path);
    translationsBox = await Hive.openBox("translations");
    if (translationsBox!.get("translations") == null) {
      translationsBox!.put("translations", <String, Map<String, dynamic>>{});
    } else if (translationsBox!.get("translations").isEmpty) {
      translationsBox!.put("translations", <String, Map<String, dynamic>>{"17-12-2023": <String, dynamic>{}});
    }

    return true;
  } catch (e) {
    return false;
  }
}

bool isToday(String date) {
  final List<String> currentDate = DateTime.now().toString().split(" ")[0].split("-");
  final List<String> date_ = date.split("-");
  return currentDate.every((String element) => date_.contains(element));
}
