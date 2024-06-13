import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiManager{

  late String _placesApiKey;

  ApiManager._privateConstructor() {
    print("instance created");
    _connectApi();
  }
  static final ApiManager _instance = ApiManager._privateConstructor();
  static ApiManager get instance => _instance;
  _connectApi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _placesApiKey=preferences.getString("places_api")??"";
    print({
      "places_api":_placesApiKey
    });
    return {
      "places_api":_placesApiKey
    };
  }



}