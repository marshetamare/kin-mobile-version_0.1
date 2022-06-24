import 'dart:convert';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/artist.dart';
import 'package:kin_music_player_app/services/network/model/companyProfile.dart';
import 'package:kin_music_player_app/services/network/model/favorite.dart';
import 'package:kin_music_player_app/services/network/model/genre.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/network/model/playlist_title.dart';
import 'package:kin_music_player_app/services/network/model/playlist_titles.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/services/network/model/podcast_category.dart';
import 'package:kin_music_player_app/services/network/model/radio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'model/user.dart';

Future<String> createAccount(apiEndPoint, user) async {
  Response response = await post(
    Uri.parse("$apiUrl/api" "$apiEndPoint"),
    body: json.encode(user),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    },
  );

  if (response.statusCode == 201) {
    var token = json.decode(response.body)['token'];
    var name = json.decode(response.body)['user']['name'];
    var email = json.decode(response.body)['user']['email'];
    var id = json.decode(response.body)['user']['id'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('name$id', name);
    await prefs.setString('email$id', email);
    await prefs.setInt('id', id);
    return "Successfully Registered";
  } else {
    var error = json.decode(response.body)['errors'];
    if (error['email'] != null) {
      return error['email'].toString();
    } else if (error['password'] != null) {
      return error['password'].toString();
    }
    return 'Unknown Error Occurred';
  }
}

Future logIn(apiEndPoint, user) async {
  Response response = await post(
    Uri.parse("$apiUrl/api" "$apiEndPoint"),
    body: user,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 201) {
    var body = json.decode(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = body['user']['id'];
    await prefs.setString('token', body['token']);
    await prefs.setString('name$id', body['user']["name"]);
    await prefs.setString('email$id', body['user']['email'] ?? '');
    await prefs.setInt('id', id);
    return "Successfully Logged In";
  } else {
    return 'please enter correct user name and password';
  }
}

Future loginWithFacebook(apiEndPoint) async {
  var result =
      await FacebookAuth.i.login(permissions: ["public_profile", "email"]);
  var user;
  if (result.status == LoginStatus.success) {
    final requestData =
        await FacebookAuth.i.getUserData(fields: "email,name,picture");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = User(
        name: requestData['name']??'',
        id: 2,
        email: requestData['email'] ?? '${requestData['name']}@kinMusic',
        password: 'kin@Music',
        passwordConfirmation: 'kin@Music');
    Response response = await post(
      Uri.parse("$apiUrl/api/register"),
      body: json.encode(user),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 201) {
      prefs.remove('id');
      var id = json.decode(response.body)['user']['id'];
      await prefs.setInt('id', id);
      await prefs.setString('token', result.accessToken!.token);
      await prefs.setString('name$id', requestData["name"]);
      await prefs.setString('email$id',requestData['email'] ?? '${requestData['name']}@kinMusic');
    }
    return result.status;
  }
}

Future getMusic(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
  if (response.statusCode == 200) {
    final item = json.decode(response.body)['data'] as List;
    List<Music> music = item.map((value) => Music.fromJson(value)).toList();
    return music;
  } else {
  }
}
Future incrementMusicView(musicId) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var data = {
    'musicId':musicId,
    'clientId':prefs.getInt('id')
  };
  Response response = await post(
    Uri.parse("$apiUrl/api/music/incrementView"),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    },
  );
  if(response.statusCode ==201){
    return 'Successfully Incremented';
  }else{
    return 'Already added';
  }
}
Future fetchMore(page) async {
  List<Music> musics;
  Response response =
      await get(Uri.parse("$apiUrl/api/musics/recent?page=$page"));
  if (response.statusCode == 200) {
    final item = json.decode(response.body)['data'] as List;
    musics = item.map((value) => Music.fromJson(value)).toList();
    return musics;
  }
}
Future fetchMorePopular(page) async {
  List<Music> musics;
  Response response =
  await get(Uri.parse("$apiUrl/api/musics/popular?page=$page"));
  if (response.statusCode == 200) {
    final item = json.decode(response.body)['data'] as List;
    musics = item.map((value) => Music.fromJson(value)).toList();
    return musics;
  }
}
Future fetchMoreAlbum(page) async {
  List<Album> albums;
  Response response = await get(Uri.parse("$apiUrl/api/albums?page=$page"));
  if (response.statusCode == 200) {
    final item = json.decode(response.body) as List;
    albums = item.map((value) => Album.fromJson(value)).toList();
    return albums;
  }
}

Future fetchMoreCategories(page) async {
  List<PodCastCategory> categories;
  Response response =
      await get(Uri.parse("$apiUrl/api/podcast/categories?page=$page"));
  if (response.statusCode == 200) {
    final item = json.decode(response.body)['data'] as List;
    categories = item.map((value) => PodCastCategory.fromJson(value)).toList();
    return categories;
  }
}

