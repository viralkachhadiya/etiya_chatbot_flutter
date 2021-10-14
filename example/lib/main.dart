import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Etiya Chatbot',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final EtiyaChatbot _etiyaChatbot = EtiyaChatbotBuilder()
      // .setWelcomeMessage("Merhaba, size nasıl yardımcı olabilirim")
      .setUserName("enesKaraosman")
      .setLoggingEnabled(true)
      .setIncomingAvatar(
        UserAvatar(
          size: 36,
          imageProvider: const NetworkImage(
            'https://www.softronic.se/wp-content/uploads/2020/03/avatar_chatbot.png',
          ),
        ),
      )
      .setChatTheme(const DefaultChatTheme())
      .setSocketUrl("https://chatbotbo-demo8.serdoo.com/nlp")
      .setServiceUrl("https://chatbotbo-demo8.serdoo.com/api/chat")
      .setAuthUrl("https://chatbotosb-demo8.serdoo.com/api/auth")
      .build();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget._etiyaChatbot.getChatWidget(
        ChatViewModel(builder: widget._etiyaChatbot.builder),
      ),
    );
  }
}
