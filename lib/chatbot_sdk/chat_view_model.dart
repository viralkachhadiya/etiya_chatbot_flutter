import 'dart:convert';
import 'dart:io' show Platform;
import 'package:etiya_chatbot_flutter/chatbot_sdk/models/api/etiya_message_response.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:etiya_chatbot_flutter/chatbot_sdk/etiya_chatbot.dart';
import 'package:device_info/device_info.dart';
import 'models/etiya_chat_message.dart';

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
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    } else {
      return '';
    }
  }

  _initializeSocket() async {
    deviceId = await _getId();
    print('socket initializing...');
    // Socket.io

    IO.Socket socket = IO.io(builder.socketUrl,
        IO.OptionBuilder()
        .disableAutoConnect()
        .enableForceNew()
        .setQuery({'visitorId': userId})
        // .setExtraHeaders({'visitorId': userId})
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
    socket.onConnect((_) => print('socket connected'));
    socket.onError((error) => print(error));
    socket.connect();
  }

  /// Send Message to Server
  /// - Parameter message: `MessageRequest` wraps the actual message (text or data)
  // sendMessage(MessageRequest request) {
  // print(userId);
  // var _message = message;
  // let urlString = self.builder.serviceUrl.appending("/mobile")
  // guard let url = URL(string: urlString) else { return }
  // var request = URLRequest(url: url)
  // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  // request.httpMethod = "POST"
  // var user =  MessageUser(senderId: "", displayName: "")
  // user.userId = userId
  // _message.user = user
  //
  // request.httpBody =// body.data(using: .utf8)
  // try? JSONEncoder().encode(_message)
  //
  // URLSession.shared.dataTaskPublisher(for: request)
  //     .tryMap { data, response -> Data in
  // guard let httpResponse = response as? HTTPURLResponse,
  // 200..<300 ~= httpResponse.statusCode else {
  // throw EtiyaNetworkError.messageCouldNotSend
  // }
  // return data
  // }
  //     .sink { (completion) in
  // switch completion {
  // case .failure(let error): print("Sending message failed: \(error.localizedDescription)")
  // case .finished: print("Send message succeeded")
  // }
  // } receiveValue: { (_) in
  //
  // }
  //     .store(in: &cancellable)
  //
  // }

  String get userId {
    final uid = builder.userName ?? 'chatbot_client';
    print('$uid$deviceId');
    return '$uid$deviceId';
  }
}