import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:maps/providers/server.dart';
import 'package:maps/providers/user.dart';
import 'package:maps/utils/role.dart';
import 'package:maps/widgets/destination.dart';
import 'package:maps/widgets/edit_profile.dart';
import 'package:maps/widgets/way_point.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

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
    southwest: LatLng(7.4330, 3.8050), // Southwest corner of the area
    northeast: LatLng(7.4508, 4.147), // Northeast corner of the area
  );

  Set<Marker> _markers = {};

  // void addUserLocationMarker(double latitude, double longitude) {
  //   setState(() {
  //     _markers.add(Marker(
  //       markerId: const MarkerId('user'),
  //       position: LatLng(latitude, longitude),
  //       infoWindow: const InfoWindow(
  //         title: 'You', // Marker title (shown when clicked)
  //         snippet: 'Your location', // Additional text (shown when clicked)
  //       ),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(10),
  //     ));
  //   });
  // }

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
    // _listenToUser();
  }

  void connectToWebSocket() async {
    Provider.of<Server>(context, listen: false)
        .addListener(_listenToConnection);
  }

  void _listenToConnection() {
    final socket = Provider.of<Server>(context, listen: false).socket;
    socket.ready.then((value) {
      if (Provider.of<User>(context, listen: false).role ==
          UserRole.passenger) {
        socket.stream.listen((event) {
          final List<dynamic> data = json.decode(event);
          final List<Marker> tempMarkers = [];
          for (dynamic marker in data) {
            final latitude = marker['location']['latitude'].toString();

            final longitude = marker['location']['longitude'].toString();

            final id = marker['id'].toString();
            double doubleLatitude = double.parse(latitude);
            double doubleLongitude = double.parse(longitude);
            tempMarkers.add(Marker(
              markerId: MarkerId(id),
              position: LatLng(doubleLatitude, doubleLongitude),
              infoWindow: InfoWindow(
                title: id, // Marker title (shown when clicked)
                snippet:
                    'Your location', // Additional text (shown when clicked)
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(10),
            ));
          }
          setState(() {
            _markers.clear();
            _markers.addAll(tempMarkers);
          });
        }).onDone(() {
          Provider.of<User>(context, listen: false).cancelDestination();
          setState(() {
            _markers.clear();
          });
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  void _listenToUser() {
    Provider.of<User>(context, listen: false).addListener(_handleUserChange);
  }

  void _handleUserChange() async {
    final user = Provider.of<User>(context, listen: false);
    final location = user.location;
    if (location != null) {
      final GoogleMapController newController = await widget._controller.future;
      final zoom = await newController.getZoomLevel();
      await newController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(location.latitude, location.longitude),
            zoom: zoom,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<User>(context).removeListener(_handleUserChange);
    Provider.of<Server>(context).removeListener(_listenToConnection);
  }

  @override
  Widget build(BuildContext context) {
    print(_markers);
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      markers: _markers,
      onTap: (LatLng latLng) {
        final user = Provider.of<User>(context, listen: false);
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
                  label: 'Stop', onPressed: () => user.cancelDestination()),
            ));
          }
        }
      },
      onMapCreated: (GoogleMapController controller) {
        widget._controller.complete(controller);
      },
    );
  }
}
