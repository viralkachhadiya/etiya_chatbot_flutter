import 'package:flutter_chat/models/message.dart';
import 'package:flutter_chat/models/message_kind.dart';

class EtiyaChatMessage extends Message {
  final String? id;
  final bool isMe;
  final MessageKind messageKind;

  const EtiyaChatMessage({
    required this.id,
    required this.isMe,
    required this.messageKind
  }): super(id: id, isMe: isMe, messageKind: messageKind);
}