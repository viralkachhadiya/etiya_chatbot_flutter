import 'package:swifty_chat/swifty_chat.dart';

class EtiyaQuickReplyItem extends QuickReplyItem {
  const EtiyaQuickReplyItem({
    required String title,
    String? payload,
    String? url,
  }) : super(
          title: title,
          payload: payload,
          url: url,
        );
}
