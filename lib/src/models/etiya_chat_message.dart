import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:etiya_chatbot_flutter/src/models/etiya_login_message_kind.dart';
import 'package:flutter/material.dart';
import 'package:swifty_chat/swifty_chat.dart';

import '../extensions/string_extensions.dart';
import '../models/api/etiya_message_response.dart';
import '../models/etiya_carousel_item.dart';
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
    required this.messageKind,
  }) : super(
          user: chatUser,
          id: id,
          isMe: isMe,
          messageKind: messageKind,
        );
}

extension MessageMapper on MessageResponse {
  List<EtiyaChatMessage> mapToChatMessage() {
    final List<EtiyaChatMessage> messages = [];
    final msgId = id ?? DateTime.now().toString();
    final EtiyaChatUser msgUser = user ?? EtiyaChatUser();
    switch (type) {
      case 'login':
        messages.add(
          EtiyaChatMessage(
            id: msgId,
            isMe: false,
            chatUser: msgUser,
            messageKind: MessageKind.custom(
              EtiyaLoginMessageKind(title: text ?? 'Login'),
            ),
          ),
        );
        break;
      case 'text':
        if (hasQuickReply) {
          final quickReplies = rawMessage?.data?.payload?.quickReplies ?? [];
          final List<EtiyaQuickReplyItem> items = quickReplies
              .map(
                (qr) => EtiyaQuickReplyItem(
                  title: qr.title ?? "",
                  payload: qr.payload ?? "unknown_payload",
                ),
              )
              .toList();
          if (text != null) {
            MessageKind kind = MessageKind.text(text!);
            if (text!.containsHTML) {
              kind = MessageKind.html(text!);
            }
            messages.add(
              EtiyaChatMessage(
                id: msgId,
                isMe: false,
                chatUser: msgUser,
                messageKind: kind,
              ),
            );
          }
          messages.add(
            EtiyaChatMessage(
              id: msgId,
              isMe: false,
              chatUser: msgUser,
              messageKind: MessageKind.quickReply(items),
            ),
          );
        } else {
          if (text != null) {
            MessageKind kind = MessageKind.text(text!);
            if (text!.containsHTML) {
              kind = MessageKind.html(text!);
            }
            messages.add(
              EtiyaChatMessage(
                id: msgId,
                isMe: false,
                chatUser: msgUser,
                messageKind: kind,
              ),
            );
          }
        }
        break;
      case 'carousel':
        final items = rawMessage?.data?.payload?.elements ?? [];
        if (items.isEmpty) {
          break;
        }

        final List<EtiyaCarouselItem> _carouselItems = items.map((e) {
          final title = e.title ?? '';
          final subtitle = e.subtitle ?? '';
          final url = e.picture;
          final buttons = e.buttons ?? [];

          final List<CarouselButtonItem> carouselButtons = buttons.map((btn) {
            return CarouselButtonItem(
              title: btn.title ?? '',
              url: btn.url,
              payload: btn.payload,
            );
          }).toList();

          return EtiyaCarouselItem(
            title: title,
            subtitle: subtitle,
            imageProvider: NetworkImage(url ?? ""),
            buttons: carouselButtons,
          );
        }).toList();

        messages.add(
          EtiyaChatMessage(
            chatUser: msgUser,
            id: msgId,
            isMe: false,
            messageKind: MessageKind.carousel(_carouselItems),
          ),
        );
        break;

      case 'file':
        if (hasImage) {
          String? url = rawMessage?.data?.payload?.url;
          if (url == null) break;
          messages.add(
            EtiyaChatMessage(
              id: msgId,
              isMe: false,
              chatUser: msgUser,
              messageKind: MessageKind.imageProvider(
                NetworkImage(url),
              ),
            ),
          );
        }
        break;
    }

    return messages.reversed.toList();
  }
}
