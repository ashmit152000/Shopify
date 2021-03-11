import 'dart:async';
import 'dart:ffi';

import 'package:Shopify/models/http_exception.dart';
import 'package:Shopify/screens/products_overview_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String token;
  DateTime expiryDate;
  String userId;
  Timer _authTimer;

  bool  getToken() {
    if(token != null && expiryDate != null && expiryDate.isAfter(DateTime.now())){
      return true;
    }
    return false;
  }

    void setToken(String value){
    this.token = value;
  }

  Future<void> signUp(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBJkU0DM0QN59MQw5bY1-5ZVJUkNS-NLWc";

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      setToken(responseData['idToken']);
      userId = responseData['localId'];
      expiryDate = DateTime.now().add(Duration(seconds: 5000));
      _autoLogout();
      print(getToken());
      notifyListeners();
    } catch (error) {
      // print(error);
      throw error;
    }
  }
  


  Future<void> signIn(
      String email, String password, BuildContext context) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBJkU0DM0QN59MQw5bY1-5ZVJUkNS-NLWc";

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message'].toString());
      }

      // token = responseData['idToken'];
      setToken(responseData['idToken']);
      userId = responseData['localId'];
      expiryDate = DateTime.now().add(Duration(seconds: 5000));
      print(getToken());
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();

      final userData = json.encode({
        'token': token,
        'userId': userId,
        'expiryDate': expiryDate.toIso8601String(),
      });

      prefs.setString('userData', userData);
    } catch (error) {
      // print(error);
      throw error;
    }
  }

  void logout() {
    token = null;
    userId = null;
    expiryDate = null;
    if(_authTimer != null){
      _authTimer.cancel();
    }
    
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String ,Object>;
    final expiryDateOne = DateTime.parse(extractedUserData['expiryDate']);

    if(expiryDateOne.isBefore(DateTime.now())){
      return false;
    }
    token = extractedUserData['token'];
    userId = extractedUserData['userId'];
    expiryDate = expiryDateOne;
    notifyListeners();
    _autoLogout();
    return true;

  }

  void _autoLogout(){
    if(_authTimer != null){
      _authTimer.cancel();
    }
    var timeToExpiry = expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
