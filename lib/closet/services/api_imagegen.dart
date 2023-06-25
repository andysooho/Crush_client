import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class ImageApi {
  final Dio _dio = Dio();

  Future<String> generateImage(String tagResult, File imageFile, String imageMaskPath) async {
    String openaiApiKey = 'your key';

    // 파일을 바이트로 읽고 MultipartFile로 변환하는 부분 추가
    ByteData data = await rootBundle.load(imageMaskPath);
    List<int> bytes = data.buffer.asUint8List();
    MultipartFile imageMask = MultipartFile.fromBytes(bytes, filename: 'assets/image/mask.png');

    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imageFile.path),
      'mask': imageMask,
      'prompt': tagResult,
      'n': 1,
      'size': '1024x1024',
    });

    Options options = Options(
        headers: {
          'Authorization': 'Bearer $openaiApiKey'
        }
    );

    Response response;
    try {
      response = await _dio.post('https://api.openai.com/v1/images/edits', data: formData, options: options);
      if(response.statusCode == 200) {
        String imageUrl = response.data['data'][0]['url'];
        return imageUrl;
      }
    } catch (error) {
      print('Error: $error');
    }
    return '';
  }
}
