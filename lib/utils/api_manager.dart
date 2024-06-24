import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_liquid_galaxy_controller/data_class/api_error.dart';

class ApiManager extends getx.GetxController {
  late String _placesApiKey;
  late Dio _apiClient;

  var isConnected = false.obs;

  //base-urls
  static const geoApifyV2BaseUrl = "https://api.geoapify.com/v2";
  static const geoApifyV1BaseUrl = "https://api.geoapify.com/v1";

  //end-points
  static const autocompleteEndPoint = "/geocode/autocomplete";
  static const placesEndPoint = "/places";

  /*ApiManager._privateConstructor() {
    print("instance created");
    _apiClient = Dio();
  }

  static final ApiManager _instance = ApiManager._privateConstructor();

  static ApiManager get instance => _instance;*/

  //parameter decides base-url version
  _connectApi(int version) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _placesApiKey = preferences.getString("places_apikey") ?? "";
    _placesApiKey = _placesApiKey.trim();
    print({"places_api": _placesApiKey});
    final options = BaseOptions(
        baseUrl: (version == 1) ? geoApifyV1BaseUrl : geoApifyV2BaseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 7),
        validateStatus: (status) {
          if (status != null) {
            return status < 500;
          } else {
            return false;
          }
        });
    _apiClient = Dio(options);
    print({"places_api": _placesApiKey});
    // await _testApiKey();
    return isConnected.value;
  }

  Future<Response> getAutoCompleteResponse(String text) async {
    await _connectApi(1);
    var response = await _apiClient.get(autocompleteEndPoint,
        queryParameters: {'text': text, 'apiKey': _placesApiKey.trim()});
    if (response.statusCode != 200) {
      handleError(response);
    }
    return response;
  }

  void handleError(Response<dynamic> response) {
    var errorResponse = ApiErrorResponse.fromJson(response.data);
    print('error : ${response.statusMessage}');
    if (!getx.Get.isSnackbarOpen) {
      getx.Get.showSnackbar(getx.GetSnackBar(
        backgroundColor: Colors.red.shade300,
        title: '${response.statusCode}: ${errorResponse.error}',
        message: "API returned: ${errorResponse.message}",
        isDismissible: true,
        duration: 2.seconds,
      ));
    }
  }

  testApiKey() async {
    await _connectApi(1);
    try {
      var response = await _apiClient.get(
          autocompleteEndPoint,
          queryParameters: {'text': "test",
            'apiKey': _placesApiKey.trim()
          });

      if (response.statusCode == 200) {
        isConnected.value = true;
      }
      else {
        var error = ApiErrorResponse.fromJson(response.data);
        isConnected.value = false;
        print('${error.error} - ${error.message}');
      }
    }
    catch(e)
      {
        print(e);
        isConnected.value = false;
      }
  }
}
