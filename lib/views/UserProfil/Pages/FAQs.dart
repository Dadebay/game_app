// ignore_for_file: file_names

import 'package:game_app/constants/index.dart';
import 'package:game_app/models/UserModels/AboutUsModel.dart';

class FAQs extends StatelessWidget {
  const FAQs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryColorBlack,
        appBar: const MyAppBar(backArrow: true, fontSize: 0.0, elevationWhite: true, iconRemove: true, name: "questions"),
        body: FutureBuilder<List<FAQModel>>(
            future: FAQModel().getFAQ(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: spinKit());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error"));
              } else if (snapshot.data == null) {
                return const Center(child: Text("Empty"));
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionTile(
                    title: Text(
                      Get.locale?.languageCode == "tr" ? snapshot.data![index].title_tm! : snapshot.data![index].title_ru!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: josefinSansMedium,
                        fontSize: 18,
                      ),
                    ),
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    childrenPadding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 12),
                    children: [
                      Text(
                        Get.locale?.languageCode == "tr" ? snapshot.data![index].content_tm! : snapshot.data![index].content_ru!,
                        style: const TextStyle(color: Colors.white70, fontSize: 16, fontFamily: josefinSansRegular),
                      )
                    ],
                  );
                },
              );
            }));
  }
}