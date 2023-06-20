import 'package:crush_client/closet/model/cloth_model.dart';
import 'package:crush_client/closet/view/cloth_recommend/cloth_recommend_init.dart';
import 'package:crush_client/common/const/colors.dart';
import 'package:crush_client/common/layout/default_layout.dart';
import 'package:crush_client/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/cloth_grid_view.dart';

class ClosetPage extends StatefulWidget {
  const ClosetPage({super.key});

  @override
  State<ClosetPage> createState() => _ClosetPageState();
}

@override
class _ClosetPageState extends State<ClosetPage>
    with SingleTickerProviderStateMixin {
  List<Cloth> clothList = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  Future<List<Cloth>> initCloset() async {
    final clothList = await RepositoryProvider.of<FirestoreRepository>(context)
        .getClothList(
            uid: RepositoryProvider.of<AuthenticationRepository>(context)
                .currentUser);
    return clothList;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _clothesByTypeWrapper(String type) {
    return ClothGridView(type);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '나의 옷장',
      helpContent:  "내가 가진 옷을 가상 옷장에 등록해보세요!\n"
                    "가상 옷장에 등록된 옷들을 바탕으로\n"
                    "나에게 어울리는 옷을 추천해드립니다.",
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: TabBar(
                    indicator: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        side: BorderSide(width: 0.5, color: Colors.grey),
                      ),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.fromLTRB(0, -2, 0, 2),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                    controller: _tabController,
                    tabs: const [
                      Tab(text: '전체'),
                      Tab(text: '상의'),
                      Tab(text: '하의'),
                      Tab(text: '기타'),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[300],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _clothesByTypeWrapper('전체'),
                  _clothesByTypeWrapper('상의'),
                  _clothesByTypeWrapper('하의'),
                  _clothesByTypeWrapper('기타'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: PRIMARY_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ClothRecommendInit()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(CupertinoIcons.paperplane_fill,
                            color: INPUT_BG_COLOR),
                        SizedBox(width: 10),
                        Text(' 옷 추천', style: TextStyle(fontSize: 16)),
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
}
