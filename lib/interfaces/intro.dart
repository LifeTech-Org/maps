import 'package:maps/models/intro.dart';

abstract class IntroRepository {
  factory IntroRepository() => IntroModel();
  void dontShowIntroAgain();
  Future<bool> showIntro();
}
