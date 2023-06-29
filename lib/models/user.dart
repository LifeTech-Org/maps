import 'package:maps/utils/role.dart';
import 'package:maps/utils/vehicle.dart';

class UserModel {
  UserModel({required userRole, vehicle})
      : _userRole = userRole,
        _vehicle = vehicle;
  UserRole _userRole;
  Vehicle? _vehicle;

  UserRole get role => _userRole;

  Vehicle? get vehicle => _vehicle;

  void setRole(UserRole userRole) {
    _userRole = userRole;
  }

  void setVehicle(VehicleType vehicleType, int noOfSeaters) {
    if (_userRole == UserRole.driver) {
      _vehicle = Vehicle(
        vehicleType: vehicleType,
        noOfSeaters: noOfSeaters,
      );
    }
  }
}
