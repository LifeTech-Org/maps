import 'package:maps/interfaces/intro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroModel implements IntroRepository {
  @override
  Future<bool> showIntro() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('showIntro');
    return value ?? true;
  }

  @override
  void dontShowIntroAgain() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showIntro', false);
  }
}
