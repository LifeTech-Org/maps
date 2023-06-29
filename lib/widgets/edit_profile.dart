import 'package:flutter/material.dart';
import 'package:maps/utils/vehicle.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key, Vehicle? vehicle, required changeVehicle})
      : _vehicle = vehicle,
        _changeVehicle = changeVehicle;
  final Vehicle? _vehicle;
  final Function(Vehicle vehicle) _changeVehicle;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final List<Vehicle> _vehicles = [
    Vehicle(
      vehicleType: VehicleType.tricycle,
      noOfSeaters: 3,
    ),
    Vehicle(
      vehicleType: VehicleType.sedan,
      noOfSeaters: 4,
    ),
    Vehicle(
      vehicleType: VehicleType.stationWagon,
      noOfSeaters: 6,
    ),
    Vehicle(
      vehicleType: VehicleType.miniBus,
      noOfSeaters: 13,
    ),
    Vehicle(
      vehicleType: VehicleType.miniBus,
      noOfSeaters: 18,
    ),
  ];
  Vehicle? selectedVehicle;

  @override
  void initState() {
    super.initState();
    selectedVehicle = widget._vehicle;
  }

  void handleChangeSelectedVehicle(Vehicle? newVehicle) {
    setState(() {
      selectedVehicle = newVehicle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 8,
      ),
      title: Text(
        widget._vehicle == null
            ? "Set driving profile"
            : "Change driving profile",
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            _vehicles.length,
            (index) {
              final vehicle = _vehicles.elementAt(index);
              return RadioListTile(
                value: vehicle,
                groupValue: selectedVehicle,
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
            if (selectedVehicle != null) {
              print("he");
              widget._changeVehicle(selectedVehicle!);
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
