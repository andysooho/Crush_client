import 'package:flutter/material.dart';
import 'package:crush_client/closet/model/cloth_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crush_client/repositories/repositories.dart';
import 'cloth_dialog.dart';

class ClothGridView extends StatelessWidget {
  const ClothGridView(this.type, {Key? key}) : super(key: key);

  final String type;

  List<String> getClothTypes(String type) {
    if (type == '상의') {
      return [
        '티셔츠',
        '맨투맨',
        '후드티',
        '셔츠',
        '니트',
        '카디건',
        '자켓',
        '블레이저',
        '롱코트',
        '패딩',
        '바람막이',
        '상의',
      ];
    } else if (type == '하의') {
      return [
        '청바지',
        '슬랙스',
        '조거팬츠',
        '하의',
      ];
    } else if (type == '기타') {
      return [
        '신발',
        '안경',
        '액세서리',
        '기타',
      ];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final clothTypes = getClothTypes(type);
    final firestoreRepository = RepositoryProvider.of<FirestoreRepository>(context);
    return StreamBuilder<List<Cloth>>(
      stream: firestoreRepository.getClothStream(
        uid: RepositoryProvider.of<AuthenticationRepository>(context).currentUser,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final clothes = snapshot.data!;
        final filteredClothes = type == '전체'
            ? clothes
            : clothes.where((cloth) => clothTypes.contains(cloth.type)).toList();

        return GridView.builder(
          itemCount: filteredClothes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (BuildContext context, int index) {
            final Cloth cloth = filteredClothes[index];
            return GestureDetector(
              onTap: () {
                showClothDialog(context, cloth);
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      cloth.imageURL,
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.35,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cloth.name,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(cloth.type),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
