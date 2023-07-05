class Location {
  Location({required double latitude, required double longitude, Place? place})
      : _latitude = latitude,
        _longitude = longitude,
        _place = place;
  final double _latitude;
  final double _longitude;
  Place? _place;

  double get latitude => _latitude;
  double get longitude => _longitude;
  Place? get place => _place;

  void setPlace(String name, String address) {
    _place = Place(name: name, address: address);
  }

  Map<String, dynamic> toJson() {
    return {"latitude": _latitude, "longitude": _longitude};
  }
}

class Place {
  Place({required String name, required String address})
      : _name = name,
        _address = address;
  final String _name;
  final String _address;

  String get name => _name;
  String get address => _address;
}
