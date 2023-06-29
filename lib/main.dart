import 'package:flutter/material.dart';
import 'package:maps/logic/float_height.dart';
import 'package:maps/logic/user.dart';
import 'package:maps/screens/destinations.dart';
import 'package:maps/widgets/my_draggable_sheet.dart';
import 'package:maps/widgets/map.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maps',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        primaryColor: Colors.blue,
        primaryColorLight: Colors.blue.shade100,
        shadowColor: Colors.black12,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      theme: ThemeData(
        primaryColor: Colors.blue,
        primaryColorLight: Colors.blue.shade100,
        shadowColor: Colors.black12,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => User()),
          ChangeNotifierProvider(create: (context) => FLoatingHeight()),
        ],
        child: Scaffold(
            body: MyHomePage(),
            floatingActionButton:
                Consumer<FLoatingHeight>(builder: ((context, floating, child) {
              return Container(
                margin: EdgeInsets.only(bottom: floating.height),
                child: FloatingActionButton(
                  onPressed: () {},
                  child: Icon(Icons.location_searching),
                ),
              );
            }))),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Map(),
        Container(
          margin: const EdgeInsets.only(
            top: 40,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(200),
                child: Container(
                    height: 48,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(200),
                      border:
                          Border.all(color: Theme.of(context).highlightColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Choose from popular destinations',
                          style:
                              Theme.of(context).inputDecorationTheme.hintStyle,
                        ),
                      ],
                    )),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => Destinations()),
                  ));
                },
              )
            ],
          ),
        ),
        MyDraggableSheet()
      ],
    );
  }
}
