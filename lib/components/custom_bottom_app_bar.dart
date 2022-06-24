import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/now_playing_music_indicator.dart';
import 'package:kin_music_player_app/components/now_playing_podcast_indicator.dart';
import 'package:kin_music_player_app/components/now_playing_radio_indicator.dart';
import 'package:kin_music_player_app/screens/playlist/playlist.dart';
import 'package:kin_music_player_app/screens/podcast/podcast.dart';
import 'package:kin_music_player_app/screens/radio.dart';
import 'package:kin_music_player_app/screens/settings/settings.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import '../screens/home/home_screen.dart';
import '../constants.dart';
import 'custom_animated_bottom_bar.dart';
import 'package:provider/provider.dart';

class CustomBottomAppBar extends StatefulWidget {
  static String routeName = "/bottomAppBar";

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}
class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  int _currentIndex = 0;
  final _inactiveColor = Color.fromARGB(255, 71, 9, 216);
  List<Widget> pages = [
    HomeScreen(),
    const PlayLists(),
    const Podcast(),
    const RadioScreen(),
  // const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool willLeave = false;
        await showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  backgroundColor: kPrimaryColor,
                  title: Text(
                    'Do you want to exit from Kin music app?',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          willLeave = true;
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: kSecondaryColor),
                        )),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('No',
                            style: TextStyle(color: kSecondaryColor)))
                  ],
                ));
        return willLeave;
      },
      child: Scaffold(body: getBody(), bottomNavigationBar: _buildBottomBar()),
    );
  }



  Widget _buildBottomBar() {
    final musicProvider = Provider.of<MusicPlayer>(context);
    final podcastProvider = Provider.of<PodcastPlayer>(context);
    final radioProvider = Provider.of<RadioProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            PlayerBuilder.isPlaying(
              player: musicProvider.player,
              builder: (context, isPlaying) {
                return musicProvider.currentMusic == null
                    ? Container()
                    : musicProvider.isMusicInProgress(
                                musicProvider.currentMusic!) ||
                            musicProvider.isMusicLoaded
                        ? Visibility(
                            visible: musicProvider.miniPlayerVisibility,
                            child: NowPlayingMusicIndicator())
                        : Container();
              },
            ),
            PlayerBuilder.isPlaying(
              player: podcastProvider.player,
              builder: (context, isPlaying) {
                return podcastProvider.currentEpisode == null
                    ? Container()
                    : podcastProvider.isEpisodeInProgress(
                                podcastProvider.currentEpisode!) ||
                            podcastProvider.isEpisodeLoaded
                        ? Visibility(
                            visible: podcastProvider.miniPlayerVisibility,
                            child: NowPlayingPodcastIndicator())
                        : Container();
              },
            ),
            Visibility(
              child: const NowPlayingRadioIndicator(),
              visible: radioProvider.miniPlayerVisibility,
            )
          ],
        ),
        CustomAnimatedBottomBar(
          containerHeight: 60,
          backgroundColor:kSecondaryColor,
          selectedIndex: _currentIndex,
          showElevation: true,
          itemCornerRadius: 24,
          curve: Curves.easeIn,
          onItemSelected: (index) {
            if (index == 1) {
              setState(() {
                pages.removeAt(1);
                pages.insert(1, PlayLists());
              });
            }
            if (index == 3) {
              setState(() {
                pages.removeAt(3);
                pages.insert(3, RadioScreen());
              });
            }
            setState(() => _currentIndex = index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
              activeColor: Colors.white,
              inactiveColor: Colors.green,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.queue_music),
              title: const Text(
                'Playlist ',
              ),
              activeColor: Colors.white,
              inactiveColor: Colors.green,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.podcasts),
              title: const Text('Podcast'),
              activeColor: Colors.white,
              inactiveColor:  Colors.green,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.radio),
              title: const Text('Radio'),
               activeColor: Colors.white,
              inactiveColor: Colors.green,
              textAlign: TextAlign.center,
            ),
            // BottomNavyBarItem(
            //   icon: const Icon(Icons.person),
            //   title: const Text('Account'),
            //   activeColor: kSecondaryColor,
            //   inactiveColor: _inactiveColor,
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ],
    );
  }

  Widget getBody() {
    return IndexedStack(
      children: pages,
      index: _currentIndex,
      
    );
  }
}
