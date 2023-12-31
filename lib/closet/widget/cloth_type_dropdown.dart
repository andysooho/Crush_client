import 'package:flutter/material.dart';

class TypeSelection extends StatefulWidget {
  final ValueChanged<String> onSaved;

  const TypeSelection({Key? key, required this.onSaved}) : super(key: key);

  @override
  TypeSelectionState createState() => TypeSelectionState();
}

class TypeSelectionState extends State<TypeSelection> {
  String selectedTypeName = '티셔츠';

  final List<Map<String, dynamic>> Types = [
    {'name': '티셔츠'},
    {'name': '상의'},
    {'name': '맨투맨'},
    {'name': '후드티'},
    {'name': '셔츠'},
    {'name': '니트'},
    {'name': '가디건'},
    {'name': '자켓'},
    {'name': '블레이저'},
    {'name': '롱코트'},
    {'name': '패딩'},
    {'name': '바람막이'},
    {'name': '하의'},
    {'name': '청바지'},
    {'name': '슬랙스'},
    {'name': '조거팬츠'},
    {'name': '액세서리'},
    {'name': '신발'},
    {'name': '안경'},
    {'name': '기타'},
  ];

  bool showTypePicker = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              showTypePicker = !showTypePicker;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                selectedTypeName,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8.0),
              const Icon(
                Icons.arrow_drop_down,
                size: 24.0,
              ),
            ],
          ),
        ),
        showTypePicker
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: Types.map((Type) {
                    return SizedBox(
                      width: 80,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTypeName = Type['name'];
                            widget.onSaved(Type['name']);
                            showTypePicker = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 8),
                          backgroundColor: selectedTypeName == Type['name']
                              ? Colors.grey[200]
                              : Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              color: Colors.grey[50] as Color,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Type['name'],
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            : Container(),
      ],
    );
  }
}
