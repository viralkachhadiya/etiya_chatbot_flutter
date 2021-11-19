import 'package:etiya_chatbot_flutter/src/models/api/etiya_message_response.dart';

abstract class SocketRepository {
  final String userId;
  final String socketUrl;

  SocketRepository({
    required this.userId,
    required this.socketUrl,
  });

  dynamic socket;

  /// Triggered when socket connection establishes
  Function()? onSocketConnected;

  /// Triggered when socket connection fails
  Function(dynamic handler)? onSocketConnectionFailed;

  Function(MessageResponse messageResponse)? onNewMessageReceived;

  void initializeSocket();

  void dispose();
}
