import 'package:etiya_chatbot_flutter/src/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'chat_view_model.dart';
import 'etiya_chat_widget.dart';

class EtiyaChatbot {
  final EtiyaChatbotBuilder builder;

  EtiyaChatbot({required this.builder});

  Widget getChatWidget(ChatViewModel viewModel) {
    return EtiyaChatWidget(
      viewModel: viewModel,
    );
  }
}

class EtiyaChatbotBuilder {
  String? userName;
  String? serviceUrl;
  String? socketUrl;
  String? authUrl;

  EtiyaChatbotBuilder() {
    setDeviceID();
  }
  
  Future<void> setDeviceID() async {
    const preferenceKey = Constants.deviceIDKey;
    final sp = await SharedPreferences.getInstance();
    final deviceID = sp.getString(preferenceKey);
    if (deviceID == null) {
      final uuid = Uuid().v1();
      sp.setString(preferenceKey, uuid);
      debugPrint("deviceID: $uuid is saved to DB");
    }
  }

  /// Behaves like unique id to distinguish chats for backend.
  EtiyaChatbotBuilder setUserName(String name) {
    this.userName = name;
    return this;
  }

  /// The connection URL for messages to be sent.
  EtiyaChatbotBuilder setServiceUrl(String url) {
    this.serviceUrl = url;
    return this;
  }

  /// The connection URL for socket.
  EtiyaChatbotBuilder setSocketUrl(String url) {
    this.socketUrl = url;
    return this;
  }

  /// The connection URL for ldap authorization.
  EtiyaChatbotBuilder setAuthUrl(String url) {
    this.authUrl = url;
    return this;
  }

  EtiyaChatbot build() {
    return EtiyaChatbot(builder: this);
  }
}