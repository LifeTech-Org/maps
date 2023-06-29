enum VehicleType { tricycle, sedan, stationWagon, miniBus }

class Vehicle {
  Vehicle({
    required this.vehicleType,
    required this.noOfSeaters,
  });
  final VehicleType vehicleType;
  final int noOfSeaters;

  String image() {
    String value;
    switch (vehicleType) {
      case VehicleType.miniBus:
        {
          value = "";
          break;
        }
      case VehicleType.sedan:
        {
          value = "";
          break;
        }
      case VehicleType.stationWagon:
        {
          value = "";
          break;
        }
      case VehicleType.tricycle:
        {
          value = "";
          break;
        }
    }
    return value;
  }

  String name() {
    String value;
    switch (vehicleType) {
      case VehicleType.miniBus:
        {
          value = "Mini Bus";
          break;
        }
      case VehicleType.sedan:
        {
          value = "Sedan Car";
          break;
        }
      case VehicleType.stationWagon:
        {
          value = "Station Wagon";
          break;
        }
      case VehicleType.tricycle:
        {
          value = "Tricycle";
          break;
        }
    }
    return value;
  }
}
