import 'package:etiya_chatbot_flutter/src/image_viewer.dart';
import 'package:etiya_chatbot_flutter/src/login_sheet.dart';
import 'package:etiya_chatbot_flutter/src/models/etiya_login_message_kind.dart';
import 'package:flutter/material.dart';
import 'package:swifty_chat/swifty_chat.dart';
import 'package:url_launcher/url_launcher.dart';

import '../etiya_chatbot_flutter.dart';
import 'chat_view_model.dart';
import 'models/api/etiya_message_request.dart';
import 'models/api/etiya_message_response.dart';
import 'models/etiya_chat_message.dart';
import 'util/logger.dart';

class EtiyaChatWidget extends StatefulWidget {
  final ChatViewModel viewModel;

  const EtiyaChatWidget({required this.viewModel});

  @override
  _EtiyaChatWidgetState createState() => _EtiyaChatWidgetState();
}

class _EtiyaChatWidgetState extends State<EtiyaChatWidget> {
  final List<EtiyaChatMessage> _messages = [];
  late Chat _chatView;

  @override
  void initState() {
    widget.viewModel.onNewMessage = (messages) {
      setState(() {
        _messages.insertAll(0, messages);
      });
      _chatView.scrollToBottom();
    };
    widget.viewModel.isAuthenticated = (isAuthenticated) {
      Log.info("Auth status: $isAuthenticated");
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
    _chatView = Chat(
      messages: _messages,
      customMessageWidget: (message) => loginButton(context, message),
      theme: widget.viewModel.chatTheme,
      messageCellSizeConfigurator:
          MessageCellSizeConfigurator.defaultConfiguration,
      chatMessageInputField: MessageInputField(
        sendButtonTapped: sendButtonPressedAction,
      ),
    )
        .setOnMessagePressed((msg) => messagePressedAction(msg, context))
        .setOnCarouselItemButtonPressed(carouselPressedAction)
        .setOnQuickReplyItemPressed(quickReplyPressedAction);
    return _chatView;
  }
}

extension ChatInteractions on _EtiyaChatWidgetState {
  void sendButtonPressedAction(String text) {
    widget.viewModel.sendMessage(
      MessageRequest(
        text: text,
        user: MessageUser(senderId: widget.viewModel.userId),
        type: "text",
      ),
    );
    setState(() {
      _messages.insert(
        0,
        EtiyaChatMessage(
            isMe: true,
            id: DateTime.now().toString(),
            messageKind: MessageKind.text(text),
            chatUser: widget.viewModel.customerUser),
      );
    });
    Log.info(text);
    _chatView.scrollToBottom();
  }

  void messagePressedAction(Message message, BuildContext context) {
    final imageProvider = message.messageKind.imageProvider;
    if (imageProvider != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ImageViewer(
            imageProvider: imageProvider,
            closeAction: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    }
  }

  Future<void> carouselPressedAction(CarouselButtonItem item) async {
    Log.info(item.toString());
    if (item.url != null) {
      if (await canLaunch("")) {
        // TODO: Check if this works for VPN things
        // You may need to make sure device's browser is opened.
        await launch(item.url!);
      }
    } else if (item.payload != null) {
      widget.viewModel.sendMessage(
        MessageRequest(
          text: item.payload!,
          user: MessageUser(senderId: widget.viewModel.userId),
          type: "text",
        ),
      );
      setState(() {
        _messages.insert(
          0,
          EtiyaChatMessage(
            isMe: true,
            id: DateTime.now().toString(),
            messageKind: MessageKind.text(item.title),
            chatUser: widget.viewModel.customerUser,
          ),
        );
      });
      Log.info(item.payload);
      _chatView.scrollToBottom();
    }
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
      _messages.insert(
        0,
        EtiyaChatMessage(
          isMe: true,
          id: DateTime.now().toString(),
          messageKind: MessageKind.text(item.title),
          chatUser: widget.viewModel.customerUser,
        ),
      );
    });
    Log.info(item.payload);
    _chatView.scrollToBottom();
  }
}

extension CustomMessageWidget on _EtiyaChatWidgetState {
  Widget customWidget(BuildContext context, Message message) {
    if (message.messageKind.custom is EtiyaLoginMessageKind) {
      return loginButton(context, message);
    }
    return Container();
  }

  Widget loginButton(BuildContext context, Message message) {
    return LoginButton(
      buttonText: (message.messageKind.custom as EtiyaLoginMessageKind).title,
      onPressed: () async {
        final formData = await showModalBottomSheet(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.7,
            maxHeight: MediaQuery.of(context).size.height * 0.75
          ),
          isScrollControlled: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          context: context,
          builder: (_) => const LoginSheet(),
        );
        debugPrint("FormData $formData");
        if (formData == null) { return; }
        final String email = formData["email"] as String;
        final String password = formData["password"] as String;
        widget.viewModel.auth(email, password);
      },
    );
  }
}