import 'package:flutter/material.dart';

import 'package:kin_music_player_app/screens/podcast/components/new_podcasts.dart';
import 'package:kin_music_player_app/size_config.dart';

import 'category_list.dart';
import 'custom_tab_bar.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(15),
            ),
            const NewPodcasts(),
            SizedBox(
              height: getProportionateScreenHeight(25),
            ),
            const CategoryList(),
            SizedBox(
              height: getProportionateScreenHeight(15),
            ),
            PopularPodcasts()
          ],
        ),
      ),
    );
  }
}
