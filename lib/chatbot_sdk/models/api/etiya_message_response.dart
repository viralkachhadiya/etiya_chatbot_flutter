// To parse this JSON data, do
//
//     final messageResponse = messageResponseFromJson(jsonString);

import 'package:flutter_chat/models/chat_user.dart';
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
    // this.session,
    this.ts,
    this.userId,
    this.user,
  });

  String? id;
  String? sessionId;
  String? type;
  String? text;
  RawMessage? rawMessage;

  // Session? session;
  String? direction;
  DateTime? ts;
  String? userId;
  EtiyaChatUser? user;

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      MessageResponse(
        id: json["id"],
        sessionId: json["sessionId"],
        // session: json["session"] == null ? null : Session.fromJson(json["session"]),
        type: json["type"],
        text: json["text"],
        rawMessage: json["rawMessage"] == null ? null : RawMessage.fromJson(
            json["rawMessage"]),
        direction: json["direction"],
        ts: json["ts"] == null ? null : DateTime.parse(json["ts"]),
        userId: json["userId"],
        user: json["user"] == null ? null : EtiyaChatUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() =>
      {
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

  bool get hasQuickReply {
    var qrCount = rawMessage?.data?.payload?.quickReplies?.length ?? 0;
    return type == 'text' && qrCount != 0;
  }

  bool get hasImage {
    // final mimeType = rawMessage?.data?.payload?.mime;
    return type == 'file'; // && mimeType.contains("image")
  }
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

  factory RawMessage.fromJson(Map<String, dynamic> json) =>
      RawMessage(
        to: json["to"] == null ? null : json["to"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        type: json["type"] == null ? null : json["type"],
        channel: json["channel"] == null ? null : json["channel"],
        carrier: json["__carrier"] == null ? null : json["__carrier"],
      );

  Map<String, dynamic> toJson() =>
      {
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
    this.extras,
    this.payload,
  });

  String? text;
  Extras? extras;
  Payload? payload;

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(
        text: json["text"],
        extras: json["extras"] == null ? null : Extras.fromJson(json["extras"]),
        payload: json["payload"] == null ? null : Payload.fromJson(json["payload"])
      );

  Map<String, dynamic> toJson() =>
      {
        "text": text,
        "extras": extras?.toJson(),
        "payload": payload?.toJson(),
      };
}

class Extras {
  Extras({
    this.language,
    this.sourceID,
    this.threadID,
    this.categoryIDS,
    this.inReplyToID,
    this.firstInThread,
    this.inReplyToAuthorID
  });

  String? language;
  String? sourceID;
  String? threadID;
  List<String>? categoryIDS;
  String? inReplyToID;
  bool? firstInThread;
  String? inReplyToAuthorID;

  factory Extras.fromJson(Map<String, dynamic> json) =>
      Extras(
          language: json["language"],
          sourceID: json["source_id"],
          threadID: json["thread_id"],
          categoryIDS: json["category_ids"],
          inReplyToID: json["in_reply_to_id"],
          firstInThread: json["first_in_thread"],
          inReplyToAuthorID: json["in_reply_to_author_id"]
      );

  Map<String, dynamic> toJson() =>
      {
        "language": language,
        "source_id": sourceID,
        "thread_id": threadID,
        "category_ids": categoryIDS,
        "in_reply_to_id": inReplyToID,
        "first_in_thread": firstInThread,
        "in_reply_to_author_id": inReplyToAuthorID
      };
}

// MARK: - Element 👍🏻
class Element {
  Element({this.title, this.buttons, this.picture, this.subtitle});

  String? title;
  List<CarouselButton>? buttons;
  String? picture;
  String? subtitle;

  factory Element.fromJson(Map<String, dynamic> json) =>
      Element(
          title: json["title"],
          buttons: json["buttons"],
          picture: json["picture"],
          subtitle: json["subtitle"]
      );

  Map<String, dynamic> toJson() =>
      {
        "title": title,
        "buttons": buttons,
        "picture": picture,
        "subtitle": subtitle,
      };
}

// MARK: - CarouselButton 👍🏻
class CarouselButton {
  CarouselButton({this.url, this.title});

  String? url;
  String? title;

  factory CarouselButton.fromJson(Map<String, dynamic> json) =>
      CarouselButton(
          url: json["url"],
          title: json["title"]
      );

  Map<String, dynamic> toJson() =>
      {
        "url": url,
        "title": title
      };
}

// MARK: - QuickReply 👍🏻
class QuickReply {
  QuickReply({this.title, this.payload});

  String? title;
  String? payload;

  factory QuickReply.fromJson(Map<String, dynamic> json) =>
      QuickReply(
          title: json["title"],
          payload: json["payload"]
      );

  Map<String, dynamic> toJson() =>
      {
        "title": title,
        "payload": payload
      };
}

class Payload {
  Payload({
    this.typing,
    this.markdown,
    this.conversationId,
    this.quickReplies,
    this.elements,
    this.mime,
    this.url
  });

  int? typing;
  bool? markdown;
  String? conversationId;
  List<QuickReply>? quickReplies;
  List<Element>? elements;
  String? mime;
  String? url;

  factory Payload.fromJson(Map<String, dynamic> json) =>
      Payload(
          typing: json["typing"],
          markdown: json["markdown"],
          conversationId: json["conversationId"],
          quickReplies:  json["quick_replies"] == null ? null : List<QuickReply>.from(json["quick_replies"].map((x) => QuickReply.fromJson(x))),
          elements: json["elements"],
          mime: json["mime"],
          url: json["url"]
      );

  Map<String, dynamic> toJson() =>
      {
        "typing": typing,
        "markdown": markdown,
        "conversationId": conversationId,
        "quick_replies": quickReplies,
        "elements": elements,
        "mime": mime,
        "url": url
      };
}

class EtiyaChatUser extends ChatUser {

  EtiyaChatUser({
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
  }): super(userName: fullName ?? "", avatarURL: null);

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

  String get userName {
    return fullName ?? 'userName';
  }

  Uri? get avatarURL {
    return null;
  }

  factory EtiyaChatUser.fromJson(Map<String, dynamic> json) =>
      EtiyaChatUser(
        fullName: json["fullName"],
        isOnline: json["isOnline"],
        id: json["id"],
        userId: json["userId"],
        platform: json["platform"],
        gender: json["gender"],
        pictureUrl: json["pictureUrl"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        locale: json["locale"],
        createdOn: json["createdOn"] == null ? null : DateTime.parse(
            json["createdOn"]),
        userType: json["userType"],
        platformId: json["platformId"],
      );

  Map<String, dynamic> toJson() =>
      {
        "fullName": fullName,
        "isOnline": isOnline,
        "id": id,
        "userId": userId,
        "platform": platform,
        "gender": gender,
        "pictureUrl": pictureUrl,
        "firstName": firstName,
        "lastName": lastName,
        "locale": locale,
        "createdOn": createdOn?.toIso8601String(),
        "userType": userType,
        "platformId": platformId,
      };
}