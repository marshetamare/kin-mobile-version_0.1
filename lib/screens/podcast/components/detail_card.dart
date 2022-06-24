import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/genre/components/custom_list_tile.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';

import '../../../size_config.dart';

class DetailCard extends StatelessWidget {
  final PodCast podCast;
  const DetailCard({Key? key,required this.podCast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20)),
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(15)),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomListTile(
              title: 'Duration',
              data: '${podCast.duration} min',
              iconData: Icons.timelapse,
              color: Colors.white.withOpacity(0.75)),
          SizedBox(
            width: getProportionateScreenWidth(25),
          ),
          CustomListTile(
              title: 'Episodes',
              data: '${podCast.episodes.length}',
              iconData: Icons.ondemand_video,
              color: Colors.white.withOpacity(0.75))
        ],
      ),
    );
  }
}
