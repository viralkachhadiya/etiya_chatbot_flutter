import 'package:etiya_chatbot_flutter/chatbot_sdk/models/etiya_chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/chat.dart';
import 'package:flutter_chat/models/message_kind.dart';
import 'chat_view_model.dart';

class EtiyaChatWidget extends StatefulWidget {
  final ChatViewModel viewModel;

  EtiyaChatWidget({required this.viewModel});

  @override
  _EtiyaChatWidgetState createState() => _EtiyaChatWidgetState();
}

class _EtiyaChatWidgetState extends State<EtiyaChatWidget> {
  List<EtiyaChatMessage> _messages = [
    EtiyaChatMessage(
        id: DateTime.now().toString(),
        messageKind: MessageKind.text('Ta dah!'),
        isMe: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Chat(
      items: _messages,
    );
  }
}
