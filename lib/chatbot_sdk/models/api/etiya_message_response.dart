// To parse this JSON data, do
//
//     final messageResponse = messageResponseFromJson(jsonString);

import 'dart:convert';

// MessageResponse messageResponseFromJson(String str) => MessageResponse.fromJson(json.decode(str));

// String messageResponseToJson(MessageResponse data) => json.encode(data.toJson());

class MessageResponse {
  MessageResponse({
    this.id,
    this.sessionId,
    this.type,
    this.text,
    this.rawMessage,
    this.direction,
    this.ts,
    this.userId,
    this.user,
  });

  String? id;
  String? sessionId;
  String? type;
  String? text;
  RawMessage? rawMessage;
  String? direction;
  DateTime? ts;
  String? userId;
  User? user;

  factory MessageResponse.fromJson(Map<String, dynamic> json) => MessageResponse(
    id: json["id"] == null ? null : json["id"],
    sessionId: json["sessionId"] == null ? null : json["sessionId"],
    type: json["type"] == null ? null : json["type"],
    text: json["text"] == null ? null : json["text"],
    rawMessage: json["rawMessage"] == null ? null : RawMessage.fromJson(json["rawMessage"]),
    direction: json["direction"] == null ? null : json["direction"],
    ts: json["ts"] == null ? null : DateTime.parse(json["ts"]),
    userId: json["userId"] == null ? null : json["userId"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sessionId": sessionId,
    "type": type,
    "text": text,
    "rawMessage": rawMessage?.toJson(),
    "direction": direction,
    "ts": ts?.toIso8601String(),
    "userId": userId,
    "user": user?.toJson(),
  };
}

class RawMessage {
  RawMessage({
    this.to,
    this.data,
    this.type,
    this.channel,
    this.carrier,
  });

  String? to;
  Data? data;
  String? type;
  String? channel;
  String? carrier;

  factory RawMessage.fromJson(Map<String, dynamic> json) => RawMessage(
    to: json["to"] == null ? null : json["to"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    type: json["type"] == null ? null : json["type"],
    channel: json["channel"] == null ? null : json["channel"],
    carrier: json["__carrier"] == null ? null : json["__carrier"],
  );

  Map<String, dynamic> toJson() => {
    "to": to,
    "data": data?.toJson(),
    "type": type,
    "channel": channel,
    "__carrier": carrier,
  };
}

class Data {
  Data({
    this.text,
    this.payload,
  });

  String? text;
  Payload? payload;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    text: json["text"] == null ? null : json["text"],
    payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "payload": payload?.toJson(),
  };
}

class Payload {
  Payload({
    this.typing,
    this.markdown,
    this.conversationId,
  });

  int? typing;
  bool? markdown;
  String? conversationId;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    typing: json["typing"] == null ? null : json["typing"],
    markdown: json["markdown"] == null ? null : json["markdown"],
    conversationId: json["conversationId"] == null ? null : json["conversationId"],
  );

  Map<String, dynamic> toJson() => {
    "typing": typing,
    "markdown": markdown,
    "conversationId": conversationId,
  };
}

class User {
  User({
    this.fullName,
    this.isOnline,
    this.id,
    this.userId,
    this.platform,
    this.gender,
    this.pictureUrl,
    this.firstName,
    this.lastName,
    this.locale,
    this.createdOn,
    this.userType,
    this.platformId,
  });

  String? fullName;
  bool? isOnline;
  String? id;
  String? userId;
  String? platform;
  String? gender;
  String? pictureUrl;
  String? firstName;
  String? lastName;
  String? locale;
  DateTime? createdOn;
  String? userType;
  String? platformId;

  factory User.fromJson(Map<String, dynamic> json) => User(
    fullName: json["fullName"] == null ? null : json["fullName"],
    isOnline: json["isOnline"] == null ? null : json["isOnline"],
    id: json["id"] == null ? null : json["id"],
    userId: json["userId"] == null ? null : json["userId"],
    platform: json["platform"] == null ? null : json["platform"],
    gender: json["gender"] == null ? null : json["gender"],
    pictureUrl: json["pictureUrl"] == null ? null : json["pictureUrl"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    locale: json["locale"] == null ? null : json["locale"],
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
    userType: json["userType"] == null ? null : json["userType"],
    platformId: json["platformId"] == null ? null : json["platformId"],
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName == null ? null : fullName,
    "isOnline": isOnline == null ? null : isOnline,
    "id": id == null ? null : id,
    "userId": userId == null ? null : userId,
    "platform": platform == null ? null : platform,
    "gender": gender == null ? null : gender,
    "pictureUrl": pictureUrl == null ? null : pictureUrl,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "locale": locale == null ? null : locale,
    "createdOn": createdOn?.toIso8601String(),
    "userType": userType == null ? null : userType,
    "platformId": platformId == null ? null : platformId,
  };
}
