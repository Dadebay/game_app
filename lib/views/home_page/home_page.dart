import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:game_app/controllers/home_page_controller.dart';
import 'package:game_app/models/home_page_model.dart';
import 'package:game_app/views/constants/index.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/get_posts_model.dart';
import '../../models/user_models/auth_model.dart';
import '../../models/user_models/user_sign_in_model.dart';
import '../cards/home_page_card.dart';
import 'Banners.dart';
import 'pubg_types.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageController homePageController = Get.put(HomePageController());

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    getMe();
    homePageController.futureBanner = BannerModel().getBanners();
  }

  late String dateTurnir;

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {}
    _refreshController.loadComplete();
  }

  Future<GetMeModel> getMe() async {
    final token = await Auth().getToken();
    final response = await http.get(
      Uri.parse(
        '$serverURL/api/accounts/get-my-account/',
      ),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final responseJson = json.decode(decoded);
      final bool blocked = responseJson['blocked'] ?? false;
      if (blocked == true) {
        await showDialog(
          context: context,
          builder: (ctxt) => AlertDialog(
            backgroundColor: kPrimaryColorBlack,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 20),
                child: Column(
                  children: [
                    const Text('Ünus Beriň!'),
                    const Text(
                      'Siz Bloсklandyňyz!',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      responseJson['block_reason'],
                      style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal, fontFamily: josefinSansRegular),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      dateTurnir.toString(),
                      style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.normal, fontFamily: josefinSansRegular),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      return GetMeModel.fromJson(responseJson);
    } else {
      return GetMeModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColorBlack,
        appBar: const MyAppBar(fontSize: 0, backArrow: false, iconRemove: true, name: appName, elevationWhite: false),
        body: SmartRefresher(
          footer: footer(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          enablePullDown: true,
          enablePullUp: true,
          physics: const BouncingScrollPhysics(),
          header: const MaterialClassicHeader(
            color: kPrimaryColor,
          ),
          child: ListView(
            children: [
              Banners(future: homePageController.futureBanner),
              listViewName('pubgTypes'.tr, false, size),
              PubgTypes(),
              listViewName('accountsForSale'.tr, true, size),
              FutureBuilder<List<GetPostsAccountModel>>(
                future: GetPostsAccountModel().getVIPPosts(parametrs: {}),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(margin: const EdgeInsets.all(8), height: 220, width: Get.size.width, decoration: BoxDecoration(borderRadius: borderRadius15, color: Colors.grey.withOpacity(0.4)), child: Center(child: spinKit()));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('errorLoadData'.tr));
                  } else if (snapshot.data.toString() == '[]') {
                    return Center(child: Text('errorLoadEmptyData'.tr));
                  }
                  return size.width >= 800
                      ? GridView.builder(
                          itemCount: snapshot.data!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 3 / 4),
                          itemBuilder: (BuildContext context, int index) {
                            return HomePageCard(vip: true, model: snapshot.data![index]);
                          },
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return HomePageCard(vip: true, model: snapshot.data![index]);
                          },
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
