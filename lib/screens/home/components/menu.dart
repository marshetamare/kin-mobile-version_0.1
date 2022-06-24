import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/artist/artist.dart';
import 'package:kin_music_player_app/screens/home/components/favorite.dart';
import 'package:kin_music_player_app/screens/playlist/playlist.dart';
import 'package:kin_music_player_app/screens/podcast/podcast.dart';
import 'package:kin_music_player_app/screens/settings/components/settings_card.dart';
import 'package:kin_music_player_app/screens/settings/settings.dart';
import 'package:kin_music_player_app/services/network/model/artist.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:kin_music_player_app/components/custom_bottom_app_bar.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  String accountEmail = '';

  String accountName = '';

  @override
  Widget build(BuildContext context) {
    String name = 'kin muisic';
    String email = 'kinuser@gmail.com';

    final urlImage = '../../../assets/images/logo.png';

    return Drawer(
      child: Material(
        color:Color.fromARGB(255, 36, 35, 33),
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Settings(),
              )),
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  buildSearchField(),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'musicians',
                    icon: Icons.people,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Favourites',
                    icon: Icons.favorite_border,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'my playlist',
                    icon: Icons.list_alt_rounded,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  buildMenuItem(
                    text: 'setting',
                    icon: Icons.settings,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'podcasts',
                    icon: Icons.podcasts,
                    onClicked: () => selectedItem(context, 4),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'payment',
                    icon: Icons.payment,
                    onClicked: () => selectedItem(context, 5),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Notifications',
                    icon: Icons.notifications,
                    onClicked: () => selectedItem(context, 6),
                  ),
                  // buildMenuItem(
                  //   text: 'about',
                  //   icon: Icons.info,
                  //   onClicked: () => selectedItem(context, 7),
                  // ),
               
             Column(mainAxisAlignment: MainAxisAlignment.center ,
                children: [
              
                  const SettingsCard(title: 'Logout', iconData: Icons.logout,),
                  
                ],
              ),
            
           

                         
                   
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
         padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              const CircleAvatar(radius: 30, 
              backgroundColor:Colors.black,
              backgroundImage: 
                         AssetImage(
                         'assets/images/logo.png',                         
                        ),
                        ) ,
                      
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              Spacer(),
              CircleAvatar(
                radius: 24,
                backgroundColor: Color.fromARGB(255, 168, 92, 30),
                child: Icon(Icons.edit, color: Colors.white),
              )
            ],
          ),
        ),
      );

  Widget buildSearchField() {
    final color = Colors.white;

    return TextField(
      style: TextStyle(color: color),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: 'Search',
        hintStyle: TextStyle(color: color),
        prefixIcon: Icon(Icons.search, color: color),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Artists(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Favorite(),
        ));
        break;
        case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PlayLists(),
        ));
        break;
        case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Settings(),
        ));
        break;
        case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Podcast(),
        ));
        break;
         case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Podcast(),
        ));
        break;
        case 5:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Podcast(),
        ));
        break;
        case 6:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Podcast(),
        ));
        break;
        case 7:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Podcast(),
        ));
        break;
        case 8:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Podcast(),
        ));
        break;
    }
    
  }

  UserPage({required String name, required String urlImage}) {}

  userPage() {}

  FavouritesPage() {}
}

void getData(BuildContext context) {
  String accountEmail = '';
  String accountName = '';
  final provider = Provider.of<LoginProvider>(context, listen: false);
  FutureBuilder(
    future: provider.getUserInfo(),
    builder: (ctx, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        accountEmail = snapshot.data['userName'];
        accountName = snapshot.data["email"];
      }
      return Text('');
    },
  );
}
