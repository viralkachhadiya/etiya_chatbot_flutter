import 'package:flutter/material.dart';
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

  EtiyaChatbotBuilder();

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

// import SwiftUI
// import UIKit
// import SwiftyChat
//
// public typealias EtiyaChatStyle = ChatMessageCellStyle
//
// public struct EtiyaChatbot {
//
// private init(builder: EtiyaChatbot.Builder) {
// self.builder = builder
// }
//
// public class Builder {
//
//   internal var welcomeMessage: String?
//   internal var userName: String = "unnamed"
//   internal var serviceUrl: String = ""
//   internal var socketUrl: String = ""
//   internal var authUrl: String = ""
//   internal var style: EtiyaChatStyle = .etiyaStyle
//   internal var avatarManager = AvatarManager()
//
//   public init() {
//   guard let _ = UserDefaults.standard.value(forKey: "chatbot_deviceId") as? String
//   else {
//   UserDefaults.standard.setValue(UUID().uuidString, forKey: "chatbot_deviceId")
//   UserDefaults.standard.synchronize()
//   return
//   }
//   }
//
//   /// The message shown by chatbot to welcome user. (Optional)
//   public func setWelcomeMessage(_ message: String?) -> Self {
//   self.welcomeMessage = message
//   return self
//   }
//
//   /// Set Chatbot & User's avatar. (Optional)
//   public func setAvatarManager(_ manager: AvatarManager) -> Self {
//   self.avatarManager = manager
//   return self
//   }
//
//   /// Configure your styles for all available message cell types.
//   public func setStyle(_ style: EtiyaChatStyle) -> Self {
//   self.style = style
//   return self
//   }
//
//   /// Prepares an `EtiyaChatbot` instance with the configured `Builder`.
//   public func build() -> EtiyaChatbot {
//   EtiyaChatbot.init(builder: self)
//   }
//
// }
//
// private let builder: Builder
//
// public func getViewController() -> UIViewController {
// UIHostingController(rootView: getSwiftUIView())
// }
//
// public func getSwiftUIView() -> some View {
// EtiyaChatView(viewModel: .init(builder: builder))
// }
//
// }
