import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/helpers/permissions.dart';
import 'package:maps/models/location.dart';
import 'package:maps/models/user.dart';
import 'package:maps/utils/role.dart';
import 'package:maps/utils/vehicle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart' as geo_location;

class User extends ChangeNotifier {
  final UserModel _userModel = UserModel(userRole: UserRole.passenger);

  Future<void> init() async {
    // final wait = await Future.delayed(Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
    String? userRole = prefs.getString('userRole');
    int? vehicleIndex = prefs.getInt('vehicleIndex');
    _userModel
        .setRole(userRole == "driver" ? UserRole.driver : UserRole.passenger);
    _userModel.setVehicleIndex(vehicleIndex);
    notifyListeners();
  }

  Future<void> listenToLocation() async {
    bool isPermitted = await hasPermission();
    if (isPermitted) {
      geo_location.Location location = geo_location.Location();
      location.onLocationChanged.listen((locationData) {
        if (locationData.latitude != null && locationData.longitude != null) {
          print({
            "latitude": locationData.latitude,
            "longitude": locationData.longitude,
            "heading": locationData.heading
          });
          _userModel.setLocation(locationData.latitude!,
              locationData.longitude!, locationData.heading!);
          notifyListeners();
        }
      });
    }
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  UserRole get role => _userModel.role;

  Vehicle? get vehicle => _userModel.vehicle;

  int? get vehicleIndex => _userModel.vehicleIndex;

  Location? get destination => _userModel.destination;

  Location? get location => _userModel.location;

  List<Location> get wayPoints => _userModel.wayPoints;

  Completer<GoogleMapController> get controller => _controller;

  ConnectionState get connectionState => _userModel.connectionState;

  Future<void> setUserRole(UserRole userRole) async {
    // final wait = await Future.delayed(Duration(seconds: 3));
    _userModel.setRole(userRole);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'userRole', userRole == UserRole.driver ? "driver" : "passenger");
    notifyListeners();
  }

  Future<void> setVehicleIndex(int vehicleIndex) async {
    _userModel.setVehicleIndex(vehicleIndex);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('vehicleIndex', vehicleIndex);
    notifyListeners();
  }

  Future<void> setDestination(
      double latitude, double longitude, Place place) async {
    _userModel.setDestination(
      latitude,
      longitude,
      place,
    );
    notifyListeners();
  }

  Future<void> setLocation(
      double latitude, double longitude, double heading) async {
    _userModel.setLocation(latitude, longitude, heading);
    notifyListeners();
  }

  Future<void> cancelDestination() async {
    _userModel.cancelDestination();
    notifyListeners();
  }

  void setConnectionState(ConnectionState state) {
    _userModel.setConnectionState(state);
    notifyListeners();
  }

  void addWayPoint(double latitude, double longitude) {
    _userModel.addWayPoint(latitude, longitude);
    notifyListeners();
  }

  void clearWayPoint() {
    _userModel.clearPoint();
    notifyListeners();
  }
}
