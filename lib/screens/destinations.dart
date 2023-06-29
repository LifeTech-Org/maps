import 'package:flutter/material.dart';
import 'package:maps/models/location.dart';
import 'package:maps/widgets/Search.dart';

class Destinations extends StatelessWidget {
  Destinations({super.key});
  final List<Location> popular = [
    Location(
      latitude: 0.00,
      longitude: 0.00,
      place: Place(
        name: "Home",
        address: "Some kind of home address",
      ),
    ),
    Location(
      latitude: 0.00,
      longitude: 0.00,
      place: Place(
        name: "Home",
        address: "Some kind of home address",
      ),
    ),
    Location(
      latitude: 0.00,
      longitude: 0.00,
      place: Place(
        name: "Home",
        address: "Some kind of home address",
      ),
    ),
    Location(
      latitude: 0.00,
      longitude: 0.00,
      place: Place(
        name: "Home",
        address: "Some kind of home address",
      ),
    )
  ];

  final List<Location> recents = [
    Location(
      latitude: 0.00,
      longitude: 0.00,
      place: Place(
        name: "Home",
        address: "Some kind of home address",
      ),
    ),
    Location(
      latitude: 0.00,
      longitude: 0.00,
      place: Place(
        name: "Home",
        address: "Some kind of home address",
      ),
    ),
    Location(
      latitude: 0.00,
      longitude: 0.00,
      place: Place(
        name: "Home",
        address: "Some kind of home address",
      ),
    ),
    Location(
      latitude: 0.00,
      longitude: 0.00,
      place: Place(
        name: "Home",
        address: "Some kind of home address",
      ),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Search(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Divider(
                      thickness: 12,
                      height: 12,
                      color: Theme.of(context).highlightColor,
                    ),
                    ListBox(
                        locations: popular,
                        icon: Icons.access_time_sharp,
                        title: 'Recents'),
                    Divider(
                      thickness: 12,
                      height: 12,
                      color: Theme.of(context).highlightColor,
                    ),
                    ListBox(
                      locations: recents,
                      icon: Icons.favorite,
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
              return Column(
                children: [
                  ListTile(
                    leading: Icon(icon),
                    title: Text(
                      locations.elementAt(index).place!.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      locations.elementAt(index).place!.address,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    dense: true,
                    onTap: () {
                      print("here");
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
