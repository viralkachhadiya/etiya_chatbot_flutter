import 'package:flutter/material.dart';
import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';

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
          imageURL: Uri.parse(
            'https://i.pravatar.cc/300',
          ),
        ),
      )
      // .setStyle(style)
      .setSocketUrl("https://chatbotbo-demo8.serdoo.com/chat")
      .setServiceUrl("https://chatbotbo-demo8.serdoo.com/api/chat")
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
