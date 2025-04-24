import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalGetStorage {
  static GetStorage get box => GetStorage();

  static setEnglishLanguage(bool val) async {
    box.write('isEnglish', val);
  }

  static getUserLanguage() {
    return box.read('isEnglish') == true ? 'en' : 'de';
  }
}
