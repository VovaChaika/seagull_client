import 'package:hive/hive.dart';

class DarkModeRepository {

  final Box<bool> darkModeBox;
  final String _key = 'darkMode';

  DarkModeRepository(this.darkModeBox);

  Future<bool> getDarkMode() async {
    return darkModeBox.get(_key, defaultValue: false)!;
  }

  Future<bool> saveDarkMode(bool darkMode) async {
     darkModeBox.put(_key, darkMode);
     return darkMode;
  }
}
