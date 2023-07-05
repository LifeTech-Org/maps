import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maps/providers/server.dart';
import 'package:maps/providers/user.dart';
import 'package:maps/models/location.dart';
import 'package:maps/utils/role.dart';
import 'package:maps/widgets/skeletons/destination.dart';
import 'package:provider/provider.dart';
import 'package:maps/utils/connection_state.dart';

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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_clock,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Estimated duration: ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        snapshot.data!['time'] ?? "*",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
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
                            "longitude": user.location!.longitude
                          },
                          "destination": {
                            "latitude": latitude,
                            "longitude": longitude
                          }
                        };
                        Provider.of<Server>(context, listen: false)
                            .socket
                            .sink
                            .add(json.encode(parsel));
                        user.setDestination(
                          latitude,
                          longitude,
                          Place(
                              name: 'UI Gate',
                              address:
                                  'Some notable address of UI gate intentionally made long to test how well its overlow'),
                        );
                        user.setConnectionState(ConnectionState.done);
                        Navigator.pop(context);
                      }).catchError((e) {
                        print(e);
                      });

                      user.setConnectionState(ConnectionState.done);
                    },
                    child: user.connectionState == ConnectionState.waiting
                        ? const CircularProgressIndicator()
                        : const Text('Set as destination'),
                  );
                }),
              ],
            );
          }
          if (snapshot.hasError) {
            return const AlertDialog(
              title: Text('Oooppsss'),
              content: Text('something went wrong'),
            );
          }
          return const AlertDialog(
            title: Text('Whats this place?'),
            content: Text('Somewhow we couldnt find this place'),
          );
        });
  }
}
