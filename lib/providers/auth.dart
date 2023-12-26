import 'dart:convert';
import 'dart:developer';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token!;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  // sign up user
  Future<void> signUp(String email, String password, String username,
      String phone, String type) async {
    try {
      const url =
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAjjDiSj6iFXoubVs29h64llrm0I7aPSg4';
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responsData = json.decode(response.body);
      if (responsData['error'] != null) {
        throw HttpExceptions(responsData['error']['message']);
      }
      FirebaseFirestore.instance
          .collection('users')
          .doc(responsData['localId'])
          .set({
        'uid': responsData['localId'],
        'email': email,
        'username': username,
        'phone': phone,
        'type': type,
      });
      _token = responsData['idToken'];
      _userId = responsData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responsData['expiresIn']),
        ),
      );
      autologout();
      notifyListeners();
      final userData = json.encode({
        'token': _token,
        'expiryDate': _expiryDate,
        'userId': _userId,
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', userData);
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  // sign In user
  Future<void> login(String email, String password) async {
    try {
      const url =
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAjjDiSj6iFXoubVs29h64llrm0I7aPSg4';
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responsData = json.decode(response.body);
      if (responsData['error'] != null) {
        throw HttpExceptions(responsData['error']['message']);
      }
      _token = responsData['idToken'];
      _userId = responsData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responsData['expiresIn']),
        ),
      );
      autologout();
      notifyListeners();
      final userData = json.encode({
        'token': _token,
        'expiryDate': _expiryDate!.toIso8601String(),
        'userId': _userId,
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', userData);
      print(prefs.getString('userData').toString());
      // print(json.decode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    // Future.delayed(Duration(seconds: 5));
    // log('101');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      // log('1');
      return false;
    }
    // log('102');
    final extractedData = json.decode(prefs.getString('userData')!);
    // log('104');
    final expiryDate = DateTime.parse(extractedData['expiryDate'].toString());
    // log('103');
    if (expiryDate.isBefore(DateTime.now())) {
      // log('2');
      return false;
    }
    // log('3');
    _token = extractedData['token'].toString();
    _expiryDate = expiryDate;
    _userId = extractedData['userId'].toString();
    notifyListeners();
    autologout();
    return true;
    // return true;
  }

  //log out
  Future<void> logout() async {
    // log('call');
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (authTimer != null) {
      authTimer!.cancel();
      authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
    notifyListeners();
    // log(prefs.toString());
    // log('logout');
  }

  void autologout() {
    if (authTimer != null) {
      authTimer!.cancel();
    }
    final timeToExpire = _expiryDate!.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
