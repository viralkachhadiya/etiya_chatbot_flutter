import 'dart:convert';
import 'package:etiya_chatbot_flutter/src/util/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

import '../src/etiya_chatbot.dart';
import '../src/models/api/etiya_message_response.dart';
import '../src/models/etiya_chat_message.dart';
import '../src/models/api/etiya_message_request.dart';

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

  _initializeSocket() async {
    _deviceId = await _getDeviceID();
    debugPrint("deviceID: $_deviceId");
    debugPrint('socket initializing...');

    _socket = IO.io(builder.socketUrl,
        IO.OptionBuilder()
            // .disableAutoConnect()
            .enableForceNew()
            .setQuery({'visitorId': userId})
            .setTransports(['websocket']) // for Flutter or Dart VM
            .setPath('/ws')
            .build()
    );
    _socket.nsp = '/chat';
    _socket.on('newMessage', (json) {
      debugPrint('newMessage');
      JsonEncoder encoder = JsonEncoder.withIndent('  ');
      String prettyPrint = encoder.convert(json["rawMessage"]);
      debugPrint(prettyPrint);
      var messageResponse = MessageResponse.fromJson(json);
      messageResponse.user?.fullName = builder.userName;
      messageResponse.user?.avatar = builder.incomingAvatar;
      onNewMessage?.call(messageResponse.mapToChatMessage());
    });
    _socket.onConnect((_) {
      debugPrint('socket connected');
      sendMessage(
          MessageRequest(
              text: "/user_visit",
              user: MessageUser(senderId: userId)
          )
      );
    });
    _socket.onError((error) => print(error));
    _socket.connect();
  }

  /// Send Message to Server
  /// - Parameter message: `MessageRequest` wraps the actual message (text or data)
  sendMessage(MessageRequest request) {
    // print(userId);
    http.post(
      Uri.parse('${builder.serviceUrl}/mobile'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    ).then((response) {
      if (response.statusCode > 200 && response.statusCode < 300) {
        print("Send message succeeded");
      } else {
        print('Send message failed');
      }
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  String get userId {
    final uid = builder.userName ?? 'chatbot_client';
    debugPrint('$uid$_deviceId');
    return '$uid$_deviceId';
  }

  /// Chatbot User
  late EtiyaChatUser chatBotUser;

  /// Customer User
  EtiyaChatUser get customerUser {
    var user = EtiyaChatUser(fullName: builder.userName);
    user.avatar = builder.outgoingAvatar;
    return user;
  }
}