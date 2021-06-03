import 'package:flutter_chat/models/message.dart';
import 'package:flutter_chat/models/message_kind.dart';

import '../models/etiya_chat_user.dart';
import '../models/api/etiya_message_response.dart';
import '../models/etiya_quick_reply.dart';

class EtiyaChatMessage extends Message {
  final EtiyaChatUser chatUser;
  final String id;
  final bool isMe;
  final MessageKind messageKind;

  const EtiyaChatMessage({
    required this.chatUser,
    required this.id,
    required this.isMe,
    required this.messageKind
  }) : super(user: chatUser, id: id, isMe: isMe, messageKind: messageKind);
}

extension MessageMapper on MessageResponse {
  List<EtiyaChatMessage> mapToChatMessage() {
    List<EtiyaChatMessage> messages = [];
    var msgId = id ?? DateTime.now().toString();
    EtiyaChatUser msgUser = user ?? EtiyaChatUser();
    switch (type) {
      case 'text':
        if (hasQuickReply) {
          var quickReplies = rawMessage?.data?.payload?.quickReplies ?? [];
          List<EtiyaQuickReplyItem> items = quickReplies.map((qr) =>
              EtiyaQuickReplyItem(title: qr.title ?? "",
                  payload: qr.payload ?? "unknown_payload")
          ).toList();
          if (text != null) {
            messages.add(
                EtiyaChatMessage(
                    id: msgId,
                    isMe: false,
                    chatUser: msgUser, messageKind: MessageKind.text(text!))
            );
          }
          messages.add(EtiyaChatMessage(
              id: msgId,
              isMe: false,
              chatUser: msgUser, messageKind: MessageKind.quickReply(items)));
        } else {
          if (text != null) {
            messages.add(EtiyaChatMessage(
                id: msgId,
                isMe: false,
                chatUser: msgUser, messageKind: MessageKind.text(text!)));
          }
        }
        break;
    // MARK: - Carousel
    // case 'carousel':
    // guard let items = rawMessage?.data?.payload?.elements else { break }
    // let carouselItems: [CarouselItem] = items.compactMap {
    // guard let title = $0.title,
    // let subtitle = $0.subtitle,
    // let url = $0.picture,
    // let buttons = $0.buttons else { return nil }
    //
    // let carouselButtons: [CarouselItemButton] = buttons.compactMap { btn in
    // let url = URL(string: btn.url ?? "")
    // return CarouselItemButton(title: btn.title ?? "", url: url)
    // }
    //
    // return EtiyaCarouselItem(
    // title: title,
    // subtitle: subtitle,
    // imageURL: URL(string: url),
    // buttons: carouselButtons
    // )
    // }
    // messages.append(
    // EtiyaChatMessage(user: user, messageKind: .carousel(carouselItems))
    // )

      case 'file':
        if (hasImage) {
          // String url = rawMessage?.data?.payload?.url;
          // Uri? imageURL = Uri(path: url);
          //
          // messages.add(
          //     EtiyaChatMessage(
          //         id: msgId,
          //         isMe: false,
          //         chatUser: msgUser, messageKind: MessageKind.image(imageURL))
          // );
        }
        break;
    }
    return messages;
  }
}