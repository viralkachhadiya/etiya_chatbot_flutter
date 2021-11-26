import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:swifty_chat/swifty_chat.dart';
import 'package:uuid/uuid.dart';

import '../etiya_chatbot.dart';
import '../models/api/etiya_message_request.dart';
import '../models/api/etiya_message_response.dart';
import '../models/etiya_chat_message.dart';
import '../repositories/http/http_client_repository.dart';
import '../repositories/socket_repository.dart';
import '../util/logger.dart';

part 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  final SocketRepository socketRepository;
  final HttpClientRepository httpClientRepository;
  final EtiyaChatbotBuilder chatbotBuilder;

  String get messageInputHintText =>
      chatbotBuilder.messageInputHintText ?? "Aa";

  /// Customer User
  EtiyaChatUser get _customerUser {
    final user = EtiyaChatUser(fullName: chatbotBuilder.userName);
    user.avatar = chatbotBuilder.outgoingAvatar;
    return user;
  }

  ChatbotCubit({
    required this.chatbotBuilder,
    required this.socketRepository,
    required this.httpClientRepository,
  }) : super(ChatbotMessages()) {
    socketRepository.onNewMessageReceived = (messageResponse) {
      Log.info('socketRepository.onNewMessageReceived');
      messageResponse.user?.fullName = chatbotBuilder.userName;
      messageResponse.user?.avatar = chatbotBuilder.incomingAvatar;
      _insertNewMessages(messageResponse.mapToChatMessage());
    };
    socketRepository.onSocketConnected = () async {
      Log.info('socketRepository.onSocketConnected');
      await httpClientRepository.sendMessage(
        MessageRequest(
          text: '/user_visit',
          user: MessageUser(
            senderId: socketRepository.visitorId,
          ),
        ),
      );
    };
    socketRepository.initializeSocket();
  }

  void dispose() {
    socketRepository.dispose();
  }

  void _insertNewMessages(List<Message> messages) {
    final updatedMessages = [...state.messages];
    updatedMessages.insertAll(0, messages);
    emit(
      ChatbotMessages()..messages = updatedMessages,
    );
  }

  /// Triggered when user fills message input field.
  Future<void> userAddedMessage(String messageText) async {
    await httpClientRepository.sendMessage(
      MessageRequest(
        text: messageText,
        user: MessageUser(
          senderId: socketRepository.visitorId,
        ),
      ),
    );
    _insertNewMessages(
      [
        EtiyaChatMessage(
          isMe: true,
          id: const Uuid().v1(),
          messageKind: MessageKind.text(messageText),
          chatUser: _customerUser,
        ),
      ],
    );
  }

  /// Triggered when user taps quick reply button
  void userAddedQuickReplyMessage(QuickReplyItem item) {
    httpClientRepository.sendMessage(
      MessageRequest(
        text: item.payload ?? "payload",
        user: MessageUser(
          senderId: socketRepository.visitorId,
        ),
        type: "quick_reply",
        data: QuickReply(
          title: item.title,
          payload: item.payload ?? "payload",
        ),
      ),
    );
    _insertNewMessages([
      EtiyaChatMessage(
        isMe: true,
        id: const Uuid().v1(),
        messageKind: MessageKind.text(item.title),
        chatUser: _customerUser,
      )
    ]);
  }

  /// Triggered when user taps carousel button
  void userAddedCarouselMessage(CarouselButtonItem item) {
    httpClientRepository.sendMessage(
      MessageRequest(
        text: item.payload!,
        user: MessageUser(
          senderId: socketRepository.visitorId,
        ),
      ),
    );
    _insertNewMessages([
      EtiyaChatMessage(
        isMe: true,
        id: const Uuid().v1(),
        messageKind: MessageKind.text(item.title),
        chatUser: _customerUser,
      )
    ]);
  }

  Future<void> authenticate({
    required String username,
    required String password,
  }) async {
    final isAuthenticated =
        await httpClientRepository.auth(username: username, password: password);
    emit(ChatbotUserAuthenticated(isAuthenticated));
    _insertNewMessages([
      EtiyaChatMessage(
        isMe: false,
        id: const Uuid().v1(),
        messageKind: MessageKind.text(
          isAuthenticated ? "Giriş Başarılı" : "Giriş Başarısız",
        ),
        chatUser: _customerUser,
      )
    ]);
  }
}
