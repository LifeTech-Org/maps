import 'package:flutter/material.dart';
import 'package:maps/providers/user.dart';
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
    return Consumer<User>(builder: (context, user, widget) {
      return AlertDialog(
        title: Text('Some kind of a place'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your route will be redirected along this location. This will mostly affect the estimated time of arrival.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // user.setWayPoint(latitude, longitude);
              Navigator.of(context).pop();
            },
            child: const Text('Add to WayPoint'),
          ),
        ],
      );
    });
  }
}
