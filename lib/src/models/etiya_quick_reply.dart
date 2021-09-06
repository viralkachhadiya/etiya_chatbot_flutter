import 'package:swifty_chat/swifty_chat.dart';

class EtiyaQuickReplyItem extends QuickReplyItem {
  final String title;
  final String? payload;
  final String? url;

  const EtiyaQuickReplyItem({
    required this.title,
    this.payload,
    this.url,
  }) : super(
          title: title,
          payload: payload,
          url: url,
        );
}
