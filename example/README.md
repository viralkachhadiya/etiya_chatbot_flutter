# Etiya ChatbotSDK example project

An example project to demonstrate how Etiya Chatbot SDK can be implemented.

### Supported Platforms

* iOS
* Android
* Web

### How to integrate SDK

See [main.dart](lib/main.dart) file for detail.

```dart
class MyHomePage extends StatefulWidget {
  final EtiyaChatbot _etiyaChatbot = EtiyaChatbotBuilder(
    serviceUrl: 'https://chatbotbo-demo8.serdoo.com/api/chat',
    socketUrl: 'https://chatbotbo-demo8.serdoo.com/nlp',
    userName: 'enesKaraosman'
  )
  .setLoggingEnabled(true)
  .setIncomingAvatar(
    UserAvatar(
      size: 36,
      imageProvider: const NetworkImage(
        'https://www.softronic.se/wp-content/uploads/2020/03/avatar_chatbot.png',
      ),
    ),
  )
  .setChatTheme(CustomChatbotTheme())
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
```

`EtiyaChatbotBuilder` has mandatory parameters in it's constructor, rest methods are optional.

### Troubleshooting

* MacOS

#### Connect_error on MacOS with SocketException: Connection failed
* Refer to https://github.com/flutter/flutter/issues/47606#issuecomment-568522318 issue.

By adding the following key into the to file `*.entitlements` under directory `macos/Runner/`
```
<key>com.apple.security.network.client</key>
<true/>
```