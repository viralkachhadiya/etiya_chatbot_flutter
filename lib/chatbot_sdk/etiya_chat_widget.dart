import 'package:etiya_chatbot_flutter/chatbot_sdk/models/etiya_chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/chat.dart';
import 'package:flutter_chat/models/message_kind.dart';
import 'chat_view_model.dart';
import 'models/api/etiya_message_request.dart';
import 'models/api/etiya_message_response.dart';

class EtiyaChatWidget extends StatefulWidget {
  final ChatViewModel viewModel;

  EtiyaChatWidget({required this.viewModel});

  @override
  _EtiyaChatWidgetState createState() => _EtiyaChatWidgetState();
}

class _EtiyaChatWidgetState extends State<EtiyaChatWidget> {
  List<EtiyaChatMessage> _messages = [];

  @override
  void initState() {
    widget.viewModel.onNewMessage = (messages) {
      setState(() {
        _messages.addAll(messages);
      });
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Chat(
        items: _messages
    ).setOnQuickReplyItemPressed((item) {
      widget.viewModel.sendMessage(
        MessageRequest(
          text: item.payload ?? "payload",
          user: MessageUser(senderId: widget.viewModel.userId),
          type: "quick_reply",
          data: QuickReply(title: item.title ?? "title", payload: item.payload ?? "payload"),
        ),
      );
      setState(() {
        _messages.add(
            EtiyaChatMessage(
                isMe: true,
                id: DateTime.now().toString(),
                messageKind: MessageKind.text(item.title ?? "title"),
                chatUser: widget.viewModel.customerUser
            )
        );
      });
      print(item.payload);
    });
  }
}
