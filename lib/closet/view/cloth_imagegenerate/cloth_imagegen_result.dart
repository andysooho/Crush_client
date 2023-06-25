import 'package:crush_client/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class ImageDisplayPage extends StatelessWidget {
  final String imageUrl;

  const ImageDisplayPage(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코디 생성 결과',
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/image/logo_circle_fit.png',
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.3,
                  alignment: Alignment.center,
                ),
                const Text(
                  '코디 생성이 거의 완료되었어요!\n잠시만 기다려 주세요!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          ),
          Center(
            child: Image.network(imageUrl),
          ),
        ],
      ),
    );
  }
}
