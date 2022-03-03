import 'package:etiya_chatbot_data/src/models/models.dart';

class MessageUser {
  MessageUser({
    required this.senderId,
    this.firstName,
    this.lastName,
  });

  /// Togg Id
  final String senderId;
  final String? firstName;
  final String? lastName;

  Map<String, dynamic> toJson() => {
        "userId": senderId,
        "first_name": firstName,
        "last_name": lastName,
      };
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
