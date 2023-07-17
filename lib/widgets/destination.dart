import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maps/providers/server.dart';
import 'package:maps/providers/user.dart';
import 'package:maps/models/location.dart';
import 'package:maps/widgets/shimmer.dart';
import 'package:maps/widgets/skeletons/destination.dart';
import 'package:provider/provider.dart';

class Destination extends StatefulWidget {
  const Destination(
      {super.key, required double latitude, required double longitude})
      : _latitude = latitude,
        _longitude = longitude;

  final double _longitude;
  final double _latitude;

  @override
  State<Destination> createState() => _DestinationState();
}

class _DestinationState extends State<Destination> {
  late Map<String, String> place;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final longitude = widget._longitude;
    final latitude = widget._latitude;
    return FutureBuilder<Map<String, String>>(
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
                    snapshot.data!['address'] ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     const Icon(
                  //       Icons.lock_clock,
                  //       size: 16,
                  //     ),
                  //     const SizedBox(
                  //       width: 5,
                  //     ),
                  //     Text(
                  //       'Estimated duration: ',
                  //       style: Theme.of(context).textTheme.bodyMedium,
                  //     ),
                  //     Text(
                  //       snapshot.data!['time'] ?? "*",
                  //       style: Theme.of(context).textTheme.titleSmall,
                  //     ),
                  //   ],
                  // )
                ],
              ),
              actions: [
                Consumer<User>(builder: (context, user, widget) {
                  return TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: user.connectionState == ConnectionState.waiting
                          ? const MyShimmer(
                              height: 20,
                              width: 60,
                            )
                          : const Text('Cancel'));
                }),
                Consumer<User>(builder: (context, user, widget) {
                  return TextButton(
                    onPressed: () {
                      user.setConnectionState(ConnectionState.waiting);
                      Provider.of<Server>(context, listen: false)
                          .connectWebSocket(user.role)
                          .then((value) {
                        final parsel = {
                          "location": {
                            "latitude": user.location!.latitude,
                            "longitude": user.location!.longitude,
                            "heading": user.location!.heading,
                          },
                          "destination": {
                            "latitude": latitude,
                            "longitude": longitude
                          },
                          "vehicleIndex": user.vehicleIndex,
                        };
                        Provider.of<Server>(context, listen: false)
                            .socket
                            .sink
                            .add(json.encode(parsel));
                        user.setDestination(
                          latitude,
                          longitude,
                          Place(
                              name: snapshot.data!['address']!,
                              address: snapshot.data!['address']!),
                        );
                        Navigator.pop(context);
                      }).catchError((e) {
                        user.setConnectionState(ConnectionState.done);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Couldn't connect to server")));
                      });
                    },
                    child: user.connectionState == ConnectionState.waiting
                        ? const MyShimmer(
                            height: 20,
                            width: 80,
                          )
                        : const Text('Set as destination'),
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
