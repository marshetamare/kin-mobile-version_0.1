import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/login_signup/components/email_login.dart';
import 'package:kin_music_player_app/screens/login_signup/components/phone_number_login.dart';


class LoginSignupTabBar extends StatefulWidget {
  const LoginSignupTabBar({Key? key}) : super(key: key);

  @override
  State<LoginSignupTabBar> createState() => _LoginSignupTabBarState();
}

class _LoginSignupTabBarState extends State<LoginSignupTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 45,
         width:(MediaQuery.of(context).size.width),
          child: PhysicalModel(
            color: Colors.transparent,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              indicatorColor: kSecondaryColor,
              unselectedLabelColor: kGrey,
              labelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
              tabs: const [
                Tab(
                  text: 'Username or  Email Login',
                ),
                Tab(
                  text: 'Phone number Login',
                ),
              ],
            ),
          ),
        ),
        // tab bar view here
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              EmailLogin(),
              PhoneNumberLogin(),
            ],
          ),
        ),
      ],
    );
  }
}
