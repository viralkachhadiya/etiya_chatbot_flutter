part of 'chatbot_cubit.dart';

abstract class ChatbotState extends Equatable {
  List<Message> messages = [];

  @override
  List<Object?> get props => [messages];
}

class ChatbotMessages extends ChatbotState {}

class ChatbotUserAuthenticated extends ChatbotState {
  final bool isAuthenticated;

  ChatbotUserAuthenticated(this.isAuthenticated);

  @override
  List<Object?> get props => [messages, isAuthenticated];
}
