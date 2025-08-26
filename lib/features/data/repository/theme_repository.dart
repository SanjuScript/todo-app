import 'package:hive/hive.dart';
import 'package:todo_app/features/data/repository/theme_repo.dart';

class ThemeRepository implements ThemeRepo {
  final Box settingsBox = Hive.box('settingsBox');

  @override
  int loadTheme() {
    return settingsBox.get('themeMode',defaultValue: 0);
  }

  @override
  Future<void> saveTheme(int theme) async {
    await settingsBox.put('themeMode', theme);
  }
}
