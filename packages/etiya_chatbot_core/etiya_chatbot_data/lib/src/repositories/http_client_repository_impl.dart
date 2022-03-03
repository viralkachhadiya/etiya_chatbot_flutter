import 'dart:convert';

import 'package:etiya_chatbot_data/etiya_chatbot_data.dart';
import 'package:etiya_chatbot_domain/etiya_chatbot_domain.dart';

import 'package:http/http.dart' as http;
import 'package:togg_mobile_super_app_sdk/togg_mobile_super_app_sdk.dart';

class HttpClientRepositoryImpl extends HttpClientRepository {
  HttpClientRepositoryImpl({
    required String serviceUrl,
    required String? authUrl,
    required String userId,
    required String accessToken,
  }) : super(
          serviceUrl: serviceUrl,
          authUrl: authUrl,
          userId: userId,
          accessToken: accessToken,
        ) {
    _httpClient = TOGGMobileSdk().getTOGGHttpClient(null, true);
  }

  late final ITOGGHttpClient _httpClient;

  @override
  Future<bool> auth({
    required String username,
    required String password,
  }) async {
    try {
      if (authUrl == null) return false;
      final _response = await _httpClient.post(
        endpoint: authUrl!,
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
        print(response.body);
        // Log.info(response.body);
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final isAuth = json["isAuth"] as bool? ?? false;
        print("isAuthenticated: $isAuth");
        // Log.info("isAuthenticated: $isAuth");
        return isAuth;
      } else {
        // Log.error(
        print(
          "User's message could not sent, statusCode: ${response.statusCode}",
        );
        return false;
      }
    } catch (error) {
      print(error.toString());
      // Log.error(error.toString());
      return false;
    }
  }

  @override
  Future<void> sendMessage({
    String type = 'text',
    required String text,
    required String senderId,
    String? quickReplyTitle,
    String? quickReplyPayload,
  }) async {
    try {
      final toggUser = TOGGMobileSdk().getTOGGUser();
      final _response = await _httpClient.post(
        endpoint: '$serviceUrl/mobile',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        params: MessageRequest(
          text: text,
          user: MessageUser(
            senderId: senderId,
            firstName: toggUser.firstName,
            lastName: toggUser.lastName,
          ),
          type: type,
          data: QuickReply(title: quickReplyTitle, payload: quickReplyPayload),
        ).toJson(),
      );
      final response = _response as http.Response?;
      if (response == null) return;
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        // Log.info("User's message sent successfully");
        print("User's message sent successfully");
      } else {
        print(
          // Log.error(
          "User's message could not sent, statusCode: ${response.statusCode}",
        );
      }
    } catch (error) {
      // Log.error(error.toString());
      print(error.toString());
    }
  }
}
