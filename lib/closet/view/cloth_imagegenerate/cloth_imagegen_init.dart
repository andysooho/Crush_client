import 'dart:io';

import 'package:crush_client/closet/view/cloth_type.dart';
import 'package:crush_client/closet/view/my_palette.dart';
import 'package:crush_client/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ClothGenerate extends StatefulWidget {
  const ClothGenerate({super.key});

  @override
  ClothGenerateState createState() => ClothGenerateState();
}

class ClothGenerateState extends State<ClothGenerate> {
  final ClothKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String name = '';
  String color = '검정';
  String type = '티셔츠';
  String thickness = '보통';
  XFile? _imageFile;
  Color selectedColor = Colors.white;

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
            Container(
              child: Form(
                key: ClothKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        renderTextFormField(
                          label: '옷 이름',
                          onSaved: (val) {
                            setState(() {
                              name = val;
                            });
                          },
                          validator: (val) {
                            if (val.length < 1) {
                              return '이름은 필수사항입니다.';
                            }
                            return null;
                          },
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
        if (ClothKey.currentState!.validate()) {
          ClothKey.currentState!.save();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('테스트중.'),
            ),
          );
          Navigator.pop(context, true);
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
