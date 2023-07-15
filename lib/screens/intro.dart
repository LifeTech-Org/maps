import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:maps/providers/intro.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Intro>(
      builder: ((context, intro, child) {
        return IntroSlider(
          key: UniqueKey(),
          onDonePress: () {
            intro.dontShowIntroAgain();
          },
          listContentConfig: [
            ContentConfig(
              title: 'Welcome to UI Maps',
              styleTitle: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 28),
              styleDescription:
                  TextStyle(color: Theme.of(context).dividerColor),
              description:
                  "A realtime geolocator to track location and direction of drivers and potential passengers.",
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            ContentConfig(
              title: "Works well for passengers and drivers",
              styleTitle: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 28),
              styleDescription:
                  TextStyle(color: Theme.of(context).dividerColor),
              description:
                  "Switch between driver's and passenger's mode easily. You can click the outlined button to toggle mode.",
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            ContentConfig(
              title: "Select destination and get connected",
              styleTitle: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 28),
              styleDescription:
                  TextStyle(color: Theme.of(context).dividerColor),
              description:
                  "Efficiently track location of potential passengers or drivers in realtime when you have set your destination and connected to the server.",
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ],
        );
      }),
    );
  }
}
