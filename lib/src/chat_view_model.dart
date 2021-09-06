import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../src/etiya_chatbot.dart';
import '../src/models/api/etiya_message_request.dart';
import '../src/models/api/etiya_message_response.dart';
import '../src/models/etiya_chat_message.dart';
import '../src/util/constants.dart';

enum ChatEvents {
  newMessage
}

class ChatViewModel {
  final EtiyaChatbotBuilder builder;
  String _deviceId = '';
  late IO.Socket _socket;

  void Function(List<EtiyaChatMessage>)? onNewMessage;

  ChatViewModel({required this.builder}) {
    _initializeSocket();
  }

  void dispose() {
    _socket.clearListeners();
    _socket.close();
  }

  Future<String> _getDeviceID() async {
    final sp = await SharedPreferences.getInstance();
    return Future(() => sp.getString(Constants.deviceIDKey) ?? 'unset id');
  }

  void _initializeSocket() async {
    _deviceId = await _getDeviceID();

    logger.info("DeviceID fetched: $_deviceId");
    logger.info('Socket initializing...');

    _socket = IO.io(builder.socketUrl,
        IO.OptionBuilder()
            .enableForceNew()
            .setQuery({'visitorId': userId})
            .setTransports(['websocket']) // for Flutter or Dart VM
            .setPath('/ws')
            .build()
    );
    _socket.nsp = '/chat';
    _socket.on('newMessage', (json) {
      logger.info('newMessage event received');
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      final String prettyPrint = encoder.convert(json["rawMessage"]);
      // logger.info(prettyPrint);
      final messageResponse = MessageResponse.fromJson(json);
      messageResponse.user?.fullName = builder.userName;
      messageResponse.user?.avatar = builder.incomingAvatar;
      onNewMessage?.call(messageResponse.mapToChatMessage());
    });
    _socket.onConnect((_) {
      logger.info('Socket connection is successful');
      sendMessage(
          MessageRequest(
              text: "/user_visit",
              user: MessageUser(senderId: userId)
          )
      );
    });
    _socket.onError((error) => logger.severe(error));
    _socket.connect();
  }

  /// Send Message to Server
  /// - Parameter message: `MessageRequest` wraps the actual message (text or data)
  void sendMessage(MessageRequest request) {
    http.post(
      Uri.parse('${builder.serviceUrl}/mobile'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    ).then((response) {
      if (response.statusCode > 200 && response.statusCode < 300) {
        logger.info("User's message sent successfully");
      } else {
        logger.severe("User's message could not sent, statusCode: ${response.statusCode}");
      }
    }).onError((error, stackTrace) {
      logger.severe(error);
    });
  }

  String get userId {
    final uid = builder.userName ?? 'chatbot_client';
    logger.info('userId: $uid$_deviceId that is used to communicate with socket');
    return '$uid$_deviceId';
  }

  /// Chatbot User
  late EtiyaChatUser chatBotUser;

  /// Customer User
  EtiyaChatUser get customerUser {
    final user = EtiyaChatUser(fullName: builder.userName);
    user.avatar = builder.outgoingAvatar;
    return user;
  }
}