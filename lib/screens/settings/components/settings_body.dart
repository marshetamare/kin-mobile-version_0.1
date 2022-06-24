import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/settings/components/user_accout_header.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/size_config.dart';

import 'settings_card.dart';
class SettingsBody extends StatelessWidget {
  const SettingsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: getCompanyProfile('/company/profile'),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasData){
              return Column(mainAxisAlignment: MainAxisAlignment.center ,
                children: [
                  UserAccountHeader(logo: snapshot.data.companyLogo),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  SettingsCard(
                      title: 'Privacy Policy',
                      iconData: Icons.verified_user,
                      data: snapshot.data.companyPrivacy),
                  SettingsCard(
                      title: 'Terms of Service',
                      iconData: Icons.gavel,
                      data: snapshot.data.companyTerms),
                  SettingsCard(
                      title: 'Help and Support',
                      iconData: Icons.help,
                      data: snapshot.data.companyHelp),
                  const SettingsCard(title: 'Logout', iconData: Icons.logout,),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child:

                   Text(
                        'Powered By KinIdeas',
                        style: TextStyle(color: Colors.yellow.shade700),

                    ),
                  )
                ],
              );
            }
            return const Center(child: Text('Unable To Load',style: TextStyle(color: Colors.white),),);

          }
          return const Center(child: CircularProgressIndicator());
          }


      ),
    );
  }
}
