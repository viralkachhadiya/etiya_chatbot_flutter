import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:device_info/device_info.dart';

import '../src/etiya_chatbot.dart';
import '../src/models/api/etiya_message_response.dart';
import '../src/models/etiya_chat_message.dart';
import '../src/models/api/etiya_message_request.dart';

enum ChatEvents {
  newMessage
}

class ChatViewModel {
  final EtiyaChatbotBuilder builder;
  String deviceId = '';

  void Function(List<EtiyaChatMessage>)? onNewMessage;

  ChatViewModel({required this.builder}) {
    _initializeSocket();
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    } else {
      return '';
    }
  }

  _initializeSocket() async {
    deviceId = await _getId();
    print('socket initializing...');

    IO.Socket socket = IO.io(builder.socketUrl,
        IO.OptionBuilder()
            .disableAutoConnect()
            .enableForceNew()
            .setQuery({'visitorId': userId})
            .setTransports(['websocket']) // for Flutter or Dart VM
            .setPath('/ws')
            .build()
    );
    socket.nsp = '/chat';
    socket.on('newMessage', (json) {
      print('newMessage');
      JsonEncoder encoder = JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(json["rawMessage"]);
      print(prettyprint);
      onNewMessage?.call(MessageResponse.fromJson(json).mapToChatMessage());
    });
    socket.onConnect((_) {
      print('socket connected');
      sendMessage(
          MessageRequest(
              text: "/user_visit",
              user: MessageUser(senderId: userId)
          )
      );
    });
    socket.onError((error) => print(error));
    socket.connect();
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
    print('$uid$deviceId');
    return '$uid$deviceId';
  }

  /// Chatbot User
  EtiyaChatUser get chatBotUser {
    final user = EtiyaChatUser(fullName: builder.userName);
    // if let image = builder.avatarManager.botAvatarImage {
    //   user._avatar = image
    // }
    // if let imageURL = builder.avatarManager.botAvatarImageURL {
    //   user._avatarURL = imageURL
    // }
    return user;
  }

  /// Customer User
  EtiyaChatUser get customerUser {
    final user = EtiyaChatUser(fullName: builder.userName);
    // if let image = builder.avatarManager.userAvatarImage {
    //   user._avatar = image
    // }
    // if let imageURL = builder.avatarManager.userAvatarImageURL {
    //   user._avatarURL = imageURL
    // }
    return user;
  }
}