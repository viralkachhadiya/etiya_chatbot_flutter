import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:etiya_chatbot_flutter/src/cubit/chatbot_cubit.dart';
import 'package:etiya_chatbot_flutter/src/repositories/http/http_client_repository.dart';
import 'package:etiya_chatbot_flutter/src/repositories/socket_repository.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
import 'package:mocktail/mocktail.dart';

class MockedHttpClientRepository extends Mock implements HttpClientRepository {}

// @GenerateMocks([MockHttpClientRepository, HttpClientRepository])
void main() {
  group('ChatbotCubit', () {
    late ChatbotCubit chatbotCubit;
    late EtiyaChatbotBuilder _etiyaChatbotBuilder;
    late SocketRepository _socketRepository;
    late HttpClientRepository _httpClientRepository;
    late MockedHttpClientRepository _mockHttpClientRepository;

    setUp(() {
      _etiyaChatbotBuilder = EtiyaChatbotBuilder(
        serviceUrl: 'https://chatbotbo-demo8.serdoo.com/api/chat',
        socketUrl: 'https://chatbotbo-demo8.serdoo.com/nlp',
        userName: 'enesKaraosman',
      );

      _httpClientRepository = FakeHttpClientRepository(
        serviceUrl: 'serviceUrl',
        authUrl: 'authUrl',
        userId: 'userId',
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
        // httpClientRepository: httpClientRepository,
        httpClientRepository: _mockHttpClientRepository,
      );
    });

    tearDown(() {
      chatbotCubit.close();
    });

    // test('Test mock', () {
    //   when(
    //     () => mockHttpClientRepository.auth(
    //       username: any<String>(),
    //       password: any<String>(),
    //     ),
    //   ).thenAnswer((_) async => true);
    //   // .thenReturn(Future.value(true));
    //
    //   // expect(mockHttpClientRepository.auth(username: 'username', password: 'password'), true);
    //   // expectLater(() => mockHttpClientRepository.auth(username: 'username', password: 'password'), true);
    //   expectLater(
    //       mockHttpClientRepository.auth(
    //           username: 'username', password: 'password'),
    //       true);
    // });

    test('Should_InitialStateEqual', () {
      final _chatbotCubit = ChatbotCubit(
        chatbotBuilder: _etiyaChatbotBuilder,
        socketRepository: _socketRepository,
        httpClientRepository: _httpClientRepository,
      );
      expect(_chatbotCubit.state, ChatbotMessages());
      _chatbotCubit.close();
    });

    test('Boom', () {
      when(
            () => _mockHttpClientRepository.auth(
          // () => _mockHttpClientRepository.auth(
          username: any<String>(named: 'username'),
          password: any<String>(named: 'password'),
        ),
      ).thenAnswer((_) async => true);
      expect(_mockHttpClientRepository.auth(username: any(named: 'username'), password: any(named: 'password')), true);
    });

    blocTest<ChatbotCubit, ChatbotState>(
      'emit ChatbotUserAuthenticated(true) when user tries to authenticate',
      build: () {
        when(
          () => chatbotCubit.httpClientRepository.auth(
          // () => _mockHttpClientRepository.auth(
            username: any<String>(named: 'username'),
            password: any<String>(named: 'password'),
          ),
        ).thenAnswer((_) async => true);

        // return ChatbotCubit(
        //   chatbotBuilder: _etiyaChatbotBuilder,
        //   socketRepository: _socketRepository,
        //   httpClientRepository: _mockHttpClientRepository,
        // );
        return chatbotCubit;
      },
      act: (bloc) => bloc.authenticate(
        username: any<String>(named: 'username'), //'username',
        password: any<String>(named: 'password'), //'password',
      ),
      expect: () => contains(ChatbotUserAuthenticated(true)),
    );

    // blocTest<ChatbotCubit, ChatbotState>(
    //   'emits [ChatbotUserAuthenticated(true)] when ChatbotCubit authenticates successfully',
    //   build: () => chatbotCubit,
    //   act: (bloc) =>
    //       bloc.authenticate(username: 'username', password: 'password'),
    //   expect: () => contains(ChatbotUserAuthenticated(true)),
    // );
    //
    // blocTest<ChatbotCubit, ChatbotState>(
    //   'emits [ChatbotUserAuthenticated(false)] when ChatbotCubit authenticates unsuccessfully',
    //   build: () => chatbotCubit,
    //   act: (bloc) =>
    //       bloc.authenticate(username: 'username', password: 'wrongPassword'),
    //   expect: () => contains(ChatbotUserAuthenticated(false)),
    // );
  });
}
