import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kin_music_player_app/screens/genre/genre.dart';
import 'package:kin_music_player_app/screens/home/components/button_widget.dart';
import 'package:kin_music_player_app/screens/home/components/favorite.dart';
import 'package:kin_music_player_app/screens/home/components/home_search_screen.dart';
import 'package:kin_music_player_app/screens/home/components/menu.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../screens/album/album.dart';
import '../../size_config.dart';
import '../../screens/artist/artist.dart';

import 'components/songs.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggedIn = false;

  Future<bool> checkIfAuthenticated() async {
    final provider = Provider.of<LoginProvider>(context, listen: false);
    var isLoggedIn = await provider.isLoggedIn();
    if (isLoggedIn) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
       drawer: NavigationDrawerWidget(),
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kLightSecondaryColor,
           leading: IconButton(
              onPressed: () {Scaffold.of(context).openDrawer();},
              icon: Icon(Icons.menu),
           ),
          elevation: 2,
           actions: [
            //  Padding(
            //     padding: EdgeInsets.only(top: getProportionateScreenHeight(8),right: MediaQuery.of(context).size.width/3),                
            //        child:Image.asset('assets/images/logo.png',height: 30,width: 30,),),
            // Padding(
            //     padding: EdgeInsets.only(top: getProportionateScreenHeight(8)),
            //     child: IconButton(
            //         onPressed: () {
            //           Navigator.pushNamed(context, HomeSearchScreen.routeName);
            //         },
            //         icon: const Hero(
            //           tag: 'search',
            //           child: Icon(
            //             Icons.search,
            //             color: Colors.white,
            //           ),
            //         ))),
            // Padding(
            //   padding: EdgeInsets.only(top: getProportionateScreenHeight(8),right: 8),
            //   child: GestureDetector(
            //     onTap: () {
            //       Navigator.pushNamed(context, Favorite.routeName);
            //     },
            //     child: SvgPicture.asset(
            //       'assets/icons/favorite.svg',
            //       height: getProportionateScreenHeight(30),
            //       color: kSecondaryColor,
            //     ),
            //   ),
            // ),
            
           
      //     Padding(              
      //  padding: EdgeInsets.only(top: 8, left: 3, right: (MediaQuery.of(context).size.width)/0.5),
      //   child: ButtonWidget(
                 
      //                icon: Icons.menu, 
      //                onClicked: () {  Scaffold.of(context).openDrawer(); }, text: '',
                        
      //      ),
      //     ),
          
                Padding(              
                padding: EdgeInsets.only(
                top: 8, left: 3, right: (MediaQuery.of(context).size.width)/2.5),
                child: IconButton(
                 color:Colors.black,
                    onPressed: () {
                        Navigator.pushNamed(context, HomeSearchScreen.routeName);
                        },
                     icon: const Hero(
                      tag: 'menu',
                      child:  Image(
                        image: AssetImage(
                         'assets/images/logo.png', 
                                                 
                        ),
                        
                        )   
                                             
                        )
                        
                        )
                        
                          ),
                        IconButton(
                        icon: const Icon(Icons.search),
                        tooltip: 'type to search music ',
                        onPressed: () {
                           Navigator.pushNamed(context, HomeSearchScreen.routeName);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                                'you can search by name of artist or music title'))
                                
                                );
                      },
                    ),

                  ],
          bottom: const TabBar(
            
            tabs: [
              Tab(
                text: 'Musics',
              ),
              Tab(
                text: 'Albums',
              ),
              Tab(
                text: 'Artists',
              ),
              Tab(
                text: 'Genres',
              ),
            ],
            indicatorColor: kSecondaryColor,
          ),
        ),
        body: TabBarView(children: [
          Songs(),
          const Albums(),
          const Artists(),
          const Genres(),
        ]),
      ),
    );
  }
}
