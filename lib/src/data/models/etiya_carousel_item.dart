import 'package:flutter/cupertino.dart';
import 'package:swifty_chat/swifty_chat.dart';

class EtiyaCarouselItem extends CarouselItem {
  const EtiyaCarouselItem({
    required String title,
    required String subtitle,
    ImageProvider? imageProvider,
    List<CarouselButtonItem> buttons = const [],
  }) : super(
          title: title,
          subtitle: subtitle,
          imageProvider: imageProvider,
          buttons: buttons,
        );
}
