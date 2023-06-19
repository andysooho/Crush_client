import 'package:crush_client/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class ImageDisplayPage extends StatelessWidget {
  final String imageUrl;

  const ImageDisplayPage(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코디 생성 결과',
      child: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
