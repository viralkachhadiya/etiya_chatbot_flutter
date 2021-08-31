import 'package:flutter/material.dart';
import 'package:flutter_chat/flutter_chat.dart';

import 'chat_view_model.dart';
import 'models/api/etiya_message_request.dart';
import 'models/api/etiya_message_response.dart';
import 'models/etiya_chat_message.dart';

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
        _messages.insertAll(0, messages);
      });
    };
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chat(
      messages: _messages,
      theme: ThemeData.dark(),
      messageCellSizeConfigurator:
      MessageCellSizeConfigurator.defaultConfiguration,
      chatMessageInputField: MessageInputField(
        sendButtonTapped: sendButtonPressedAction,
      ),
    )
    .setOnQuickReplyItemPressed(quickReplyPressedAction);
  }

  void sendButtonPressedAction(String text) {
    widget.viewModel.sendMessage(
      MessageRequest(
        text: text,
        user: MessageUser(senderId: widget.viewModel.userId),
        type: "text",
      ),
    );
    setState(() {
      _messages.insert(0, EtiyaChatMessage(
          isMe: true,
          id: DateTime.now().toString(),
          messageKind: MessageKind.text(text),
          chatUser: widget.viewModel.customerUser));
    });
    print(text);
  }

  void quickReplyPressedAction(QuickReplyItem item) {
    widget.viewModel.sendMessage(
      MessageRequest(
        text: item.payload ?? "payload",
        user: MessageUser(senderId: widget.viewModel.userId),
        type: "quick_reply",
        data: QuickReply(
          title: item.title,
          payload: item.payload ?? "payload",
        ),
      ),
    );
    setState(() {
      _messages.insert(0, EtiyaChatMessage(
          isMe: true,
          id: DateTime.now().toString(),
          messageKind: MessageKind.text(item.title),
          chatUser: widget.viewModel.customerUser));
    });
    print(item.payload);
  }
}
