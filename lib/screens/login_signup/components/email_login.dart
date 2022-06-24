import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/custom_bottom_app_bar.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/login_signup/components/acc_alt_option.dart';
import 'package:kin_music_player_app/screens/login_signup/components/custom_elevated_button.dart';
import 'package:kin_music_player_app/components/kin_form.dart';
import 'package:kin_music_player_app/services/network/regi_page.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:kin_music_player_app/screens/login_signup/components/reusable_divider.dart';
import 'package:kin_music_player_app/screens/login_signup/components/social_login.dart';
import 'package:kin_music_player_app/size_config.dart';

class EmailLogin extends StatefulWidget {
  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

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
                hint: 'Enter your  username or email',
                headerTitle: 'Email',
                controller: email,
              ),
              KinForm(
                hint: 'Enter your password',
                headerTitle: 'Password',
                controller: password,
                obscureText: true,
                hasIcon: true,
              ),
              SizedBox(height: getProportionateScreenHeight(35)),
              Consumer<LoginProvider>(
                builder: (context, provider, _) {
                  if(provider.isLoading){
                    return  Center(child: KinProgressIndicator(),);
                  }
                  return CustomElevatedButton(
                      onTap: () async {
                        if (email.text.isNotEmpty && password.text.isNotEmpty) {
                          var user = {
                            'email': email.text,
                            'password': password.text
                          };
                          var result = await provider.login(json.encode(user));
                          if (result == 'Successfully Logged In') {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CustomBottomAppBar()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('invalid email or password please  try again!',
                               style: TextStyle(
                                color: Color.fromARGB(255, 248, 163, 5),
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                decoration: TextDecoration.none),
                              ),
                            ));
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Please Fill all Field'),
                          ));
                        }
                      },
                      text: 'Login');
                },
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
      ),
    );
  }
}
