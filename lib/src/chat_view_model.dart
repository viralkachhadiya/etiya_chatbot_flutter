import 'dart:convert';

import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../src/etiya_chatbot.dart';
import '../src/models/api/etiya_message_request.dart';
import '../src/models/api/etiya_message_response.dart';
import '../src/models/etiya_chat_message.dart';
import '../src/models/etiya_login_message_kind.dart';
import '../src/util/constants.dart';
import '../src/util/logger.dart';

enum ChatEvents { newMessage }

class ChatViewModel {
  final EtiyaChatbotBuilder builder;
  String _deviceId = '';
  late IO.Socket _socket;

  /// Current LDAP Auth status.
  void Function(bool)? isAuthenticated;

  /// A callback thats triggered when the new message is received.
  void Function(List<EtiyaChatMessage>)? onNewMessage;

  ChatViewModel({required this.builder}) {
    _initializeSocket();
  }

  ChatTheme get chatTheme => builder.chatTheme;

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

    Log.info("DeviceID fetched: $_deviceId");
    Log.info('Socket initializing...');

    _socket = IO.io(
      builder.socketUrl,
      IO.OptionBuilder()
          .enableForceNew()
          .setQuery({'visitorId': userId})
          .setTransports(['websocket']) // for Flutter or Dart VM
          .setPath('/ws')
          .build(),
    );
    _socket.nsp = '/chat';
    _socket.on('newMessage', (json) {
      Log.info('newMessage event received');
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      // final String prettyPrint = encoder.convert(json["rawMessage"]);
      // logger.info(prettyPrint);
      final messageResponse = MessageResponse.fromJson(json as Map<String, dynamic>);
      chatBotUser = messageResponse.user ?? EtiyaChatUser(firstName: 'Chatbot');
      messageResponse.user?.fullName = builder.userName;
      messageResponse.user?.avatar = builder.incomingAvatar;
      onNewMessage?.call(messageResponse.mapToChatMessage());
    });
    _socket.onConnect((_) {
      Log.info('Socket connection is successful');
      sendMessage(
        MessageRequest(
          text: "/user_visit",
          user: MessageUser(senderId: userId),
        ),
      );
      onNewMessage?.call([
        EtiyaChatMessage(
          chatUser: customerUser,
          id: DateTime.now().toString(),
          isMe: false,
          messageKind: MessageKind.custom(
            EtiyaLoginMessageKind(title: 'Login'),
          ),
        )
      ]);
    });
    _socket.onError((error) => Log.error(error as String? ?? "socket gotError"));
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
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        Log.info("User's message sent successfully");
      } else {
        Log.error(
          "User's message could not sent, statusCode: ${response.statusCode}",
        );
      }
    }).onError((error, stackTrace) {
      Log.error(error.toString());
    });
  }

  String get userId {
    final uid = builder.userName ?? 'chatbot_client';
    Log.info('userId: $uid$_deviceId that is used to communicate with socket');
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

extension LdapAuth on ChatViewModel {
  /// LDAP Auth
  /// - Parameter username: User Name
  /// - Parameter password: User Password
  void auth(String username, String password) {
    if (builder.authUrl == null) {
      Log.error("Set auth url first!");
    }
    final url = Uri.parse(builder.authUrl!);
    http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "username": username,
        "password": password,
        "chatId": "mobile:$userId"
      }),
    ).then((response) {
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        Log.info(response.body);
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final isAuth = json["isAuth"] as bool? ?? false;
        Log.info("isAuthenticated: $isAuth");
        onNewMessage?.call([
          authStatusMessage(isAuth)
        ]);
        isAuthenticated?.call(isAuth);
      } else {
        onNewMessage?.call([
          authStatusMessage(false)
        ]);
        Log.error(
          "User's message could not sent, statusCode: ${response.statusCode}",
        );
      }
    }).onError((error, stackTrace) {
      onNewMessage?.call([
        authStatusMessage(false)
      ]);
      Log.error(error.toString());
    });
  }

  EtiyaChatMessage authStatusMessage(bool status) => EtiyaChatMessage(
    chatUser: chatBotUser,
    id: DateTime.now().toString(),
    isMe: false,
    messageKind: MessageKind.text("Giriş ${status ? "Başarılı" : "Başarısız"}"),
  );
}