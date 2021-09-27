import 'package:flutter/cupertino.dart';
import 'package:swifty_chat/swifty_chat.dart';

class EtiyaCarouselItem extends CarouselItem {
  final String title;
  final String subtitle;
  final ImageProvider? imageProvider;
  final List<CarouselButtonItem> buttons;

  const EtiyaCarouselItem({
    required this.title,
    required this.subtitle,
    this.imageProvider,
    this.buttons = const [],
  }) : super(
            title: title,
            subtitle: subtitle,
            imageProvider: imageProvider,
            buttons: buttons);
}
