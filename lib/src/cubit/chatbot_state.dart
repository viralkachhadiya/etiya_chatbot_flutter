part of 'chatbot_cubit.dart';

abstract class ChatbotState {
  List<Message> messages = [];

  ChatbotState();
}

class MessagesUpdated extends ChatbotState {}
