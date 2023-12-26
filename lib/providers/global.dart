import 'package:flutter/material.dart';

class Global extends ChangeNotifier {
  String userPlace = '';
  String userCity = "Searching...";
  String userLocality = "Searching..";
  String selectedCity = '';
  double latitude = 0;
  double longitude = 0;
  void setUserPlace(String place) {
    userPlace = place;
    notifyListeners();
  }

  void setUserCity(String city) {
    userCity = city;
    notifyListeners();
  }

  void setUserLocality(String Loc) {
    userLocality = Loc;
    notifyListeners();
  }
}
