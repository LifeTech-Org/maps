import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/models/location.dart';
import 'package:maps/models/user.dart';
import 'package:maps/resources/vehicles.dart';
import 'package:maps/utils/role.dart';
import 'package:maps/utils/vehicle.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  UserRole get role => _userModel.role;

  Vehicle? get vehicle => _userModel.vehicle;

  int? get vehicleIndex => _userModel.vehicleIndex;

  Location? get destination => _userModel.destination;

  Location? get location => _userModel.location;

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

  Future<void> setLocation(double latitude, double longitude) async {
    _userModel.setLocation(latitude, longitude);
    notifyListeners();
  }

  Future<void> cancelDestination() async {
    _userModel.cancelDestination();
    notifyListeners();
  }

  void setConnectionState(ConnectionState state) {
    _userModel.setConnectionState(state);
  }
}
