import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math.dart';
import 'dart:math';

import '../providers/global.dart';
import '../utils/global_variable.dart';

class LocationController {
  // final globalVariableController = Get.put(GlobalVariable());
  final location = loc.Location();

  Future<Map<String, double>> getCurrentLocation(BuildContext context) async {
    try {
      var _permissionGranted = await location.hasPermission();
      Map<String, double> mp = {};
      if (_permissionGranted == loc.PermissionStatus.granted) {
        log(423);
        final currentLocation = await location.getLocation();
        mp = {
          'latitude': currentLocation.latitude!,
          'longitude': currentLocation.longitude!
        };
        List<Placemark> placemark = await placemarkFromCoordinates(
            currentLocation.latitude!, currentLocation.longitude!);
        print(placemark);
        Placemark place = placemark[0];
        final global = Provider.of<Global>(context, listen: false);
        global.latitude = mp['latitude']!;
        global.longitude = mp['longitude']!;
        global.setUserPlace(place.subLocality!);
        global.setUserLocality(place.subLocality!);
        print(global.userCity);
        // globalVariableController.userLocation = place.subLocality!.obs;
        // globalVariableController.currentPlace = globalVariableController.userLocation.value.obs;
        return mp;
      } else {
        location.requestPermission();
      }
      return mp;
    } catch (e) {
      print(e.toString());
      Map<String, double> mp = {};
      mp = {
        'latitude': 26.7841485,
        'longitude': 75.8215834,
      };
      return mp;
    }
  }

  Future<bool> serviceEnabled() async {
    try {
      log(20);
      var service = await location.serviceEnabled();
      if (!service) {
        log(111);
        service = await location.requestService();
        if (!service) {
          return false;
        }
      }
      return true;
    } catch (e) {
      log(578);
      print(e.toString());
      return false;
    }
  }

  Future<bool> askPermission() async {
    try {
      log(30);
      var _permissionGranted = await location.hasPermission();
      if (_permissionGranted == loc.PermissionStatus.denied) {
        log(2111);
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != loc.PermissionStatus.granted) {
          return false;
        }
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  double haversineFormula(
      double currLat, double currLong, double cityLat, double cityLong) {
    currLat = radians(currLat);
    currLong = radians(currLong);
    cityLat = radians(cityLat);
    cityLong = radians(cityLong);

    // Haversine formula
    double dlon = cityLong - currLong;
    double dlat = cityLat - currLat;
    double a = pow((sin(dlat / 2)), 2.0) +
        (cos(currLat) * cos(cityLat) * pow(sin(dlon / 2), 2.0));
    double c = 2 * asin(sqrt(a));
    // Radius of earth in kilometers. Use 3956 for miles
    double r = 6371.0;

    return (c * r);
  }

  Future<String> getCity(double currlat, double currlong) async {
    try {
      final _rawData =
          await rootBundle.loadString("assets/csv_file/indian_cities_csv.csv");
      List<List<dynamic>> _listData = CsvToListConverter().convert(_rawData);
      String city = "Delhi";
      double minDist = 400;
      for (int i = 0; i < _listData.length; i++) {
        double citylat = double.parse(_listData[i][1].toString());
        double citylong = double.parse(_listData[i][2].toString());
        double dist = haversineFormula(currlat, currlong, citylat, citylong);
        if (dist < minDist) {
          city = _listData[i][0].toString();
          minDist = dist;
        }
      }
      print(city);
      return city.toLowerCase();
    } catch (e) {
      print(e.toString());
      return 'jaipur';
    }
  }

  Future<void> getCityList() async {
    try {
      final _rawData =
          await rootBundle.loadString("assets/csv_file/indian_cities_csv.csv");
      List<List<dynamic>> _listData = CsvToListConverter().convert(_rawData);
      List<String> _city = [];
      for (int i = 0; i < _listData.length; i++) {
        _city.add(_listData[i][0]);
      }
      cityList['city'] = _city;
      print(cityList['city'].toString());
      List<String> _cityImage = [];
      for (int i = 0; i < _listData.length; i++) {
        _cityImage.add(_listData[i][3]);
      }
      cityList['cityImage'] = _cityImage;
    } catch (e) {
      print(e.toString());
    }
  }
}
