import 'package:flutter_chat/models/IQuickReplyItem.dart';

class EtiyaQuickReplyItem extends IQuickReplyItem {
  final String title;
  final String? payload;
  final String? url;

  const EtiyaQuickReplyItem({required this.title, this.payload, this.url}) :
        super(title: title, payload: payload, url: url);
}