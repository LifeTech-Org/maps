import 'dart:convert';
import 'package:maps/utils/role.dart';
import 'package:web_socket_channel/io.dart';
import 'package:maps/interfaces/server.dart';
import 'package:http/http.dart' as http;

class ServerModel implements ServerRepository {
  @override
  Future<Map<String, String>> getPlace(
      double latitude, double longitude) async {
    try {
      final response = await http.get(Uri.parse(
          'https://maps-server-ndqjs3whnq-uc.a.run.app/place?latitude=$latitude&longitude=$longitude'));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is Map<String, dynamic>) {
          final resultMap = responseData.map<String, String>(
            (key, value) => MapEntry(key, value.toString()),
          );
          return resultMap;
        } else {
          return Future.error('Error 1');
        }
      } else {
        return Future.error('Error 2');
      }
    } catch (e) {
      return Future.error('Error 3');
    }
  }

  late IOWebSocketChannel _socket;

  @override
  IOWebSocketChannel get socket => _socket;

  @override
  IOWebSocketChannel connectToWebSocket(UserRole userRole) {
    String url = userRole == UserRole.driver
        ? 'ws://maps-server-ndqjs3whnq-uc.a.run.app/connect/driver'
        : 'ws://maps-server-ndqjs3whnq-uc.a.run.app/connect/passenger';
    _socket = IOWebSocketChannel.connect(Uri.parse(url));
    return _socket;
  }

  @override
  void disconnect() {
    _socket.sink.close();
  }
}
