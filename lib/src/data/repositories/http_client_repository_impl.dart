import 'dart:convert';

import 'package:etiya_chatbot_flutter/src/data/models/models.dart';
import 'package:etiya_chatbot_flutter/src/domain/http_client_repository.dart';
import 'package:etiya_chatbot_flutter/src/util/logger.dart';
import 'package:http/http.dart' as http;
import 'package:togg_mobile_super_app_sdk/togg_mobile_super_app_sdk.dart';

class HttpClientRepositoryImpl extends HttpClientRepository {
  HttpClientRepositoryImpl({
    required String serviceUrl,
    required String authUrl,
    required String userId,
  }) : super(serviceUrl: serviceUrl, authUrl: authUrl, userId: userId) {
    _httpClient = TOGGMobileSdk().getTOGGHttpClient();
  }

  late final ITOGGHttpClient _httpClient;

  @override
  Future<bool> auth({
    required String username,
    required String password,
  }) async {
    try {
      final _response = await _httpClient.post(
        endpoint: authUrl,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        params: {
          "username": username,
          "password": password,
          "chatId": "mobile:$userId"
        },
      );
      final response = _response as http.Response?;
      if (response == null) return false;
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        Log.info(response.body);
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final isAuth = json["isAuth"] as bool? ?? false;
        Log.info("isAuthenticated: $isAuth");
        return isAuth;
      } else {
        Log.error(
          "User's message could not sent, statusCode: ${response.statusCode}",
        );
        return false;
      }
    } catch (error) {
      Log.error(error.toString());
      return false;
    }
  }

  @override
  Future<void> sendMessage(MessageRequest request) async {
    try {
      final _response = await _httpClient.post(
        endpoint: '$serviceUrl/mobile',
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        params: request.toJson(),
      );
      final response = _response as http.Response?;
      if (response == null) return;
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        Log.info("User's message sent successfully");
      } else {
        Log.error(
          "User's message could not sent, statusCode: ${response.statusCode}",
        );
      }
    } catch (error) {
      Log.error(error.toString());
    }
  }
}
