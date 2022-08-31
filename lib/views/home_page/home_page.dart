import 'package:game_app/cards/home_page_card.dart';
import 'package:game_app/constants/index.dart';
import 'package:game_app/controllers/home_page_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/index_model.dart';
import 'Banners.dart';
import 'pubg_types.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageController homePageController = Get.put(HomePageController());
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    homePageController.list.clear();
    homePageController.pageNumber.value = 1;
    homePageController.text.value = "Yokary Cekin";
    AccountsForSaleModel().getAccounts(parametrs: {"page": "${homePageController.pageNumber}", "size": "10"});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      homePageController.pageNumber.value += 1;
      AccountsForSaleModel().getAccounts(parametrs: {"page": "${homePageController.pageNumber}", "size": "10"});
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: kPrimaryColorBlack,
          appBar: const MyAppBar(fontSize: 0, backArrow: false, iconRemove: true, name: "Pubg House", elevationWhite: false),
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
                listViewName("pubgTypes".tr, false),
                PubgTypes(future: homePageController.futurePubgType),
                listViewName("accountsForSale".tr, true),
                Obx(() {
                  if (homePageController.list.isEmpty && homePageController.loading.value == 0) {
                    return waitingData();
                  } else if (homePageController.loading.value == 2) {
                    return cannotLoadData(false);
                  } else if (homePageController.list.isEmpty && homePageController.loading.value != 1) {
                    return cannotLoadData(true);
                  }
                  return ListView.builder(
                    itemCount: homePageController.list.length,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return HomePageCard(vip: homePageController.list[index].vip ?? false, model: homePageController.list[index]);
                    },
                  );
                }),
              ],
            ),
          )),
    );
  }
}