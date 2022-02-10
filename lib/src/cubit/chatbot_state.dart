part of 'chatbot_cubit.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState({
    this.messages = const [],
  });

  final List<Message> messages;

  @override
  List<Object?> get props => [messages];
}

class ChatbotMessages extends ChatbotState {
  const ChatbotMessages({
    List<Message> messages = const [],
  }) : super(messages: messages);
}

class ChatbotUserAuthenticated extends ChatbotState {
  final bool isAuthenticated;

  // ignore: avoid_positional_boolean_parameters
  const ChatbotUserAuthenticated(this.isAuthenticated);

  @override
  List<Object?> get props => [messages, isAuthenticated];
}
