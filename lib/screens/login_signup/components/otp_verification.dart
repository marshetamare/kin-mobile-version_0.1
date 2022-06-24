
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/custom_bottom_app_bar.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/login_signup/components/custom_elevated_button.dart';

import '../../../size_config.dart';
import 'header.dart';

class OTPVerification extends StatefulWidget {
  static String routeName = 'otpVerification';

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: kPrimaryColor,
        key: _scaffoldKey,
        body: Stack(
          children: [

            SingleChildScrollView(
              child: Column(
                children: [
                  const Header(),
                  SizedBox(
                    height: getProportionateScreenHeight(25),
                  ),
                  Text(
                    'Enter code',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: getProportionateScreenHeight(25)),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                    margin: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(10),
                        horizontal: getProportionateScreenWidth(100)),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: kGrey, width: 1.75),
                      ),
                    ),
                    child: TextField(
                        textAlign: TextAlign.center,
                        cursorColor: kGrey,
                        style: const TextStyle(color: kGrey),
                        controller: email,
                        decoration: InputDecoration(
                            hintStyle: const TextStyle(color: kGrey),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(10),
                            ),
                            hintText: "Enter code",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            fillColor: Colors.transparent,
                            filled: true)),
                  ),
                  SizedBox(height: getProportionateScreenHeight(50)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                    child: Text(
                      "We've sent an SMS with an activation code to your phone ",
                      style: TextStyle(
                        color: kGrey,
                        fontSize: getProportionateScreenHeight(18),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(50)),
                  CustomElevatedButton(onTap: () {
                        Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CustomBottomAppBar()));

                  }, text: 'Submit'),
                ],
              ),
            ),
            Positioned(
              top: getProportionateScreenHeight(25),
              left: getProportionateScreenWidth(10),
              right: 0,
              child: Align(
                alignment: Alignment.topLeft,
                child: BackButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
