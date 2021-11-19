import 'package:etiya_chatbot_flutter/src/models/api/etiya_message_response.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'socket_repository.dart';

class SocketRepositoryImpl extends SocketRepository {
  SocketRepositoryImpl({
    required String userId,
    required String socketUrl,
  }) : super(userId: userId, socketUrl: socketUrl);

  @override
  void initializeSocket() {
    socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
          .enableForceNew()
          .setQuery({'visitorId': userId})
          .setTransports(['websocket']) // for Flutter or Dart VM
          .setPath('/ws')
          .build(),
    );
    (socket as IO.Socket)
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
