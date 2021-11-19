// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/api/etiya_message_response.dart';
import 'socket_repository.dart';

class SocketRepositoryImpl extends SocketRepository {
  SocketRepositoryImpl({
    required String userName,
    required String deviceId,
    required String socketUrl,
  }) : super(
          userName: userName,
          deviceId: deviceId,
          socketUrl: socketUrl,
        );

  @override
  void initializeSocket() {
    socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
          .enableForceNew()
          .setQuery({
            'visitorId': visitorId,
          })
          .setTransports(['websocket']) // for Flutter or Dart VM
          .setPath('/ws')
          .build(),
    )
    ..nsp = '/chat'
    ..on(
      'newMessage',
      (json) => onNewMessageReceived?.call(
        MessageResponse.fromJson(json as Map<String, dynamic>),
      ),
    )
    ..onConnect((data) => onSocketConnected?.call())
    ..onError((error) => onSocketConnectionFailed?.call(error))
    ..connect();
  }

  @override
  void dispose() {
    (socket as IO.Socket)
      ..close()
      ..clearListeners();
  }
}