Future getAlbums(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
  if (response.statusCode == 200) {
    final item = json.decode(response.body) as List;
    List<Album> albums = item.map((value) {
      return Album.fromJson(value);
    }).toList();
    return albums;
  } else {
  }
}

Future getArtists(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));

  if (response.statusCode == 200) {
    final item = json.decode(response.body) as List;
    List<Artist> artists = item.map((value) {
      return Artist.fromJson(value);
    }).toList();
    return artists;
  } else {
  }
}

Future getPlayLists(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));

  if (response.statusCode == 200) {
    final item = json.decode(response.body) as List;
    List<PlaylistTitle> playlists = item.map((value) {
      return PlaylistTitle.fromJson(value);
    }).toList();

    return playlists;
  } else {
  }
}

Future getPlayListTitles(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));

  if (response.statusCode == 200) {
    final item = json.decode(response.body) as List;
    List<PlayListTitles> playlistTitles = item.map((value) {
      return PlayListTitles.fromJson(value);
    }).toList();
    return playlistTitles;
  } else {
  }
}

Future addToPlaylist(apiEndPoint, playlistInfo) async {
  Response response = await post(
    Uri.parse("$apiUrl/api" "$apiEndPoint"),
    body: json.encode(playlistInfo),
    headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
  );
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

 Future getFavoriteMusics(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
  if (response.statusCode == 200) {
    final item = json.decode(response.body) as List;
    List<Favorite> musics = item.map((value) {
      return Favorite.fromJson(value);
    }).toList();

    return musics;
  } else {
  }
}

Future deleteFavMusic(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
  if (response.statusCode == 200) {
  } else {
  }
}

Future markusFavMusic(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
  if (response.statusCode == 200) {
  } else {
  }
}

Future<int> isMusicFavorite(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
  if (response.statusCode == 200) {
    return (json.decode(response.body));
  } else {
    return 0;
  }
}

Future createPlaylist(apiEndPoint, playlist) async {
  Response response = await post(
    Uri.parse("$apiUrl/api" "$apiEndPoint"),
    body: playlist,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    },
  );
  if (response.statusCode == 201) {
    return 'Successful';
  } else {
    return 'PlayList Title Already Exists';
  }
}

Future removeFromPlaylist(apiEndPoint) async {
  Response response = await get(
    Uri.parse("$apiUrl/api" "$apiEndPoint"),
  );
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}
Future removePlaylistTitle(apiEndPoint) async {
  Response response = await delete(
    Uri.parse("$apiUrl/api" "$apiEndPoint"),
  );
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}
Future searchMusic(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
  if (response.statusCode == 200) {
    final item = json.decode(response.body) as List;
    List<dynamic> musics = item.map((value) {
      return Music.fromJson(value);
    }).toList();
    return musics;
  } else {
    return [];
  }
}

Future getPodCasts(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));

  if (response.statusCode == 200) {
    final item = json.decode(response.body)['data'] as List;
    List<PodCast> podCasts = item.map((value) {
      return PodCast.fromJson(value);
    }).toList();
    return podCasts;
  } else {
  }
}

Future fetchMorePodCasts(page) async {
  List<PodCast> podCasts;
  Response response = await get(Uri.parse("$apiUrl/api/podcasts?page=$page"));
  if (response.statusCode == 200) {
    final item = json.decode(response.body)['data'] as List;
    podCasts = item.map((value) => PodCast.fromJson(value)).toList();
    return podCasts;
  }
}

Future searchPodCast(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
  if (response.statusCode == 200) {
    final item = json.decode(response.body) as List;
    List<dynamic> podcasts = item.map((value) {
      return PodCast.fromJson(value);
    }).toList();
    return podcasts;
  } else {
    return [];
  }
}

Future getPodCastCategories(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));

  if (response.statusCode == 200) {
    final item = json.decode(response.body)['data'] as List;
    List<PodCastCategory> categories = item.map((value) {
      return PodCastCategory.fromJson(value);
    }).toList();
    return categories;
  } else {
  }
}

Future<List<Genre>> getGenres(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));

  if (response.statusCode == 200) {
    final item = json.decode(response.body) as List;
    List<Genre> genres = item.map((value) {
      return Genre.fromJson(value);
    }).toList();

    return genres;
  } else {
  }
  return [];
}

Future<dynamic>getCompanyProfile(apiEndPoint) async{
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
  if (response.statusCode == 200) {
    final item = json.decode(response.body);

    return CompanyProfile.fromJson(item);
  }
  return 'Unknown Error Occured';
}

Future<List<RadioStation>> getRadioStations(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));

  if (response.statusCode == 200) {
    final item = json.decode(response.body) as List;
    List<RadioStation> stations = item.map((value) {
      return RadioStation.fromJson(value);
    }).toList();

    return stations;
  } else {
  }
  return [];
}
