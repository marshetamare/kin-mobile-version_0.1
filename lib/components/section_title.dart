import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';

import '../size_config.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: title,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: press,
            child: const Text(
              "See All",
              style: TextStyle(color: kGrey),
            ),
          ),
        ],
      ),
    );
  }
}
