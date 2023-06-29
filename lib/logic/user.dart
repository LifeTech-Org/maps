import 'package:flutter/material.dart';
import 'package:maps/models/user.dart';
import 'package:maps/utils/role.dart';
import 'package:maps/utils/vehicle.dart';

class User extends ChangeNotifier {
  final UserModel user = UserModel(
    userRole: UserRole.driver,
  );

  UserRole get role => user.role;
  void setUserRole(UserRole userRole) {
    user.setRole(userRole);
    notifyListeners();
  }

  Vehicle? get vehicle => user.vehicle;

  void setVehicle(VehicleType vehicleType, int noOfSeaters) {
    user.setVehicle(vehicleType, noOfSeaters);
    notifyListeners();
  }
}
