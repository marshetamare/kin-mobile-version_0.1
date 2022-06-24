import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/genre_card.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/genre.dart';

import '../../size_config.dart';

class Genres extends StatelessWidget {
  const Genres({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getGenres('/music/genres'),
     builder: (context, AsyncSnapshot<List<Genre>> snapshot){
       if(snapshot.connectionState == ConnectionState.done) {
         if(snapshot.hasData){
           List<Genre> genres = snapshot.data!;

           return GridView.builder(
             itemCount: genres.length,
               padding: EdgeInsets.symmetric(
                   horizontal: getProportionateScreenHeight(25),
                   vertical: getProportionateScreenHeight(25)),
               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 2,
                   childAspectRatio: 0.8,
                   crossAxisSpacing: getProportionateScreenWidth(15),
                   mainAxisSpacing: 20), itemBuilder: (context, index) {
             return GenreCard(genre: genres[index]);
           });
         }
         return const Center(child: Text('No Data'));
       }
       return  Center(child: KinProgressIndicator());
     },
    );

  }
}
