import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<bool> load() async {
  try {
    Hive.init((await getApplicationDocumentsDirectory()).path);

    return true;
  } catch (e) {
    return false;
  }
}
