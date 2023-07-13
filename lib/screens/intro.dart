import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:maps/providers/intro.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroPage extends StatelessWidget {
  IntroPage({super.key});
  // final List<ContentConfig> _contentsConfig = [
  //    ContentConfig(
  //     title: "Weelcome to UI Map",
  //     description:
  //         "A realtime tracker to track location and direction of drivers and potential passengers.",
  //     backgroundColor: ),
  //   ),
  //   const ContentConfig(
  //     title: "PENCIL",
  //     description: "Ye indulgence unreserved connection alteration appearance",
  //     backgroundColor: Color(0xff203152),
  //   ),
  //   const ContentConfig(
  //     title: "RULER",
  //     description:
  //         "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of",
  //     backgroundColor: Color(0xff9932CC),
  //   ),
  // ];

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
              title: "SOmething sha",
              styleTitle: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 28),
              styleDescription:
                  TextStyle(color: Theme.of(context).dividerColor),
              description:
                  "Switch between driver's and passenger's mode easily. You can click the outlined button to make changes.",
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            ContentConfig(
              title: "Something sha agian",
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
