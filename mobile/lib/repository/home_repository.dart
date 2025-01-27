import 'package:shared_preferences/shared_preferences.dart';

class HomeRepository {
  final SharedPreferences _preferences;

  HomeRepository({
    required SharedPreferences preferences,
  }) : _preferences = preferences;

  static const keyHasReadWelcome = 'key-has-read-welcome';

  bool getHasReadWelcome() {
    return _preferences.getBool(keyHasReadWelcome) ?? false;
  }

  Future<void> setHasReadWelcome(bool value) async {
    await _preferences.setBool(keyHasReadWelcome, value);
  }
}
