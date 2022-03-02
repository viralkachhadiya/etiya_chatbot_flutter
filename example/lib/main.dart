import 'package:etiya_chatbot_flutter/etiya_chatbot_flutter.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Etiya Chatbot',
      home: MyHomePage(),
    );
  }
}

class ToggChatbotTheme extends ChatTheme {
  const ToggChatbotTheme() : super();

  final Color toggPrimary = const Color(0xFF00C2E7);
  final Color toggSecondary = const Color(0xFFFF8933);

  @override
  Color get backgroundColor => neutral7;

  @override
  double get messageBorderRadius => 20;

  @override
  double get textMessagePadding => 12;

  @override
  Color get primaryColor => toggSecondary;

  @override
  TextStyle get incomingMessageBodyTextStyle => const TextStyle(
      fontFamily: 'Fedra-Sans-Std', fontSize: 17, color: Colors.white);

  @override
  TextStyle get outgoingMessageBodyTextStyle => const TextStyle(
      fontFamily: 'Fedra-Sans-Std', fontSize: 17, color: Colors.white);

  @override
  Color get secondaryColor => toggPrimary;

  @override
  EdgeInsets get messageInset => const EdgeInsets.symmetric(vertical: 8);

  @override
  TextStyle get carouselTitleTextStyle =>
      const TextStyle(fontFamily: 'Fedra-Sans-Std', fontSize: 19);

  @override
  TextStyle get carouselSubtitleTextStyle =>
      const TextStyle(fontFamily: 'Fedra-Sans-Std', fontSize: 17);

  @override
  ButtonStyle get carouselButtonStyle => ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(toggPrimary),
      );

  @override
  ButtonStyle get quickReplyButtonStyle => ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(toggPrimary),
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            fontWeight: FontWeight.bold,
            color: toggPrimary,
          ),
        ),
      );

  @override
  Color get htmlTextColor => neutral0;

  @override
  String? get htmlTextFontFamily => 'Avenir';

  @override
  BoxDecoration get carouselBoxDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFDFF2F6),
      );

  @override
  BorderRadius get imageBorderRadius => BorderRadius.zero;
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  final EtiyaChatbot _etiyaChatbot = EtiyaChatbotBuilder(
    serviceUrl: 'https://chatbotbo-test.togg.com.tr/api/chat',
    socketUrl: 'https://chatbotbo-test.togg.com.tr/nlp',
    userName: 'enesKaraosman',
  )
      .setAccessToken(
          'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJuQ2dERW8wNjhtTHJPZDZzeUttYThPaEgtTmtwUXZsNGs5UTlrX0JHbHlRIn0.eyJleHAiOjE2NDYyMDU4MDYsImlhdCI6MTY0NjIwNDAwNiwiYXV0aF90aW1lIjoxNjQ2MjA0MDA2LCJqdGkiOiJhZmFkYzRlZS1mNjMxLTQwMmMtOWFkZS1iMDg3MTM2Nzc5OWYiLCJpc3MiOiJodHRwczovL3RvZ2dpZC5kZXZlbG9wbWVudC50b2dnLmNsb3VkL2F1dGgvcmVhbG1zL3RvZ2dpZCIsInN1YiI6IjYyNmIyYTRlLTNlMzItNDIzNC1iYjdjLWIwMTQ1NGQzZjk4OSIsInR5cCI6IkJlYXJlciIsImF6cCI6InN1cGVyLWFwcCIsIm5vbmNlIjoiclJrLWNQMWNwSmlIVXJUQjc3YTZRQ2JHRHF5LVNfOURzOXNzNWxrelJsQSIsInNlc3Npb25fc3RhdGUiOiJkZDYxOTNjZi1jZWI1LTRjM2YtYTQ5MC03Yzk3NDFhYzVlNDgiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm1vYmlsZS1hcHAtdXNlciJdfSwic2NvcGUiOiJlbWFpbCBwcm9maWxlIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsIm5hbWUiOiJFbmVzIEthcmFvc21hbiIsInByZWZlcnJlZF91c2VybmFtZSI6ImVuZXMua2FyYW9zbWFuQGV0aXlhLmNvbSIsImdpdmVuX25hbWUiOiJFbmVzIiwiZmFtaWx5X25hbWUiOiJLYXJhb3NtYW4iLCJlbWFpbCI6ImVuZXMua2FyYW9zbWFuQGV0aXlhLmNvbSJ9.FrW3mf-5e_-EcFaStdXa_vhM5tgiuwAZncDOTsyhEGDHpamZvuV85-bE0Hqa2R9uGnO6wZjJXrkc7H2joMH3CJMJ770uwZNIJz4b807rEnW3A8Qjru424MZ2HxGD7lFW6DaS5ygWIPhBspfTcjqAzUkaFWEhXKTrEKqteI-kEqYuA0omLnb6ycUn_GfO2hJWhbvVsqE4Aq1fQO5wEIV_1Y9RSsZ_mNowHuBT5f_7GikUCMlAQt6i8sEHBMEkNOne8Wdz_pcnZJtme1VgD2UsAF7e3uL6h2bu2irmlCmyxymiZMqTbcl_01AFCA_yGvQfObccVoJGpo7JmEzK2tgceQ')
      .setLoggingEnabled(true)
      .setIncomingAvatar(
        UserAvatar(
          size: 36,
          imageProvider: const NetworkImage(
            'https://www.softronic.se/wp-content/uploads/2020/03/avatar_chatbot.png',
          ),
        ),
      )
      .setChatTheme(const ToggChatbotTheme())
      .setAuthUrl('https://chatbotosb-demo8.serdoo.com/api/auth')
      .build();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00C2E7),
      ),
      body: FutureBuilder(
        future: widget._etiyaChatbot.getChatWidget(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data! as Widget;
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
