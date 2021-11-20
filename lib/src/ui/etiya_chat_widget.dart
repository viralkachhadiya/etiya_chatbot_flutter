import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swifty_chat/swifty_chat.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cubit/chatbot_cubit.dart';
import '../models/etiya_login_message_kind.dart';
import '../util/logger.dart';
import 'etiya_message_input.dart';
import 'image_viewer.dart';
import 'login_sheet.dart';

class EtiyaChatWidget extends StatefulWidget {
  const EtiyaChatWidget();

  @override
  _EtiyaChatWidgetState createState() => _EtiyaChatWidgetState();
}

class _EtiyaChatWidgetState extends State<EtiyaChatWidget> {
  late Chat _chatView;

  @override
  void dispose() {
    super.dispose();
    context.read<ChatbotCubit>().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatbotCubit, ChatbotState>(
      listener: (context, state) {
        if (state is MessagesUpdated) {
          _chatView.scrollToBottom();
        }
      },
      builder: (context, state) {
        _chatView = Chat(
          messages: state.messages,
          customMessageWidget: _customWidget,
          theme: context.read<ChatTheme>(),
          messageCellSizeConfigurator:
              MessageCellSizeConfigurator.defaultConfiguration,
          chatMessageInputField: EtiyaMessageInput(
            sendButtonTapped: _sendButtonPressedAction,
            hintText: context.read<ChatbotCubit>().messageInputHintText,
          ),
        )
            .setOnMessagePressed(_messagePressedAction)
            .setOnCarouselItemButtonPressed(_carouselPressedAction)
            .setOnQuickReplyItemPressed(_quickReplyPressedAction);
        return _chatView;
      },
    );
  }
}

extension ChatInteractions on _EtiyaChatWidgetState {
  void _sendButtonPressedAction(String text) {
    context.read<ChatbotCubit>().userAddedMessage(text);
  }

  void _messagePressedAction(Message message) {
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

  Future<void> _carouselPressedAction(CarouselButtonItem item) async {
    Log.info(item.toString());
    if (item.url != null) {
      if (await canLaunch("")) {
        // TODO: Check if this works for VPN things
        // You may need to make sure device's browser is opened.
        await launch(item.url!);
      }
    } else if (item.payload != null) {
      context.read<ChatbotCubit>().userAddedCarouselMessage(item);
    }
  }

  void _quickReplyPressedAction(QuickReplyItem item) {
    context.read<ChatbotCubit>().userAddedQuickReplyMessage(item);
  }
}

extension CustomMessageWidget on _EtiyaChatWidgetState {
  Widget _customWidget(Message message) {
    if (message.messageKind.custom is EtiyaLoginMessageKind) {
      return _loginButton(message);
    }
    return Container();
  }

  Widget _loginButton(Message message) {
    return LoginButton(
      buttonText: (message.messageKind.custom as EtiyaLoginMessageKind).title,
      onPressed: () async {
        final formData = await showModalBottomSheet(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.7,
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          context: context,
          builder: (_) => const LoginSheet(),
        );
        debugPrint("FormData $formData");
        if (formData == null) {
          return;
        }
        final String email = formData["email"] as String;
        final String password = formData["password"] as String;

        // if (!mounted) return;
        context.read<ChatbotCubit>().authenticate(
              username: email,
              password: password,
            );
      },
    );
  }
}
