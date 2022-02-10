import 'package:etiya_chatbot_flutter/src/cubit/chatbot_cubit.dart';
import 'package:etiya_chatbot_flutter/src/di/setup_locator.dart';
import 'package:etiya_chatbot_flutter/src/domain/http_client_repository.dart';
import 'package:etiya_chatbot_flutter/src/domain/socket_repository.dart';
import 'package:etiya_chatbot_flutter/src/ui/etiya_chat_widget.dart';
import 'package:etiya_chatbot_flutter/src/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swifty_chat/swifty_chat.dart';

class EtiyaChatbot {
  final EtiyaChatbotBuilder builder;

  const EtiyaChatbot({
    required this.builder,
  });

  Future<Widget> getChatWidget() async => MultiRepositoryProvider(
      providers: await DependencyInjection.build(builder),
      child: BlocProvider(
        create: (context) => ChatbotCubit(
          chatbotBuilder: builder,
          socketRepository: context.read<SocketClientRepository>(),
          httpClientRepository: context.read<HttpClientRepository>(),
        ),
        child: const EtiyaChatWidget(),
      ),
  );
}

class EtiyaChatbotBuilder {
  /// The connection URL for messages to be sent.
  String serviceUrl;

  /// The connection URL for socket.
  String socketUrl;

  /// Behaves like unique id to distinguish chat room for backend.
  String userName;

  String? authUrl;
  String? messageInputHintText;
  UserAvatar? outgoingAvatar;
  UserAvatar? incomingAvatar;
  ChatTheme chatTheme = const DefaultChatTheme();

  EtiyaChatbotBuilder({
    required this.serviceUrl,
    required this.socketUrl,
    required this.userName,
  }) {
    setLoggingEnabled();
  }

  /// The connection URL for ldap authorization.
  EtiyaChatbotBuilder setAuthUrl(String url) {
    authUrl = url;
    return this;
  }

  /// The hint text displayed on message input field.
  EtiyaChatbotBuilder setMessageInputHintText(String text) {
    messageInputHintText = text;
    return this;
  }

  /// Avatar configuration for incoming messages.
  EtiyaChatbotBuilder setIncomingAvatar(UserAvatar avatar) {
    incomingAvatar = avatar;
    return this;
  }

  /// Avatar configuration for outgoing messages.
  EtiyaChatbotBuilder setOutgoingAvatar(UserAvatar avatar) {
    outgoingAvatar = avatar;
    return this;
  }

  /// Chat theme for styling the Chat widget and inner elements.
  EtiyaChatbotBuilder setChatTheme(ChatTheme theme) {
    chatTheme = theme;
    return this;
  }

  /// Configuration for logging internal events, disabled by default.
  // ignore: avoid_positional_boolean_parameters
  EtiyaChatbotBuilder setLoggingEnabled([bool enabled = false]) {
    Log.isEnabled = enabled;
    return this;
  }

  EtiyaChatbot build() => EtiyaChatbot(builder: this);
}
