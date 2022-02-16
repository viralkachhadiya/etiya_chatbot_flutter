import 'package:etiya_chatbot_domain/etiya_chatbot_domain.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketRepositoryImpl extends SocketClientRepository {
  late IO.Socket _socket;

  SocketRepositoryImpl({
    required String url,
    String namespace = '/',
    Map query = const {},
  }) : super(
          url: url,
          namespace: namespace,
          query: query,
        ) {
    initializeSocket();
  }

  void initializeSocket() {
    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .enableForceNew()
          .setQuery(query)
          .setTransports(['websocket']) // for Flutter or Dart VM
          .setPath('/ws')
          .build(),
    )..nsp = namespace;
  }

  @override
  void dispose() {
    _socket
      ..close()
      ..clearListeners();
  }

  @override
  void connect() => _socket.connect();

  @override
  void onConnect(Handler handler) {
    _socket.onConnect((data) => handler(data));
  }

  @override
  void onEvent(Map<String, Handler> eventHandler) {
    eventHandler.forEach((key, value) {
      _socket.on(key, (data) => value(data));
    });
  }

  @override
  void onError(Handler? onError) {
    _socket.onError((data) => onError?.call(data));
  }

  @override
  void emit(String event, [dynamic data]) => _socket.emit(event, data);
}
