import 'dart:convert';
import 'dart:io';

import 'package:etiya_chatbot_flutter/src/data/models/models.dart';
import 'package:etiya_chatbot_flutter/src/domain/socket_repository.dart';

class FakeSocketRepository extends SocketRepository {
  FakeSocketRepository({
    required String userName,
    required String deviceId,
    required String socketUrl,
  }) : super(
    userName: userName,
    deviceId: deviceId,
    socketUrl: socketUrl,
  );

  @override
  void dispose() {}

  @override
  void initializeSocket() { }

  Future<void> simulateTextMessageReceiveEvent(String text) async {
    final textMessageResponseJson = File('test/mock/data/text_message_response.json');
    final MessageResponse messageResponse = MessageResponse.fromJson(
      jsonDecode(
        await textMessageResponseJson.readAsString(),
      ) as Map<String, dynamic>,
    );
    messageResponse.text = text;
    onNewMessageReceived?.call(messageResponse);
  }
}
