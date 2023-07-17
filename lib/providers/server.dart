import 'package:flutter/material.dart';
import 'package:maps/interfaces/server.dart';
import 'package:maps/utils/role.dart';
import 'package:web_socket_channel/io.dart';

class Server extends ChangeNotifier {
  final server = ServerRepository();

  Future<Map<String, String>> getPlace(double latitude, double longitude) {
    return server.getPlace(latitude, longitude);
  }

  IOWebSocketChannel get socket => server.socket;

  Future<void> connectWebSocket(UserRole userRole) {
    final connect = server.connectToWebSocket(userRole);
    notifyListeners();
    return connect.ready;
  }

  void closeWebSocket() {
    server.socket.sink.close();
    notifyListeners();
  }
}
