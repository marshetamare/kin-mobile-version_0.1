import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/home/components/menu.dart';
import 'package:kin_music_player_app/screens/podcast/components/podcast_search_screen.dart';

import '../../size_config.dart';
import 'components/body.dart';

class Podcast extends StatelessWidget {
  const Podcast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
       backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text('Podcast'),
        automaticallyImplyLeading: false,
        leading: IconButton(
              onPressed: () {Scaffold.of(context).openDrawer();},
              icon: Icon(Icons.menu),
           ),
       backgroundColor: kSecondaryColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(top: getProportionateScreenHeight(8),),
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, PodcastSearchScreen.routeName);
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                )),
          ),
        ],
      

      ),
      body: const Body(),
    );
  }
}
