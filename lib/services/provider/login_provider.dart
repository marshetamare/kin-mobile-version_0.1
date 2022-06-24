import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:kin_music_player_app/services/network/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_service.dart';

class LoginProvider extends ChangeNotifier {
  bool isLoading = false;
  Map user = {
    "userName":'',
    "email":''
  };


  Future register(User user) async {
    const String apiEndPoint = '/register';
    isLoading = true;
    notifyListeners();
    var result = await createAccount(apiEndPoint, user.toJson());
    isLoading = false;
    notifyListeners();
    return result;
  }

  Future login(user) async {
    const String apiEndPoint = '/login';
    isLoading = true;
    notifyListeners();
    var result = await logIn(apiEndPoint, user);
    isLoading = false;
    notifyListeners();
    return result;
  }

  Future loginFacebook() async{
    const String apiEndPoint = '/redirect';
    isLoading = true;
    notifyListeners();
    var result = await loginWithFacebook(apiEndPoint);
    isLoading = false;
    return result;
  }
  Future<bool> isLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('token') != null) {
      return true;
    }
    return false;
  }

  Future getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    user["userName"] = prefs.getString('name$id');
    user["email"] = prefs.getString('email$id');
    return user;
  }

  logOut() async {
    await FacebookAuth.i.logOut();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id =  pref.getInt('id');
    pref.remove('token');
    pref.remove('name$id');
    pref.remove('email$id');
  }
}
