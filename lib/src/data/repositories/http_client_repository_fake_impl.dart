import 'package:etiya_chatbot_flutter/src/data/models/models.dart';
import 'package:etiya_chatbot_flutter/src/domain/http_client_repository.dart';

class FakeHttpClientRepository extends HttpClientRepository {
  FakeHttpClientRepository({
    required String serviceUrl,
    required String authUrl,
    required String userId,
  }) : super(serviceUrl: serviceUrl, authUrl: authUrl, userId: userId);

  @override
  Future<bool> auth({
    required String username,
    required String password,
  }) =>
      Future.value(
        username == 'username' && password == 'password',
      );

  @override
  Future<void> sendMessage(MessageRequest request) =>
      Future.delayed(const Duration(milliseconds: 700));
}