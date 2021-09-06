import 'package:swifty_chat/swifty_chat.dart';

class EtiyaCarouselItem extends CarouselItem {
  final String title;
  final String subtitle;
  final String? imageURL;
  final List<CarouselButtonItem> buttons;

  const EtiyaCarouselItem({
    required this.title,
    required this.subtitle,
    this.imageURL,
    this.buttons = const [],
  }) : super(
            title: title,
            subtitle: subtitle,
            imageURL: imageURL,
            buttons: buttons);
}
