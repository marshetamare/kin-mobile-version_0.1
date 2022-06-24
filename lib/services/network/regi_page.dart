import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kin_music_player_app/components/custom_bottom_app_bar.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/login_signup/components/acc_alt_option.dart';
import 'package:kin_music_player_app/screens/login_signup/components/custom_elevated_button.dart';
import 'package:kin_music_player_app/screens/login_signup/components/reusable_divider.dart';
import 'package:kin_music_player_app/screens/login_signup/components/social_login.dart';
import 'package:kin_music_player_app/services/network/model/user.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

import '../../size_config.dart';
import '../../screens/login_signup/components/header.dart';

class RegPage extends StatefulWidget {
  static String routeName = 'regPage';

  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  static String routeName = 'signUp';

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneName = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool obscureText = false;
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: getProportionateScreenHeight(35)),
                          _buildKinForm(
                            context,
                            hint: 'Enter your full name',
                            controller: fullName,
                            headerTitle: 'Full name',
                          ),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          _buildKinForm(
                            context,
                            hint: 'Enter your  username or email',
                            controller: email,
                            headerTitle: 'Email',
                          ),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          _buildKinForm(
                            context,
                            hint: 'Enter your phone number (09..)',
                            controller: phoneName,
                            headerTitle: 'Phone number',
                          ),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          _buildKinForm(context,
                              hint: 'Enter password',
                              controller: password,
                              headerTitle: 'Password',
                              hasIcon: true, onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          }),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          _buildKinForm(context,
                              hint: 'Confirm your password',
                              controller: confirmPassword,
                              headerTitle: 'Confirm password',
                              hasIcon: true, onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          })
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(35)),
                  Consumer<LoginProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading) {
                        return Center(child: KinProgressIndicator());
                      }
                      return CustomElevatedButton(
                          onTap: () async {
                            var validate = validateEmail(email.text);
                            var result = '';
                            if (_formKey.currentState!.validate()) {
                              final provider = Provider.of<LoginProvider>(
                                  context,
                                  listen: false);
                              // if (validate != null) {
                              var result = await provider.register(User(
                                  name: fullName.text,
                                  id: 2,
                                  phoneNumber: phoneName.text,
                                  email: email.text,
                                  password: password.text,
                                  passwordConfirmation: confirmPassword.text));

                              if (result == 'Successfully Registered') {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomBottomAppBar()));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(result),
                                ));
                              }
                            }
                          },
                          text: 'Signup');
                    },
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(25),
                  ),
                  const ReusableDivider(),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  const SocialLogin(),
                  AccAltOption(
                      buttonText: 'Login',
                      leadingText: 'Do you have account ?',
                      onTap: () {
                        Navigator.pop(context);
                      }),
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  )
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
                  color: Color.fromARGB(255, 255, 255, 255),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          ],
        ));
  }

  _buildKinForm(context,
      {hasIcon = false,
      headerTitle,
      hint,
      controller,
      GestureTapCallback? onPressed}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      margin: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(10),
          horizontal: getProportionateScreenWidth(15)),
      decoration: const BoxDecoration(
          border: Border(
              // bottom: BorderSide(color: kGrey, width: 1.75),
              )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            headerTitle!,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                decoration: TextDecoration.none),
          ),
          TextFormField(
              maxLength: headerTitle == 'Phone number' ? 10 : null,
              keyboardType: headerTitle == 'Phone number'
                  ? TextInputType.phone
                  : TextInputType.name,
              inputFormatters: [
                headerTitle == 'Phone number'
                    ? FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    : FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z@.0-9]')),
              ],
              autocorrect: false,
              enableSuggestions: false,
              validator: (value) {
                if (value!.isEmpty && !(headerTitle == 'Phone number')) {
                  return 'Empty field is not valid';
                }
                if (headerTitle == 'Email' &&  validateEmail(email.text) == false) {
                  return 'please enter valid email';
                }
                if (headerTitle == 'Phone number' && value.isNotEmpty) {
                  if (value.length < 10) {
                    return 'Enter valid phone number';
                  }
                }
              },
              cursorColor: kGrey,
              style: const TextStyle(color: kGrey),
              controller: controller,
              obscureText: hasIcon ? obscureText : false,
              decoration: InputDecoration(
                  errorStyle: const TextStyle(
                      fontSize: 12, height: 0.3, color: kSecondaryColor),
                  suffixIcon: hasIcon
                      ? IconButton(
                          onPressed: onPressed,
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: kGrey,
                          ),
                        )
                      : const SizedBox(
                          width: 0,
                          height: 0,
                        ),
                  hintStyle: const TextStyle(color: kGrey),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(10),
                      vertical: getProportionateScreenHeight(10)),
                  hintText: hint,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: true)),
        ],
      ),
    );
  }
}

bool validateEmail(String val) {
  var _errorMessage = '';
  var check =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(check);
  var value = regExp.hasMatch(val);
  if (val.isEmpty) {
    _errorMessage = "Email can not be empty";
  } else if (!EmailValidator.validate(val, true)) {
    _errorMessage = "Invalid Email Address";
  } else {
    _errorMessage = '';
  }
  return value;
}
