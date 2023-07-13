import 'package:flutter/material.dart';
import 'package:maps/interfaces/intro.dart';

class Intro extends ChangeNotifier {
  final intro = IntroRepository();

  Future<bool> get showIntro => intro.showIntro();

  void dontShowIntroAgain() {
    intro.dontShowIntroAgain();
    notifyListeners();
  }
}
