import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:etiya_chatbot_flutter/src/cubit/chatbot_cubit.dart';
import 'package:etiya_chatbot_flutter/src/models/api/etiya_message_request.dart';
import 'package:etiya_chatbot_flutter/src/models/etiya_quick_reply.dart';
import 'package:etiya_chatbot_flutter/src/repositories/http/http_client_repository.dart';
import 'package:etiya_chatbot_flutter/src/repositories/socket_repository.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockedHttpClientRepository extends Mock implements HttpClientRepository {}

class MockedSocketRepository extends Mock implements SocketRepository {}

class MockedMessageRequest extends Mock implements MessageRequest {}

void main() {
  group('ChatbotCubit', () {
    late ChatbotCubit chatbotCubit;
    late EtiyaChatbotBuilder _etiyaChatbotBuilder;
    late SocketRepository _socketRepository;
    late MockedHttpClientRepository _mockHttpClientRepository;

    setUpAll(() {
      registerFallbackValue(MockedMessageRequest());
    });

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
      chatbotCubit.dispose();
      chatbotCubit.close();
    });

    test('initial State Equal empty `ChatbotMessages`', () {
      final _chatbotCubit = ChatbotCubit(
        chatbotBuilder: _etiyaChatbotBuilder,
        socketRepository: _socketRepository,
        httpClientRepository: _mockHttpClientRepository,
      );
      expect(_chatbotCubit.state, ChatbotMessages());
      _chatbotCubit.close();
    });

    blocTest<ChatbotCubit, ChatbotState>(
      'emit ChatbotMessages when user adds TEXT message',
      build: () {
        when(
          () => _mockHttpClientRepository.sendMessage(
            any<MessageRequest>(),
          ),
        ).thenAnswer((invocation) async {});
        return chatbotCubit;
      },
      act: (bloc) => bloc.userAddedMessage('messageText'),
      expect: () => [
        ChatbotMessages()
          ..messages = chatbotCubit.state.messages
              .where((element) => element.messageKind.text == 'messageText')
              .toList(),
      ],
    );

    blocTest<ChatbotCubit, ChatbotState>(
      'emit ChatbotMessages when user adds QUICK_REPLY message',
      build: () {
        when(
          () => _mockHttpClientRepository.sendMessage(
            any<MessageRequest>(),
          ),
        ).thenAnswer((invocation) async {});
        return chatbotCubit;
      },
      act: (bloc) => bloc.userAddedQuickReplyMessage(const EtiyaQuickReplyItem(
          title: 'quickReplyText', payload: 'quickReplyPayload')),
      expect: () => [
        ChatbotMessages()
          ..messages = chatbotCubit.state.messages
              .where((element) => element.messageKind.text == 'quickReplyText')
              .toList(),
      ],
    );

    blocTest<ChatbotCubit, ChatbotState>(
      'emit ChatbotMessages when user adds CAROUSEL message',
      build: () {
        when(
          () => _mockHttpClientRepository.sendMessage(
            any<MessageRequest>(),
          ),
        ).thenAnswer((invocation) async {});
        return chatbotCubit;
      },
      act: (bloc) => bloc.userAddedCarouselMessage(
        CarouselButtonItem(
          title: 'carouselButtonTitle',
          url: 'url',
          payload: 'carouselButtonPayload',
        ),
      ),
      expect: () => [
        ChatbotMessages()
          ..messages = chatbotCubit.state.messages
              .where((element) => element.messageKind.text == 'carouselButtonTitle')
              .toList(),
      ],
    );

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
      verify: (_) {
        verify(
          () => _mockHttpClientRepository.auth(
            username: 'username',
            password: 'correctPassword',
          ),
        ).called(1);
      },
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
      verify: (_) {
        verify(
          () => _mockHttpClientRepository.auth(
            username: 'username',
            password: 'wrongPassword',
          ),
        ).called(1);
      },
    );
  });
}
