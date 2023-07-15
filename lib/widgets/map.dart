import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/helpers/permissions.dart';
import 'package:maps/providers/server.dart';
import 'package:maps/providers/user.dart';
import 'package:maps/utils/role.dart';
import 'package:maps/widgets/destination.dart';
import 'package:maps/widgets/edit_profile.dart';
import 'package:maps/widgets/way_point.dart';
import 'package:provider/provider.dart';
import 'package:maps/resources/vehicles.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key, required Completer<GoogleMapController> controller})
      : _controller = controller;
  final Completer<GoogleMapController> _controller;
  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(7.4433, 3.9003), // Center of the map
    zoom: 15.0, // Adjust the zoom level as needed
  );
  final LatLngBounds ibadanBounds = LatLngBounds(
    southwest: const LatLng(
        7.429091240979396, 3.876443468034268), // Southwest corner of the area
    northeast: const LatLng(
        7.461057931090044, 3.9107388630509377), // Northeast corner of the area
  );

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarkerWithHue(10);

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
    _listenToLocation();
    setDestinationIcon();
  }

  Future<void> setDestinationIcon() async {
    final image = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'images/flag.png');
    setState(() {
      destinationIcon = image;
    });
  }

  void connectToWebSocket() async {
    Provider.of<Server>(context, listen: false)
        .addListener(_listenToConnection);
  }

  Future<BitmapDescriptor> driverMarker(int vehicleIndex) async {
    final images = [
      'images/car.png',
      'images/car.png',
      'images/car.png',
      'images/car.png',
      'images/car.png',
    ];
    final image = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), images.elementAt(vehicleIndex));
    return image;
  }

  void _listenToConnection() {
    final socket = Provider.of<Server>(context, listen: false).socket;
    socket.ready.then((value) {
      final user = Provider.of<User>(context, listen: false);
      if (user.role == UserRole.passenger) {
        socket.stream.listen((event) async {
          user.setConnectionState(ConnectionState.done);
          final List<dynamic> data = json.decode(event);
          final List<Marker> tempMarkers = [];
          for (dynamic marker in data) {
            final latitude = marker['location']['latitude'].toString();
            final longitude = marker['location']['longitude'].toString();
            final heading = marker['location']['heading'].toString();
            final vehicleIndex = marker['vehicleIndex'].toString();
            final id = marker['id'].toString();
            final intVehicleIndex = int.parse(vehicleIndex);
            double doubleLatitude = double.parse(latitude);
            double doubleLongitude = double.parse(longitude);
            double doubleHeading = double.parse(heading);
            final icon = await driverMarker(1);
            tempMarkers.add(Marker(
              markerId: MarkerId(id),
              position: LatLng(doubleLatitude, doubleLongitude),
              infoWindow: InfoWindow(
                  title: vehicles
                      .elementAt(intVehicleIndex)
                      .name(), // Marker tit/ Additional text (shown when clicked)
                  snippet:
                      '${vehicles.elementAt(intVehicleIndex).noOfSeaters} seaters'),
              icon: icon,
              rotation: doubleHeading,
            ));
          }
          setState(() {
            _markers.clear();
            _markers.addAll(tempMarkers);
          });
        }).onDone(() {
          user.setConnectionState(ConnectionState.none);
          user.cancelDestination();
          setState(() {
            _polylines.clear();
            _markers.clear();
          });
        });
      } else {
        socket.stream.listen((event) async {
          final data = json.decode(event);
          if (data["type"] == "route") {
            user.setConnectionState(ConnectionState.done);
            final route = data["route"]["polyline"]["encodedPolyline"];
            final polylines = decodePolyline(route);
            List<LatLng> coordinates = [];
            for (List<num> coordinate in polylines) {
              coordinates.add(LatLng(coordinate.elementAt(0).toDouble(),
                  coordinate.elementAt(1).toDouble()));
            }
            _polylines.clear();
            _polylines.add(Polyline(
                polylineId: PolylineId(user.destination!.place!.name),
                color: Colors.black38,
                points: coordinates,
                width: 4));
          } else {
            final locations = data["locations"];
            final List<Marker> tempMarkers = [];
            for (dynamic marker in locations) {
              final latitude = marker['location']['latitude'].toString();

              final longitude = marker['location']['longitude'].toString();
              final heading = marker['location']['heading'].toString();

              final id = marker['id'].toString();
              double doubleLatitude = double.parse(latitude);
              double doubleLongitude = double.parse(longitude);
              double doubleHeading = double.parse(heading);
              tempMarkers.add(
                Marker(
                  markerId: MarkerId(id),
                  position: LatLng(doubleLatitude, doubleLongitude),
                  infoWindow: const InfoWindow(
                    title:
                        'Passenger', // Marker title // Additional text (shown when clicked)
                  ),
                  rotation: doubleHeading,
                  icon: BitmapDescriptor.defaultMarkerWithHue(40),
                ),
              );
            }
            setState(() {
              _markers.clear();
              _markers.addAll(tempMarkers);
            });
          }
        }).onDone(() {
          user.setConnectionState(ConnectionState.none);
          user.cancelDestination();
          user.clearWayPoint();
          setState(() {
            _polylines.clear();
            _markers.clear();
          });
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  void _listenToLocation() {
    Provider.of<User>(context, listen: false)
        .addListener(_handleLocationChange);
  }

  void _handleLocationChange() async {
    final server = Provider.of<Server>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);
    if (user.connectionState == ConnectionState.done) {
      final location = user.location;
      if (location != null) {
        final GoogleMapController newController =
            await widget._controller.future;
        final zoom = await newController.getZoomLevel();
        await newController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(location.latitude, location.longitude),
              zoom: zoom,
            ),
          ),
        );
        server.socket.ready.then((value) {
          server.socket.sink.add(
            json.encode({
              "location": {
                "latitude": location.latitude,
                "longitude": location.longitude,
                "heading": location.heading,
              }
            }),
          );
        });
      }
    }
  }

  Marker userLocationMarker(User user) {
    return Marker(
      markerId: const MarkerId('Your Location'),
      position: LatLng(user.location!.latitude, user.location!.longitude),
      infoWindow: const InfoWindow(
        title: "Your Location",

        /// Additio nal text (shown when clicked)
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(200),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<User>(context, listen: false)
        .removeListener(_handleLocationChange);
    Provider.of<Server>(context, listen: false)
        .removeListener(_listenToConnection);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: ((context, user, child) {
        return GoogleMap(
          mapType: MapType.normal,
          cameraTargetBounds: CameraTargetBounds(ibadanBounds),
          initialCameraPosition: _kGooglePlex,
          zoomControlsEnabled: false,
          buildingsEnabled: true,
          polylines: _polylines,
          markers: user.destination == null
              ? (user.location == null
                  ? {}
                  : {
                      userLocationMarker(user),
                    })
              : {
                  ..._markers,
                  userLocationMarker(user),
                  Marker(
                    markerId: const MarkerId('Your destination'),
                    position: LatLng(user.destination!.latitude,
                        user.destination!.longitude),
                    infoWindow: const InfoWindow(
                      title: "Your destination",

                      /// Additional text (shown when clicked)
                    ),
                    icon: destinationIcon,
                  ),
                },
          onTap: (LatLng latLng) async {
            print(
                'Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}');
            if (user.location == null) {
              final locationIsPermitted = await hasPermission();
              if (locationIsPermitted) {
                user.listenToLocation();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Set permission for location.'),
                ));
                return;
              }
            }
            if (user.destination == null) {
              if (user.role == UserRole.driver && user.vehicleIndex == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please set up your driving profile first!'),
                  action: SnackBarAction(
                      label: 'Set Profile',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => EditProfile(),
                        );
                      }),
                ));
                return;
              }
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => Destination(
                  latitude: latLng.latitude,
                  longitude: latLng.longitude,
                ),
              );
            } else {
              if (user.role == UserRole.driver) {
                showDialog(
                  context: context,
                  builder: (context) => WayPoint(
                    latitude: latLng.latitude,
                    longitude: latLng.longitude,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('You are on a destination already!'),
                  action: SnackBarAction(
                      label: 'Stop',
                      onPressed: () {
                        Provider.of<Server>(context, listen: false)
                            .closeWebSocket();
                      }),
                ));
              }
            }
          },
          onMapCreated: (GoogleMapController controller) {
            widget._controller.complete(controller);
          },
        );
      }),
    );
  }
}
