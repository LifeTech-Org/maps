import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps/helpers/permissions.dart';
import 'package:maps/providers/float_height.dart';
import 'package:maps/providers/server.dart';
import 'package:maps/providers/user.dart';
import 'package:maps/screens/destinations.dart';
import 'package:maps/widgets/my_draggable_sheet.dart';
import 'package:maps/widgets/map.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) {
        final user = User();
        user.init();
        return user;
      }),
      ChangeNotifierProvider(create: (context) => FloatingHeight()),
      ChangeNotifierProvider(create: (context) => Server()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();

  Location location = Location();

  void setUserLocation(double latitude, double longitude) {
    Provider.of<User>(context, listen: false).setLocation(latitude, longitude);
  }

  void getLocation() async {
    // bool serviceEnabled;
    // PermissionStatus permissionGranted;

    // serviceEnabled = await location.serviceEnabled();
    // if (!serviceEnabled) {
    //   serviceEnabled = await location.requestService();
    //   if (!serviceEnabled) {
    //     // Location services are not enabled or were denied
    //     return;
    //   }
    // }

    // permissionGranted = await location.hasPermission();
    // if (permissionGranted == PermissionStatus.denied) {
    //   permissionGranted = await location.requestPermission();
    //   if (permissionGranted != PermissionStatus.granted) {
    //     // Location permissions were denied
    //     return;
    //   }
    // }

    bool permitted = await hasPermission();
    if (!permitted) {
      return;
    }
    location.onLocationChanged.listen((locationData) {
      setUserLocation(locationData.latitude!, locationData.longitude!);
    });

    // LocationData locationData = await location.getLocation();
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maps',
      themeMode: ThemeMode.light,
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
      home: Scaffold(
          body: MyHomePage(
            controller: controller,
          ),
          floatingActionButton:
              Consumer<FloatingHeight>(builder: ((context, floating, child) {
            return Container(
              margin: EdgeInsets.only(bottom: floating.height),
              child: FloatingActionButton(
                onPressed: () async {
                  final location =
                      Provider.of<User>(context, listen: false).location;
                  final GoogleMapController newController =
                      await controller.future;

                  await newController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(location!.latitude, location.longitude),
                        zoom: 15,
                      ),
                    ),
                  );
                },
                child: Icon(Icons.location_searching),
              ),
            );
          }))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required Completer<GoogleMapController> controller})
      : _controller = controller;
  final Completer<GoogleMapController> _controller;
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
        MyMap(controller: widget._controller),
        SearchContainer(),
        MyDraggableSheet()
      ],
    );
  }
}

class SearchContainer extends StatelessWidget {
  const SearchContainer({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context, user, child) {
      return Container(
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
                    border: Border.all(color: Theme.of(context).highlightColor),
                  ),
                  child: Row(
                    children: [
                      user.destination == null
                          ? const Icon(Icons.location_on)
                          : Icon(
                              Icons.directions,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      user.destination == null
                          ? Text(
                              'Choose from popular destinations',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .inputDecorationTheme
                                  .hintStyle,
                            )
                          : Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      user.destination!.place!.address,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      user.cancelDestination();
                                      Provider.of<Server>(context,
                                              listen: false)
                                          .socket
                                          .sink
                                          .close();
                                    },
                                    icon: Icon(
                                      Icons.cancel_rounded,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ),
                                ],
                              ),
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
      );
    });
  }
}
