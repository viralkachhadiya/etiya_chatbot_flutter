import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../etiya_chatbot.dart';
import '../repositories/device_id_repository.dart';
import '../repositories/http/http_client_repository.dart';
import '../repositories/socket_repository.dart';
import '../repositories/socket_repository_impl.dart';

class DependencyInjection {
  const DependencyInjection._();

  static Future<List<RepositoryProvider>> build(
    EtiyaChatbotBuilder builder,
  ) async {
    final deviceIdRepository = DeviceIdRepositoryImpl();
    final deviceId = await deviceIdRepository.fetchDeviceId();

    final sharedPreferences = await SharedPreferences.getInstance();
    final socketRepository = SocketRepositoryImpl(
      userName: builder.userName,
      deviceId: deviceId,
      socketUrl: builder.socketUrl,
    );

    final httpClient = HttpClientRepositoryImpl(
      serviceUrl: builder.serviceUrl,
      authUrl: builder.authUrl!,
      userId: deviceId,
    );

    return [
      RepositoryProvider<SocketRepository>(
        create: (_) => socketRepository,
      ),
      RepositoryProvider<SharedPreferences>(
        create: (_) => sharedPreferences,
      ),
      RepositoryProvider<HttpClientRepository>(
        create: (_) => httpClient,
      ),
    ];
  }
}
