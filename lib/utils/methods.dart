import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speak/utils/globals.dart';

Future<bool> load() async {
  try {
    Hive.init((await getApplicationDocumentsDirectory()).path);
    Hive.deleteBoxFromDisk("translations");
    translationsBox = await Hive.openBox("translations");
    final Map<String, dynamic>? data = translationsBox!.get("translations");
    if (data == null) {
      translationsBox!.put("translations", <String, List<Map<String, dynamic>>>{});
    }
    if (data!.isEmpty) {
      translationsBox!.put("translations", <String, List<Map<String, dynamic>>>{DateTime.now().toString().split(' ')[0]: <Map<String, dynamic>>[]});
    }
    if (!isToday(data.keys.last.splitMapJoin(" ")[0]) && data.values.last.isEmpty) {
      translationsBox!.put("translations", data..remove(data.keys.last));
    }
    if (!isToday(data.keys.last.splitMapJoin(" ")[0])) {
      translationsBox!.put("translations", data..addAll(<String, List<Map<String, dynamic>>>{DateTime.now().toString().split(' ')[0]: <Map<String, dynamic>>[]}));
    }
    return true;
  } catch (e) {
    return false;
  }
}

bool isToday(String date) => DateTime.now().toString().split(" ")[0].split("-") == date.split("-");

void showToast(String message) => Fluttertoast.showToast(msg: message, fontSize: 16, backgroundColor: orange.withOpacity(.6));
