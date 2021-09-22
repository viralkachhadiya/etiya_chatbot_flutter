import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  ImageViewer({
    Key? key,
    required this.imageURL,
    this.closeAction,
  }) : super(key: key);

  final String imageURL;
  VoidCallback? closeAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: PhotoView(
                imageProvider: NetworkImage(imageURL),
                loadingBuilder: (_, __) => const Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: IconButton(
                onPressed: () => closeAction?.call(),
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
