// ignore_for_file: file_names, must_be_immutable

import 'package:game_app/constants/index.dart';
import 'package:game_app/controllers/settings_controller.dart';
import 'package:game_app/models/user_models/user_sign_in_model.dart';

import 'otp_check.dart';

class Login extends StatelessWidget {
  TextEditingController fullNameController = TextEditingController();
  FocusNode fullNameFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController phoneNumberController = TextEditingController();
  FocusNode phoneNumberFocusNode = FocusNode();
  final login = GlobalKey<FormState>();

  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: login,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 25),
              child: Text(
                "signInDialog".tr,
                style: const TextStyle(color: Colors.white, fontFamily: josefinSansSemiBold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: PhoneNumber(
                mineFocus: phoneNumberFocusNode,
                controller: phoneNumberController,
                requestFocus: emailFocusNode,
                style: false,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AgreeButton(onTap: () {
                  if (login.currentState!.validate()) {
                    Get.find<SettingsController>().agreeButton.value = !Get.find<SettingsController>().agreeButton.value;

                    UserSignInModel().login(phone: phoneNumberController.text).then((value) {
                      if (value == true) {
                        Get.to(() => OtpCheck(
                              phoneNumber: phoneNumberController.text,
                            ));
                      } else {
                        showSnackBar("Status Code", "$value", Colors.red);
                      }
                    });
                  } else {
                    showSnackBar("Maglumatlar Doldur", "Doldur su maglumatlary", Colors.red);
                  }
                  Get.find<SettingsController>().agreeButton.value = !Get.find<SettingsController>().agreeButton.value;
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
