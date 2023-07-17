import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:maps/providers/intro.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

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
              title: 'Welcome to Go Smart',
              centerWidget: Image.asset('images/branding.png'),
              styleTitle: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 28),
              styleDescription:
                  TextStyle(color: Theme.of(context).dividerColor),
              description:
                  "A realtime geolocator to track location and direction of drivers and potential passengers.",
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            ContentConfig(
              title: "For passengers and drivers",
              centerWidget: Image.asset('images/switch.jpg'),
              styleTitle: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 28),
              styleDescription:
                  TextStyle(color: Theme.of(context).dividerColor),
              description:
                  "Switch between driver's and passenger's mode easily. You can click the outlined button to toggle mode.",
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            ContentConfig(
              title: "Set destination easily",
              centerWidget: Image.asset('images/destination.jpg'),
              styleTitle: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 28),
              styleDescription:
                  TextStyle(color: Theme.of(context).dividerColor),
              description:
                  "Efficiently track location of potential passengers or drivers in realtime when you have set your destination by clicking on the map and connected to the server.",
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ],
        );
      }),
    );
  }
}
