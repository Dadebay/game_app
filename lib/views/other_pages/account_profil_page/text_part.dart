import 'package:cached_network_image/cached_network_image.dart';
import 'package:game_app/constants/index.dart';
import 'package:game_app/controllers/settings_controller.dart';
import 'package:game_app/models/accouts_for_sale_model.dart';

class CustomFlexibleSpace extends StatelessWidget {
  const CustomFlexibleSpace({Key? key, required this.model}) : super(key: key);
  final AccountByIdModel model;
  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          imagePart(model),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            child: Text(
              model.bio ?? "",
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontFamily: josefinSansRegular, fontSize: 16),
            ),
          ),
          Container(
            color: kPrimaryColorBlack,
            height: 70,
            margin: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                rowText(model.price!.substring(0, model.price!.length - 3), "accountPrice".tr, true),
                VerticalDivider(
                  color: Colors.white.withOpacity(0.8),
                  thickness: 1,
                ),
                rowText(model.pointsFromTurnir!.substring(0, model.pointsFromTurnir!.length - 3), "accountTurnirPoint".tr, false),
                VerticalDivider(
                  color: Colors.white.withOpacity(0.8),
                  thickness: 1,
                ),
                Obx(() {
                  return rowText(Get.find<SettingsController>().pubgType.value.toString(), "accountPubgType".tr, false);
                }),
              ],
            ),
          ),
          const SizedBox(
            height: kToolbarHeight,
          )
        ],
      ),
    );
  }

  Expanded imagePart(AccountByIdModel model) {
    return Expanded(
      flex: 4,
      child: Stack(
        children: [
          Positioned.fill(
            bottom: 70,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              child: CachedNetworkImage(
                  fadeInCurve: Curves.ease,
                  imageUrl: "$serverURL${model.bgImage ?? ""}",
                  imageBuilder: (context, imageProvider) => Container(
                        width: Get.size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  placeholder: (context, url) => Center(child: spinKit()),
                  errorWidget: (context, url, error) => Image.asset(
                        accountBackImage,
                        fit: BoxFit.cover,
                      )),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 110,
                    width: 110,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: kPrimaryColorBlack),
                    padding: const EdgeInsets.all(8),
                    child: ClipOval(
                      child: CachedNetworkImage(
                          fadeInCurve: Curves.ease,
                          imageUrl: "$serverURL${model.image ?? ""}",
                          imageBuilder: (context, imageProvider) => Container(
                                width: Get.size.width,
                                decoration: BoxDecoration(
                                  borderRadius: borderRadius15,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          placeholder: (context, url) => Center(child: spinKit()),
                          errorWidget: (context, url, error) => Container(
                                color: Colors.white.withOpacity(0.2),
                                child: Center(
                                    child: Text(
                                  "noImage".tr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white, fontFamily: josefinSansSemiBold),
                                )),
                              )),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${model.firsName ?? ""} ${model.lastName ?? ""}",
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontFamily: josefinSansSemiBold, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            model.phone ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey, fontFamily: josefinSansRegular, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Expanded rowText(String text1, String text2, bool price) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        price
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(text1,
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18,
                        fontFamily: josefinSansSemiBold,
                      )),
                  const Text(" TMT",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 13,
                        fontFamily: josefinSansSemiBold,
                      )),
                ],
              )
            : Text(
                text1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(color: kPrimaryColor, fontSize: 18, fontFamily: josefinSansMedium),
              ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            text2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(color: Colors.white, fontSize: 17, fontFamily: josefinSansRegular),
          ),
        ),
      ],
    ));
  }
}
