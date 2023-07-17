import 'package:flutter/material.dart';
import 'package:maps/models/location.dart';
import 'package:maps/providers/server.dart';
import 'package:maps/providers/user.dart';
import 'package:maps/utils/role.dart';
import 'package:maps/widgets/Search.dart';
import 'package:maps/widgets/destination.dart';
import 'package:maps/widgets/edit_profile.dart';
import 'package:provider/provider.dart';
import 'package:maps/resources/popular_destinations.dart';

class Destinations extends StatefulWidget {
  const Destinations({super.key});

  @override
  State<Destinations> createState() => _DestinationsState();
}

class _DestinationsState extends State<Destinations> {
  String search = '';

  void setSearch(String place) {
    setState(() {
      search = place;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Search(
              setSearch: setSearch,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Divider(
                      thickness: 12,
                      height: 12,
                      color: Theme.of(context).highlightColor,
                    ),
                    Divider(
                      thickness: 12,
                      height: 12,
                      color: Theme.of(context).highlightColor,
                    ),
                    ListBox(
                      locations: popularDestinations
                          .where((location) => location.place!.name
                              .toLowerCase()
                              .contains(search.toLowerCase()))
                          .toList(),
                      icon: Icons.house_rounded,
                      title: 'Popular bus stops',
                    ),
                    Divider(
                      thickness: 12,
                      height: 12,
                      color: Theme.of(context).highlightColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListBox extends StatelessWidget {
  const ListBox(
      {super.key,
      required this.locations,
      required this.icon,
      required this.title});
  final List<Location> locations;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Theme.of(context).highlightColor,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Column(
            children: List.generate(locations.length, (index) {
              final location = locations.elementAt(index);
              return Column(
                children: [
                  ListTile(
                    leading: Icon(icon, color: Theme.of(context).primaryColor),
                    title: Text(
                      location.place!.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      location.place!.address,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    dense: true,
                    onTap: () {
                      final user = Provider.of<User>(context, listen: false);
                      final server =
                          Provider.of<Server>(context, listen: false);
                      if (user.destination != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              const Text('You are on a destination already!'),
                          action: SnackBarAction(
                              label: 'Stop',
                              onPressed: () => server.closeWebSocket()),
                        ));
                      } else {
                        if (user.role == UserRole.driver &&
                            user.vehicleIndex == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text(
                                'Please set up your driving profile first!'),
                            action: SnackBarAction(
                                label: 'Set Profile',
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => const EditProfile(),
                                  );
                                }),
                          ));
                          return;
                        }
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Destination(
                            latitude: location.latitude,
                            longitude: location.longitude,
                          ),
                        ).then((value) {
                          if (user.destination != null) {
                            Navigator.of(context).pop();
                          }
                        });
                      }
                    },
                  ),
                  index < locations.length - 1
                      ? Divider(
                          height: 2,
                          color: Theme.of(context).highlightColor,
                          indent: 50,
                        )
                      : const SizedBox(),
                ],
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
