import 'package:maps/models/server.dart';
import 'package:maps/utils/role.dart';
import 'package:web_socket_channel/io.dart';

abstract class ServerRepository {
  factory ServerRepository() => ServerModel();

  void disconnect();

  IOWebSocketChannel get socket;

  Future<Map<String, String>> getPlace(double latitude, double longitude);

  IOWebSocketChannel connectToWebSocket(UserRole userRole);
}
