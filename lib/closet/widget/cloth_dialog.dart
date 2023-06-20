import 'package:flutter/material.dart';
import 'package:crush_client/closet/model/cloth_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crush_client/repositories/repositories.dart';

void showClothDialog(BuildContext context, Cloth cloth) {
  const defaultImage =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrVqTt0O2Wb_AijJ2MgpH162DTExM55h0Wmg&usqp=CAU';
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return SafeArea(
        top: true,
        bottom: false,
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFE5E5E5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '뒤로',
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ), // 뒤로 버튼
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Builder(
                            builder: (context) {
                              final imageUrl = cloth.imageURL.isEmpty ? defaultImage : cloth.imageURL;
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(32.0),
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height * 0.55,
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(32.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black26,
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(32.0),
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ); //이미지

                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            cloth.name,
                            style: const TextStyle(
                              fontSize: 35.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            const SizedBox(width: 16.0),
                            const Text(
                              '종류  ',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            //const SizedBox(width: 8.0),
                            Text(
                              cloth.type,
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            const SizedBox(width: 16.0),
                            const Text(
                              '색상  ',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            //const SizedBox(width: 8.0),
                            Text(
                              cloth.color,
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            const SizedBox(width: 16.0),
                            const Text(
                              '두께  ',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              cloth.thickness,
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await RepositoryProvider.of<FirestoreRepository>(
                              context)
                              .removeCloth(
                              uid: RepositoryProvider.of<
                                  AuthenticationRepository>(context)
                                  .currentUser,
                              clothId: cloth.clothId);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[400],
                        ),
                        child: const Text(
                          '삭제',
                          style:
                          TextStyle(fontSize: 18.0, color: Colors.blue),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}