import 'dart:ffi';

import 'package:Shopify/models/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime expiryDate;
  String userId;

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
       
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
    }catch(error) {
      // print(error);
      throw error;
    }
  }

  Future<void> signIn(String email, String password) async {
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
      if(responseData['error'] != null){
         throw HttpException(responseData['error']['message'].toString());
      }
    } catch (error) {
      // print(error);
      throw error;
    }
  }
}
