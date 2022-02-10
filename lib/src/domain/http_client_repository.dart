import 'package:etiya_chatbot_flutter/src/data/models/models.dart';

abstract class HttpClientRepository {
  final String serviceUrl;
  final String authUrl;
  final String userId;

  HttpClientRepository({
    required this.serviceUrl,
    required this.authUrl,
    required this.userId,
  });

  /// LDAP Auth
  /// - Parameter username: User Name
  /// - Parameter password: User Password
  /// Returns authentication status.
  Future<bool> auth({
    required String username,
    required String password,
  });

  /// Send Message to Server
  /// - Parameter message: `MessageRequest` wraps the actual message (text or data)
  Future<void> sendMessage(MessageRequest request);
}
