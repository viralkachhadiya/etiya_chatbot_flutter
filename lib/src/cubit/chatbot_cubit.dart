import 'package:bloc/bloc.dart';
import 'package:etiya_chatbot_flutter/src/util/logger.dart';
import 'package:swifty_chat/swifty_chat.dart';

import '../etiya_chatbot.dart';
import '../http/http_client_repository.dart';
import '../models/api/etiya_message_request.dart';
import '../models/api/etiya_message_response.dart';
import '../models/etiya_chat_message.dart';
import '../repositories/socket_repository.dart';

part 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  final SocketRepository socketRepository;
  final HttpClientRepository httpClientRepository;
  final EtiyaChatbotBuilder chatbotBuilder;

  ChatTheme get chatTheme => chatbotBuilder.chatTheme;

  String get messageInputHintText =>
      chatbotBuilder.messageInputHintText ?? "Aa";

  /// Chatbot User
  late EtiyaChatUser _chatBotUser;

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
  }) : super(MessagesUpdated()) {
    socketRepository.onNewMessageReceived = (messageResponse) {
      Log.info('socketRepository.onNewMessageReceived');
      _chatBotUser =
          messageResponse.user ?? EtiyaChatUser(firstName: 'Chatbot');
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
            senderId: socketRepository.userId,
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
    final updatedMessages = state.messages;
    updatedMessages.insertAll(0, messages);
    emit(
      MessagesUpdated()..messages = updatedMessages,
    );
  }

  /// Triggered when user fills message input field.
  Future<void> userAddedMessage(String messageText) async {
    await httpClientRepository.sendMessage(
      MessageRequest(
        text: messageText,
        user: MessageUser(
          senderId: socketRepository.userId,
        ),
      ),
    );
    _insertNewMessages(
      [
        EtiyaChatMessage(
          isMe: true,
          id: DateTime.now().toString(),
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
          senderId: socketRepository.userId,
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
        id: DateTime.now().toString(),
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
          senderId: socketRepository.userId,
        ),
      ),
    );
    _insertNewMessages([
      EtiyaChatMessage(
        isMe: true,
        id: DateTime.now().toString(),
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
    emit(
      MessagesUpdated()
        ..messages.insert(
          0,
          EtiyaChatMessage(
            isMe: false,
            id: DateTime.now().toString(),
            messageKind: MessageKind.text(
              isAuthenticated ? "Giriş Başarılı" : "Giriş Başarısız",
            ),
            chatUser: _customerUser,
          ),
        ),
    );
  }
}
