import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speak/utils/globals.dart';

Future<bool> load() async {
  try {
    Hive.init((await getApplicationDocumentsDirectory()).path);
    translationsBox = await Hive.openBox("translations");
    if (translationsBox!.get("translations") == null) {
      await translationsBox!.put("translations", <String, List<Map<String, dynamic>>>{DateTime.now().toString().split(' ')[0]: <Map<String, dynamic>>[]});
    }
    return true;
  } catch (e) {
    return false;
  }
}

bool isToday(String date) => DateTime.now().toString().split(" ")[0] == date;

void showToast(String message) => Fluttertoast.showToast(msg: message, fontSize: 16, backgroundColor: orange.withOpacity(.6));
