import 'dart:io';

import 'package:crush_client/closet/services/api_imagegen.dart';
import 'package:crush_client/closet/widget/cloth_type_dropdown.dart';
import 'package:crush_client/closet/widget/my_palette_dropdown.dart';
import 'package:crush_client/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'cloth_imagegen_result.dart';

class ClothGenerate extends StatefulWidget {
  const ClothGenerate({super.key});

  @override
  ClothGenerateState createState() => ClothGenerateState();
}

class ClothGenerateState extends State<ClothGenerate> {
  final tagKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final ImageApi _imageApi = ImageApi();

  String tag = '';
  String color = '검정';
  String type = '티셔츠';
  String tagResult = '';
  XFile? _imageFile;

  void _setImageTagResult() {
    if (tag.isEmpty) {
      tagResult = '$color $type';
    } else {
      tagResult = tag;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코디 생성',
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                _imageFile =
                await _picker.pickImage(source: ImageSource.gallery);
                setState(() {});
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.45,
                  color: Colors.grey,
                  child: _imageFile != null
                      ? Image.file(
                    File(_imageFile!.path),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.45,
                  )
                      : const Icon(Icons.camera_alt),
                ),
              ),
            ),
            Form(
              key: tagKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      renderTextFormField(
                        label: '코디 태그',
                        onSaved: (val) {
                          setState(() {
                            tag = val;
                          });
                        },
                        validator: (val) {
                        },
                      ),
                      const Text("참고. 위에 원하는 태그를 영어로 입력해주세요.\n예시: A woman, black t-shirt"),
                      const SizedBox(
                        height: 10,
                      ),
                      renderTextFormField(
                        label: '색깔',
                        onSaved: (val) {
                          setState(() {
                            color = val;
                          });
                        },
                        validator: (val) {
                          if (val.length < 1) {
                            return '색깔은 필수사항입니다.';
                          }
                          return null;
                        },
                      ),
                      renderTextFormField(
                        label: '종류',
                        onSaved: (val) {
                          setState(() {
                            type = val;
                          });
                        },
                        validator: (val) {
                          if (val.length < 1) {
                            return '종류는 필수사항입니다.';
                          }
                          return null;
                        },
                      ),
                      renderButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  renderButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200]),
      onPressed: () async {
        if (tagKey.currentState!.validate()) {
          tagKey.currentState!.save();
          _setImageTagResult();
          print(tagResult);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('코디 생성중... 잠시만 기다려주세요.'),
              duration: Duration(seconds: 12),
            ),
          );

          String imageUrl = await _imageApi.generateImage(tagResult, File(_imageFile!.path), 'assets/image/mask.png');
          if(imageUrl != ''){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('코디 생성 완료.'),
              ),
            );
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageDisplayPage(imageUrl)));
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('코디 생성 실패.'),
              ),
            );
          }
          //Navigator.pop(context, true);
        }
      },
      child: const Text(
        '코디 생성',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  renderTextFormField({
    required String label,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
    String? thickness,
  }) {
    if (label == '색깔') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ColorSelection(
                  onSaved: onSaved,
                ),
              ),
            ],
          ),
          Container(
            height: 16.0,
          ),
        ],
      );
    } else if (label == '종류') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TypeSelection(
                  onSaved: onSaved,
                ),
              ),
            ],
          ),
          Container(
            height: 16.0,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: TextFormField(
                    onSaved: onSaved,
                    validator: validator,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 16.0,
          ),
        ],
      );
    }
  }
}
