import 'dart:io';

import 'package:crush_client/closet/model/cloth_model.dart';
import 'package:crush_client/closet/widget/cloth_type_dropdown.dart';
import 'package:crush_client/closet/widget/my_palette_dropdown.dart';
import 'package:crush_client/closet/widget/thickness_dropdown.dart';
import 'package:crush_client/common/layout/default_layout.dart';
import 'package:crush_client/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ClothInput extends StatefulWidget {
  @override
  ClothInputState createState() => ClothInputState();
}

class ClothInputState extends State<ClothInput> {
  final ClothKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String name = '';
  String color = '검정';
  String type = '티셔츠';
  String thickness = '보통';
  XFile? _imageFile;
  Color selectedColor = Colors.white;

  void _handleColorSelected(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '옷 추가',
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
                            if (val.length < 2) {
                              return '이름은 두글자 이상 입력 해주셔야합니다.';
                            }
                            return null;
                          },
                        ),
                        renderTextFormField(
                          label: '색깔',
                          onSaved: (val) {
                            setState(() {
                              this.color = val;
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
                              this.type = val;
                            });
                          },
                          validator: (val) {
                            if (val.length < 1) {
                              return '종류는 필수사항입니다.';
                            }
                            return null;
                          },
                        ),
                        renderTextFormField(
                          label: '두께',
                          onSaved: (val) {
                            setState(() {
                              this.thickness = val;
                            });
                          },
                          validator: (val) {
                            if (val.length < 1) {
                              return '두께는 필수사항입니다.';
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
        if (this.ClothKey.currentState!.validate()) {
          this.ClothKey.currentState!.save();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('옷이 등록되었습니다.'),
            ),
          );
          RepositoryProvider.of<FirestoreRepository>(context).addCloth(
              uid: RepositoryProvider.of<AuthenticationRepository>(context)
                  .currentUser,
              image: File(_imageFile!.path),
              cloth: Cloth(
                clothId: '',
                name: name,
                color: color,
                type: type,
                thickness: thickness,
              ));

          Navigator.pop(context, true);
        }
      },
      child: const Text(
        '추가',
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
    assert(onSaved != null);
    assert(validator != null);

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
    } else if (label == '두께') {
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
                child: ThickSelection(
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
