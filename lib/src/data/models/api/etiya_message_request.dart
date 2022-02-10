import 'package:etiya_chatbot_flutter/src/data/models/models.dart';

class MessageUser {
  MessageUser({required this.senderId});

  final String senderId;

  Map<String, dynamic> toJson() => {"userId": senderId};
}

class MessageRequest {
  MessageRequest({
    this.type = "text",
    required this.text,
    required this.user,
    this.data,
  });

  final String type;
  final String text;
  final MessageUser user;
  final QuickReply? data;

  Map<String, dynamic> toJson() => {
        "type": type,
        "text": text,
        "user": user.toJson(),
        "data": data?.toJson(),
      };
}
