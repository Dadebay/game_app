// ignore_for_file: file_names

import 'package:game_app/app/constants/packages/index.dart';

class Price extends StatelessWidget {
  final bool showDiscountedPrice;
  final String price;
  final String? discountedPrice;
  final int selectedIndex;
  const Price({
    required this.showDiscountedPrice,
    required this.price,
    required this.selectedIndex,
    Key? key,
    this.discountedPrice,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: showDiscountedPrice ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Text(
          price,
          style: TextStyle(
            color: Colors.black,
            fontSize: size.width >= 800 ? 27 : 25,
            fontFamily: josefinSansBold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            selectedIndex == 1 ? ' RUB' : ' TMT',
            style: TextStyle(
              color: Colors.black,
              fontSize: size.width >= 800 ? 20 : 14,
              fontFamily: josefinSansBold,
            ),
          ),
        ),
      ],
    );
  }
}
