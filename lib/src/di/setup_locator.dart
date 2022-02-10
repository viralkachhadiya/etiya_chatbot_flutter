import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:etiya_chatbot_flutter/src/data/repositories/device_id_repository_impl.dart';
import 'package:etiya_chatbot_flutter/src/data/repositories/http_client_repository_impl.dart';
import 'package:etiya_chatbot_flutter/src/data/repositories/socket_repository_impl.dart';
import 'package:etiya_chatbot_flutter/src/domain/http_client_repository.dart';
import 'package:etiya_chatbot_flutter/src/domain/socket_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependencyInjection {
  const DependencyInjection._();

  static Future<List<RepositoryProvider>> build(
    EtiyaChatbotBuilder builder,
  ) async {
    final deviceIdRepository = DeviceIdRepositoryImpl();
    final deviceId = await deviceIdRepository.fetchDeviceId();

    final sharedPreferences = await SharedPreferences.getInstance();

    final String visitorId = '${builder.userName}_$deviceId';
    final socketRepository = SocketRepositoryImpl(
      url: builder.socketUrl,
      namespace: '/chat',
      query: { 'visitorId': visitorId },
    );

    final httpClient = HttpClientRepositoryImpl(
      serviceUrl: builder.serviceUrl,
      authUrl: builder.authUrl!,
      userId: deviceId,
    );

    return [
      RepositoryProvider<SocketClientRepository>(
        create: (_) => socketRepository,
      ),
      RepositoryProvider<SharedPreferences>(
        create: (_) => sharedPreferences,
      ),
      RepositoryProvider<HttpClientRepository>(
        create: (_) => httpClient,
      ),
      RepositoryProvider<ChatTheme>(
        create: (_) => builder.chatTheme,
      ),
    ];
  }
}
