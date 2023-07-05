import 'package:flutter/material.dart';
import 'package:maps/models/location.dart';
import 'package:maps/utils/role.dart';
import 'package:maps/utils/vehicle.dart';

class UserModel {
  UserModel({required UserRole userRole, vehicle})
      : _userRole = userRole,
        _vehicle = vehicle;

  factory UserModel.fromString({required String? userRole}) {
    return UserModel(
        userRole: userRole == "driver" ? UserRole.driver : UserRole.passenger);
  }
  UserRole _userRole;
  Vehicle? _vehicle;
  Location? _destination;
  Location? _location;
  int? _vehilceIndex;

  ConnectionState _connectionState = ConnectionState.none;

  UserRole get role => _userRole;

  int? get vehicleIndex => _vehilceIndex;

  Vehicle? get vehicle => _vehicle;

  Location? get destination => _destination;

  Location? get location => _location;

  ConnectionState get connectionState => _connectionState;

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

  void setDestination(double latitude, double longitude, Place? place) {
    _destination =
        Location(latitude: latitude, longitude: longitude, place: place);
  }

  void setLocation(double latitude, double longitude) {
    _location = Location(latitude: latitude, longitude: longitude);
  }

  void setVehicleIndex(int? index) {
    _vehilceIndex = index;
  }

  void cancelDestination() {
    _destination = null;
  }

  void setConnectionState(ConnectionState state) {
    _connectionState = state;
  }
}
