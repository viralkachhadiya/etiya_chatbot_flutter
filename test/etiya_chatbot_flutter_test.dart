import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:etiya_chatbot_flutter/src/cubit/chatbot_cubit.dart';
import 'package:etiya_chatbot_flutter/src/repositories/http/http_client_repository.dart';
import 'package:etiya_chatbot_flutter/src/repositories/socket_repository.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
import 'package:mocktail/mocktail.dart';

class MockedHttpClientRepository extends Mock implements HttpClientRepository {}

void main() {
  group('ChatbotCubit', () {
    late ChatbotCubit chatbotCubit;
    late EtiyaChatbotBuilder _etiyaChatbotBuilder;
    late SocketRepository _socketRepository;
    late MockedHttpClientRepository _mockHttpClientRepository;

    setUp(() {
      _etiyaChatbotBuilder = EtiyaChatbotBuilder(
        serviceUrl: 'https://chatbotbo-demo8.serdoo.com/api/chat',
        socketUrl: 'https://chatbotbo-demo8.serdoo.com/nlp',
        userName: 'enesKaraosman',
      );

      _mockHttpClientRepository = MockedHttpClientRepository();

      _socketRepository = FakeSocketRepository(
        userName: 'userName',
        deviceId: 'deviceId',
        socketUrl: 'socketUrl',
      );

      chatbotCubit = ChatbotCubit(
        chatbotBuilder: _etiyaChatbotBuilder,
        socketRepository: _socketRepository,
        httpClientRepository: _mockHttpClientRepository,
      );
    });

    tearDown(() {
      chatbotCubit.close();
    });

    test('Should_InitialStateEqual', () {
      final _chatbotCubit = ChatbotCubit(
        chatbotBuilder: _etiyaChatbotBuilder,
        socketRepository: _socketRepository,
        httpClientRepository: _mockHttpClientRepository,
      );
      expect(_chatbotCubit.state, ChatbotMessages());
      _chatbotCubit.close();
    });

    blocTest<ChatbotCubit, ChatbotState>(
      'emit ChatbotUserAuthenticated(true) when user authenticates successfully',
      build: () {
        when(
          () => _mockHttpClientRepository.auth(
            username: 'username',
            password: 'correctPassword',
          ),
        ).thenAnswer((_) async => true);
        return chatbotCubit;
      },
      act: (bloc) => bloc.authenticate(
        username: 'username',
        password: 'correctPassword',
      ),
      expect: () => contains(ChatbotUserAuthenticated(true)),
    );

    blocTest<ChatbotCubit, ChatbotState>(
      'emit ChatbotUserAuthenticated(false) when user authentication fails',
      build: () {
        when(
              () => _mockHttpClientRepository.auth(
            username: 'username',
            password: 'wrongPassword',
          ),
        ).thenAnswer((_) async => false);
        return chatbotCubit;
      },
      act: (bloc) => bloc.authenticate(
        username: 'username',
        password: 'wrongPassword',
      ),
      expect: () => contains(ChatbotUserAuthenticated(false)),
    );

  });
}
