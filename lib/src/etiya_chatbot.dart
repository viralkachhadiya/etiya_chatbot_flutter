import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifty_chat/swifty_chat.dart';
import 'package:uuid/uuid.dart';

import '../src/util/constants.dart';
import '../src/util/logger.dart';
import 'chat_view_model.dart';
import 'etiya_chat_widget.dart';

class EtiyaChatbot {
  final EtiyaChatbotBuilder builder;

  EtiyaChatbot({required this.builder});

  Widget getChatWidget(ChatViewModel viewModel) =>
      EtiyaChatWidget(viewModel: viewModel);
}

class EtiyaChatbotBuilder {
  String? userName;
  String? serviceUrl;
  String? socketUrl;
  String? authUrl;
  UserAvatar? outgoingAvatar;
  UserAvatar? incomingAvatar;

  EtiyaChatbotBuilder() {
    setDeviceID();
    setLoggingEnabled();
  }

  Future<void> setDeviceID() async {
    const preferenceKey = Constants.deviceIDKey;
    final sp = await SharedPreferences.getInstance();
    final deviceID = sp.getString(preferenceKey);
    if (deviceID == null) {
      final uuid = const Uuid().v1();
      sp.setString(preferenceKey, uuid);
      Log.info("deviceID: $uuid is saved to DB");
    }
  }

  /// Behaves like unique id to distinguish chats for backend.
  EtiyaChatbotBuilder setUserName(String name) {
    userName = name;
    return this;
  }

  /// The connection URL for messages to be sent.
  EtiyaChatbotBuilder setServiceUrl(String url) {
    serviceUrl = url;
    return this;
  }

  /// The connection URL for socket.
  EtiyaChatbotBuilder setSocketUrl(String url) {
    socketUrl = url;
    return this;
  }

  /// The connection URL for ldap authorization.
  EtiyaChatbotBuilder setAuthUrl(String url) {
    authUrl = url;
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

  /// Configuration for logging internal events, disabled by default.
  EtiyaChatbotBuilder setLoggingEnabled([bool enabled = false]) {
    Log.isEnabled = enabled;
    return this;
  }

  EtiyaChatbot build() => EtiyaChatbot(builder: this);
}
