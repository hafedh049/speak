import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speak/utils/globals.dart';

Future<bool> load() async {
  try {
    Hive.init((await getApplicationDocumentsDirectory()).path);
    translationsBox = await Hive.openBox("translations");
    return true;
  } catch (e) {
    return false;
  }
}

bool isToday()