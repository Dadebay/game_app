// ignore_for_file: missing_return, file_names, must_be_immutable, require_trailing_commas

import 'package:flutter/cupertino.dart';
import 'package:game_app/constants/index.dart';
import 'package:game_app/models/HomePageModel.dart';
import 'package:game_app/views/AddPage/AddPage.dart';
import 'package:game_app/views/HomePage/HomePage.dart';
import 'package:game_app/views/TournamentPage/Tournament.dart';

import 'views/UserProfil/UserProfil.dart';
import 'views/Wallet/WalletPage.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;

  List page = [
    const HomePage(),
    const TournamentPage(),
    Container(),
    WalletPage(),
    UserProfil(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          color: kPrimaryColorBlack,
          height: kBottomNavigationBarHeight,
          child: Row(
            children: [
              Expanded(
                  child: buttonTop(
                      color: Colors.orange,
                      icon: const Icon(
                        IconlyLight.home,
                        size: 24,
                        color: Colors.white,
                      ),
                      activeIcon: const Icon(
                        IconlyBold.home,
                        size: 24,
                        color: Colors.white,
                      ),
                      name: "bottomNavBar1".tr,
                      index: 0)),
              Expanded(
                  child: buttonTop(
                      color: Colors.orange,
                      icon: Image.asset(
                        "assets/icons/31.png",
                        color: Colors.white,
                        width: 22,
                      ),
                      activeIcon: Image.asset(
                        "assets/icons/3.png",
                        color: Colors.white,
                        width: 22,
                      ),
                      name: "bottomNavBar2".tr,
                      index: 1)),
              Expanded(
                  child: buttonTop(
                      color: Colors.orange,
                      icon: const Icon(
                        CupertinoIcons.add_circled,
                        size: 24,
                        color: Colors.white,
                      ),
                      activeIcon: const Icon(
                        CupertinoIcons.add_circled,
                        size: 24,
                        color: Colors.white,
                      ),
                      name: "add".tr,
                      index: 2)),
              Expanded(
                  child: buttonTop(
                      color: Colors.orange,
                      icon: const Icon(
                        IconlyLight.wallet,
                        size: 24,
                        color: Colors.white,
                      ),
                      activeIcon: const Icon(
                        IconlyBold.wallet,
                        size: 24,
                        color: Colors.white,
                      ),
                      name: "Pubg UC",
                      index: 3)),
              Expanded(
                  child: buttonTop(
                      color: Colors.orange,
                      icon: const Icon(
                        IconlyLight.profile,
                        size: 24,
                        color: Colors.white,
                      ),
                      activeIcon: const Icon(
                        IconlyBold.profile,
                        size: 24,
                        color: Colors.white,
                      ),
                      name: "profil".tr,
                      index: 4)),
            ],
          ),
        ),
        body: Center(
          child: page[selectedIndex],
        ));
  }

  Widget buttonTop({required Color color, required Widget icon, required Widget activeIcon, required String name, required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (index == 2) {
            firstBottomSheet();
          } else {
            selectedIndex = index;
          }
        });
      },
      child: Column(
        children: [
          Container(
            height: 2,
            decoration: BoxDecoration(color: index == selectedIndex ? color : kPrimaryColorBlack, borderRadius: BorderRadius.circular(4)),
          ),
          Expanded(
            child: AnimatedContainer(
              width: double.infinity,
              height: index == selectedIndex ? Get.size.height : 0,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                index == selectedIndex ? color.withOpacity(0.005) : Colors.transparent,
                index == selectedIndex ? color.withOpacity(0.3) : Colors.transparent,
                // Colors.indigo,
              ], stops: const [
                0.0,
                0.7
              ], begin: FractionalOffset.bottomCenter, end: FractionalOffset.topCenter, tileMode: TileMode.clamp)),
              duration: const Duration(milliseconds: 500),
              curve: Curves.decelerate,
              child: Column(
                children: [
                  Expanded(child: index == selectedIndex ? activeIcon : icon),
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontFamily: josefinSansRegular, fontSize: index == selectedIndex ? 13 : 12),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> firstBottomSheet() {
    return Get.bottomSheet(Container(
        decoration: const BoxDecoration(
          borderRadius: borderRadius15,
          color: kPrimaryColorBlack,
        ),
        margin: const EdgeInsets.all(15),
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox.shrink(),
                  Text(
                    "pubgTypes".tr,
                    style: const TextStyle(color: Colors.white, fontFamily: josefinSansSemiBold, fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(CupertinoIcons.xmark_circle, size: 24, color: Colors.white),
                  )
                ],
              ),
            ),
            customDivider(),
            FutureBuilder<List<PubgTypes>>(
              future: PubgTypes().getTypes(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: spinKit());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error"));
                } else if (snapshot.data == null) {
                  return const Center(child: Text("Empty"));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        Get.back();
                        secondBottomSheet(snapshot.data![index].id!);
                      },
                      trailing: const Icon(
                        IconlyLight.arrowRightCircle,
                        color: Colors.white,
                      ),
                      title: Text(
                        snapshot.data![index].title.toString(),
                        maxLines: 2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: josefinSansMedium,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ],
        )));
  }
}

Future<dynamic> secondBottomSheet(int pubgTypeID) {
  return Get.bottomSheet(Container(
      decoration: const BoxDecoration(
        borderRadius: borderRadius15,
        color: kPrimaryColorBlack,
      ),
      margin: const EdgeInsets.all(15),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                Text(
                  "selectCityTitle".tr,
                  style: const TextStyle(color: Colors.white, fontFamily: josefinSansSemiBold, fontSize: 18),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(CupertinoIcons.xmark_circle, size: 24, color: Colors.white),
                )
              ],
            ),
          ),
          customDivider(),
          FutureBuilder<List<Cities>>(
            future: Cities().getCities(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: spinKit());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error"));
              } else if (snapshot.data == null) {
                return const Center(child: Text("Empty"));
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      Get.back();
                      Get.to(() => AddPage(
                            pubgType: pubgTypeID,
                            locationID: snapshot.data![index].id!,
                          ));
                    },
                    trailing: const Icon(
                      IconlyLight.arrowRightCircle,
                      color: Colors.white,
                    ),
                    title: Text(
                      Get.locale!.toLanguageTag().toString() == "tr" ? snapshot.data![index].name_tm.toString() : snapshot.data![index].name_ru.toString(),
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: josefinSansMedium,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      )));
}