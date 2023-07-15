import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maps/providers/server.dart';
import 'package:maps/providers/user.dart';
import 'package:maps/widgets/shimmer.dart';
import 'package:maps/widgets/skeletons/destination.dart';
import 'package:provider/provider.dart';

class WayPoint extends StatefulWidget {
  const WayPoint(
      {super.key, required double latitude, required double longitude})
      : _latitude = latitude,
        _longitude = longitude;

  final double _longitude;
  final double _latitude;

  @override
  State<WayPoint> createState() => _WayPointState();
}

class _WayPointState extends State<WayPoint> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final longitude = widget._longitude;
    final latitude = widget._latitude;
    return FutureBuilder(
        future: Provider.of<Server>(context, listen: false)
            .getPlace(latitude, longitude),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DestinationSkeleton();
          }
          if (snapshot.hasData) {
            return AlertDialog(
              title: Text(snapshot.data!['name'] ?? ""),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your route will be redirected along ${snapshot.data!['address']}.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              actions: [
                Consumer<User>(builder: (context, user, widget) {
                  return TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: user.connectionState == ConnectionState.waiting
                          ? const MyShimmer(
                              height: 20,
                              width: 80,
                            )
                          : const Text('Cancel'));
                }),
                Consumer<User>(builder: (context, user, widget) {
                  return TextButton(
                    onPressed: () {
                      user.setConnectionState(ConnectionState.waiting);
                      user.addWayPoint(latitude, longitude);
                      final parsel = {
                        "location": {
                          "latitude": user.location!.latitude,
                          "longitude": user.location!.longitude
                        },
                        "destination": {
                          "latitude": user.destination!.latitude,
                          "longitude": user.destination!.longitude
                        },
                        "vehicleIndex": user.vehicleIndex,
                        "wayPoints": user.wayPoints
                            .map((wayPoint) => {
                                  "latitude": wayPoint.latitude,
                                  "longitude": wayPoint.longitude
                                })
                            .toList(),
                      };
                      Provider.of<Server>(context, listen: false)
                          .socket
                          .sink
                          .add(json.encode(parsel));
                      Navigator.pop(context);
                    },
                    child: user.connectionState == ConnectionState.waiting
                        ? const MyShimmer(
                            height: 20,
                            width: 100,
                          )
                        : const Text('Add to waypoints'),
                  );
                }),
              ],
            );
          }
          return const AlertDialog(
            title: Text('Oooppsss'),
            content: Text('something went wrong'),
          );
        });
  }
}
