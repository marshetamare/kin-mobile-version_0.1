import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/login_signup/components/acc_alt_option.dart';
import 'package:kin_music_player_app/screens/login_signup/components/custom_elevated_button.dart';
import 'package:kin_music_player_app/components/kin_form.dart';
import 'package:kin_music_player_app/screens/login_signup/components/otp_verification.dart';
import 'package:kin_music_player_app/screens/login_signup/components/reusable_divider.dart';
import 'package:kin_music_player_app/screens/login_signup/components/social_login.dart';
import 'package:kin_music_player_app/services/network/regi_page.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class PhoneNumberLogin extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController phoneNumber = TextEditingController();

  PhoneNumberLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: kPrimaryColor,
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: getProportionateScreenHeight(35)),
                KinForm(
                    hint: 'Enter your phone number', controller: phoneNumber),
                SizedBox(height: getProportionateScreenHeight(35)),
                CustomElevatedButton(
                    onTap: () {
                      Navigator.pushNamed(context, OTPVerification.routeName);
                    },
                    text: 'Submit'),
                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),
                const ReusableDivider(),
                SizedBox(height: getProportionateScreenHeight(10)),
                const SocialLogin(),
                AccAltOption(
                    buttonText: 'Register',
                    leadingText: 'Don\'t have an account ?',
                    onTap: () {
                      Navigator.pushNamed(context, RegPage.routeName);
                    }),
              ],
            ),
          ),
        ));
  }
}
