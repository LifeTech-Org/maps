import 'package:flutter/material.dart';
import 'package:maps/providers/user.dart';
import 'package:maps/resources/vehicles.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({
    super.key,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = Provider.of<User>(context, listen: false).vehicleIndex;
  }

  void handleChangeSelectedVehicle(int? newSelectedIndex) {
    setState(() {
      selectedIndex = newSelectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = Provider.of<User>(context, listen: false).vehicle;
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 8,
      ),
      title: Text(
        vehicle == null ? "Set driving profile" : "Change driving profile",
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            vehicles.length,
            (index) {
              final vehicle = vehicles.elementAt(index);
              return RadioListTile<int>(
                value: index,
                groupValue: selectedIndex,
                onChanged: handleChangeSelectedVehicle,
                title: Text(
                  vehicle.name(),
                ),
                subtitle: Row(
                  children: [
                    Icon(Icons.people, size: 14),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(vehicle.noOfSeaters.toString() + ' seaters')
                  ],
                ),
                secondary: Icon(Icons.car_crash),
              );
            },
          ).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (selectedIndex != null) {
              Provider.of<User>(context, listen: false)
                  .setVehicleIndex(selectedIndex!)
                  .then((value) {
                Navigator.of(context).pop();
              });
              // Provider.of<User>(context, listen: false)
              //     .setUserRole(UserRole.driver);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('No driving profile has been selected!'),
              ));
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
    ;
  }
}
