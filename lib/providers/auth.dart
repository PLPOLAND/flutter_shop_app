import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token = '';
  DateTime _expiryDate = DateTime.now();
  String _userId = '';
  Timer _authTimer = Timer(Duration(seconds: 0), () {});

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_expiryDate.isAfter(DateTime.now()) && _token != '') {
      return _token;
    }
    return '';
  }

  String get userID {
    return _userId;
  }

  Future<void> _authenticate(String email, String password, String url) async {
    final url1 =
        'https://identitytoolkit.googleapis.com/v1/accounts:$url?key=AIzaSyA3GXNR_czsU4Wdr2RdmFIzI2cDXA3qRgM';
    try {
      final response = await http.post(Uri.parse(url1), body: {
        'email': email,
        'password': password,
        'returnSecureToken': "true",
      });
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      } else {
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now().add(
          Duration(
            seconds: int.parse(responseData['expiresIn']),
          ),
        );
        _autoLogout();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': _token,
            'userId': _userId,
            'expiryDate': _expiryDate.toIso8601String(),
          },
        );
        prefs.setString('userData', userData);
        print('Login Successful');
        print('userData = $userData');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<bool> tryAutoLogin() async {
    print('Trying Auto Login');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print('No userData found');
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'] as String);
    if (expiryDate.isBefore(DateTime.now())) {
      print('Token Expired');
      return false;
    }
    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId'] as String;
    _expiryDate = expiryDate;
    notifyListeners();
    print('Auto Login Successful');
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = '';
    _userId = '';
    _expiryDate = DateTime.now();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_expiryDate != null) {
      final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
      if (!_authTimer.isActive) {
        _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
      }
    }
  }
}
