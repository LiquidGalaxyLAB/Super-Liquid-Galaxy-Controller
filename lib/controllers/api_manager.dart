import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_liquid_galaxy_controller/data_class/api_error.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/data_class/geo_reversecode_response.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_details_response.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_info.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_response.dart' as pr;
import 'package:super_liquid_galaxy_controller/screens/test.dart';
import 'package:super_liquid_galaxy_controller/utils/kmlgenerator.dart';

import '../data_class/kml_element.dart';

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
  static const geocodeEndPoint = "/geocode/search";
  static const reverseGeoCodeEndPoint = "/geocode/reverse";
  static const boundariesPartOfEndPoint = "/boundaries/part-of";
  static const boundariesConsistsOfEndPoint = "/boundaries/consists-of";
  static const placeDetailsEndPoint = "/place-details";

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
        connectTimeout: const Duration(seconds: 7),
        receiveTimeout: const Duration(seconds: 10),
        validateStatus: (status) {
          if (status != null) {
            return status < 500;
          } else {
            return false;
          }
        });
    _apiClient = Dio(options);
    //print({"places_api": _placesApiKey});
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

  Future<Response> getGeoCodeResponse(String text, String searchLevel) async {
    await _connectApi(1);
    var response = await _apiClient.get(geocodeEndPoint, queryParameters: {
      'text': text,
      'apiKey': _placesApiKey.trim(),
      'format': 'json',
      'type': searchLevel
    });
    if (response.statusCode != 200) {
      handleError(response);
    }
    return response;
  }



  Future<Response> getNearbyPlaces(Coordinates point) async {
    await _connectApi(2);
    var response = await _apiClient.get(placesEndPoint, queryParameters: {
      'filter': 'circle:${point.longitude},${point.latitude},50000',
      'bias':'proximity:${point.longitude},${point.latitude}',
      'apiKey': _placesApiKey.trim(),
      'categories': 'commercial,tourism,entertainment,leisure,building',
      'limit': '50'
    });
    if (response.statusCode != 200) {
      handleError(response);
    }
    return response;
  }

  Future<Response> getPlaces(String id, String categories) async {
    await _connectApi(2);
    var response = await _apiClient.get(placesEndPoint, queryParameters: {
      'filter': 'place:$id',
      'apiKey': _placesApiKey.trim(),
      'categories': categories,
      'limit': '500'
    });
    if (response.statusCode != 200) {
      handleError(response);
    }
    return response;
  }

  Future<Response> getReverseGeoCodeResponse(
      Coordinates point, String searchLevel) async {
    await _connectApi(1);
    bool hasType = searchLevel.compareTo("none") != 0;
    print("hasType: $hasType");
    var response = hasType
        ? await _apiClient.get(reverseGeoCodeEndPoint, queryParameters: {
            'lat': point.latitude.toString(),
            'lon': point.longitude.toString(),
            'apiKey': _placesApiKey.trim(),
            'format': 'json',
            'type': searchLevel
          })
        : await _apiClient.get(reverseGeoCodeEndPoint, queryParameters: {
            'lat': point.latitude,
            'lon': point.longitude,
            'apiKey': _placesApiKey.trim(),
            'format': 'json'
          });
    if (response.statusCode != 200) {
      handleError(response);
    }
    return response;
  }

  Future<Response> getBoundariesPartOf(String id) async {
    await _connectApi(1);
    //print("hasType: $hasType");
    var response =
        await _apiClient.get(boundariesPartOfEndPoint, queryParameters: {
      'id': id,
      'apiKey': _placesApiKey.trim(),
      'geometry': 'geometry_1000',
      'sublevel': '1'
    });
    if (response.statusCode != 200) {
      handleError(response);
    }
    return response;
  }

  Future<Response> getPlaceDetails(String id) async {
    await _connectApi(2);
    //print("hasType: $hasType");
    var response = await _apiClient.get(placeDetailsEndPoint, queryParameters: {
      'id': id,
      'apiKey': _placesApiKey.trim(),
      'features': 'details.full_geometry'
    });
    if (response.statusCode != 200) {
      handleError(response);
    }
    return response;
  }

  Future<Response> getBoundariesConsistsOf(String id) async {
    await _connectApi(1);
    //print("hasType: $hasType");
    var response =
        await _apiClient.get(boundariesConsistsOfEndPoint, queryParameters: {
      'id': id,
      'apiKey': _placesApiKey.trim(),
      'geometry': 'geometry_1000',
      'sublevel': '1'
    });
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
      var response = await _apiClient.get(autocompleteEndPoint,
          queryParameters: {'text': "test", 'apiKey': _placesApiKey.trim()});

      if (response.statusCode == 200) {
        isConnected.value = true;
      } else {
        var error = ApiErrorResponse.fromJson(response.data);
        isConnected.value = false;
        print('${error.error} - ${error.message}');
      }
    } catch (e) {
      print(e);
      isConnected.value = false;
    }
  }

  Future<String> tryGeoCodeResponseFromPoint(
      Coordinates searchAroundCoords, bool isCountry) async {
    Response response = await getReverseGeoCodeResponse(
        searchAroundCoords, isCountry ? 'country' : 'state');
    if (response.statusCode != 200) {
      return '';
    }
    var responseObj = GeoReverseCodeResponse.fromJson(response.data);

    if (responseObj.results != null && responseObj.results!.isNotEmpty) {
      return responseObj.results![0].placeId!;
    } else {
      Response response2 =
          await getReverseGeoCodeResponse(searchAroundCoords, 'none');
      var responseObj2 = GeoReverseCodeResponse.fromJson(response2.data);
      print(responseObj2);
      if (response2.statusCode != 200) {
        return '';
      }
      if (responseObj2.results != null && responseObj2.results!.isNotEmpty) {
        return responseObj2.results![0].placeId!;
      } else {
        return '';
      }
    }
  }

  Future<({String kml,PlaceDetailsResponse? obj,List<Coordinates>? coords})> tryBoundaryResponseForID(
      String id, Coordinates searchAroundCoords) async {
    Response response = await getPlaceDetails(id);
    if (response.statusCode != 200) {
      return (kml:'',obj: null,coords: null);
    }

    var responseObj = PlaceDetailsResponse.fromJson(response.data);
    print(responseObj);
    print(responseObj.features?[0].geometry?.polygonList);
    print(responseObj.features?[0].geometry?.multiPolygonList);

    Response places = await getPlaces(id, 'tourism');
    if (places.statusCode != 200) {
      return (kml:'',obj: null,coords: null);
    }

    var placeObj = pr.PlaceResponse.fromJson(places.data);
    print(placeObj);
    if (responseObj.features != null &&
        responseObj.features!.isNotEmpty &&
        responseObj.features![0].geometry != null) {
      String kml =
          KMLGenerator.generateBoundaries(responseObj.features![0].geometry!);

      List<Coordinates> coords = KMLGenerator.getAllCoordsList(responseObj.features![0].geometry!);
      /*var list = placeObj.features;
      List<Placemark> coordinates = [];
      for (final feature in list!) {
        try {
          coordinates.add(Placemark(
              coordinate: feature.geometry!.point!,
              label: feature.properties!.name!.replaceAll('&', 'and'),
              description: feature.properties!.addressLine2!.replaceAll('&', 'and')));
        } catch (e) {
          print(e);
          print(feature);
        }
      }*/
      //kml += KMLGenerator.addPlaces(coordinates);
      //getx.Get.to(() => TestScreen(kml: KMLGenerator.generateKml('69', kml)));
      return (kml:kml,obj:responseObj,coords:coords);
    }
    return (kml:'',obj: null,coords: null);
  }

  Future<({String kml,pr.PlaceResponse? obj,List<PlaceInfo> places})> tryPlaceResponseForID(
      String id, Coordinates searchAroundCoords) async {
    Response places = await getPlaces(id, 'tourism');
    if (places.statusCode != 200) {
      return (kml:'',obj: null,places:<PlaceInfo>[]);
    }
    var placeObj = pr.PlaceResponse.fromJson(places.data);
    //print(placeObj);
    if (placeObj.features!=null && placeObj.features!.isNotEmpty) {
      var list = placeObj.features;
      List<PlaceInfo> coordinates = [];
      for (final feature in list!) {
        try {
          // var name = (feature.properties!.name != null)?feature.properties!.name!.replaceAll('&', 'and'):feature.properties!.addressLine1!;
          coordinates.add(getPlaceInfo(feature));
        } catch (e) {
          print(e);
          print(feature);
        }
      }
      String kml = KMLGenerator.addPlaces(coordinates);
      //getx.Get.to(() => TestScreen(kml: KMLGenerator.generateKml('69', kml)));
      return (kml:kml,obj:placeObj,places: coordinates);
    }
    return (kml:'',obj: null,places:<PlaceInfo>[]);
  }

  Future<({String kml,pr.PlaceResponse? obj,List<PlaceInfo> places})> tryPlaceResponseForCoordinates(
      Coordinates coords) async {
    Response places = await getNearbyPlaces(coords);
    if (places.statusCode != 200) {
      return (kml:'',obj: null,places:<PlaceInfo>[]);
    }
    var placeObj = pr.PlaceResponse.fromJson(places.data);
    //print(placeObj);
    if (placeObj.features!=null && placeObj.features!.isNotEmpty) {
      var list = placeObj.features;
      List<PlaceInfo> coordinates = [];
      for (final feature in list!) {
        try {
          // var name = (feature.properties!.name != null)?feature.properties!.name!.replaceAll('&', 'and'):feature.properties!.addressLine1!;
          coordinates.add(getPlaceInfo(feature));
        } catch (e) {
          print(e);
          print(feature);
        }
      }
      String kml = KMLGenerator.addPlaces(coordinates);
      //getx.Get.to(() => TestScreen(kml: KMLGenerator.generateKml('69', kml)));
      return (kml:kml,obj:placeObj,places: coordinates);
    }
    return (kml:'',obj: null,places:<PlaceInfo>[]);
  }

  PlaceInfo getPlaceInfo(pr.Features feature) {
    var name = (feature.properties!.name != null)?feature.properties!.name!.replaceAll('&', 'and'):feature.properties!.addressLine1!;
    var category = 'default';
    if(feature.properties!.categories != null && feature.properties!.categories!.isNotEmpty)
      {
        category = feature.properties!.categories![feature.properties!.categories!.length - 1];
        category = category.substring(category.lastIndexOf('.')+1);
      }
    PlaceInfo place = PlaceInfo(coordinate: Coordinates(latitude: feature.properties!.lat!, longitude: feature.properties!.lon!), label: '',name: name, address: feature.properties!.addressLine2!, category: category);
    if(feature.properties!.wikiAndMedia != null && feature.properties!.wikiAndMedia!.wikidata != null)
      {
        place.wikiMediaTag = feature.properties!.wikiAndMedia!.wikidata;
      }
    if(feature.properties!.wikiAndMedia != null && feature.properties!.wikiAndMedia!.wikipedia != null)
    {
      place.wikipediaLang = feature.properties!.wikiAndMedia!.wikiLang;
      place.wikipediaTitle = feature.properties!.wikiAndMedia!.wikiTitle;
    }
    return place;
  }



}
