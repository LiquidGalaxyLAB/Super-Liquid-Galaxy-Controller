import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:super_liquid_galaxy_controller/data_class/geocode_response.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_details_response.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_response.dart';
import 'package:super_liquid_galaxy_controller/screens/test.dart';
import 'package:super_liquid_galaxy_controller/utils/api_manager.dart';
import 'package:super_liquid_galaxy_controller/utils/lg_connection.dart';

import '../data_class/coordinate.dart';
import '../data_class/kml_element.dart';
import 'kmlgenerator.dart';

class TourController extends getx.GetxController {
  late ApiManager apiClient;
  late LGConnection connectionClient;
  var _searchAroundCoords = Coordinates(latitude: 12.0, longitude: 12.0).obs;
  PlaceDetailsResponse? boundaryPlace;
  var label = ''.obs;
  PlaceResponse? places;
  getx.RxList<Placemark> placeList = <Placemark>[].obs;


  @override
  void onInit() {
    apiClient = getx.Get.find();
    connectionClient = getx.Get.find();
    super.onInit();
  }

  void setSearchAround(Coordinates point, String label1) {
    _searchAroundCoords.value = point;
    label.value = label1;
    getPlaceBounds();
  }

  Coordinates getSearchAround() {
    return _searchAroundCoords.value;
  }

  void getPlaceBounds() async {

      var queryText = label.value.split('\n').reversed.join(", ");
      bool isCountry = label.value.split('\n').where((String str) {
            return str.isNotEmpty;
          }).length == 1;
      if(isCountry)
        {
          queryText = label.value.split('\n')[0];
        }
      print(queryText);
      String placeID = await apiClient.tryGeoCodeResponseFromPoint(
          _searchAroundCoords.value, isCountry);
      print("id: $placeID");

      final response = await apiClient.tryBoundaryResponseForID(placeID,_searchAroundCoords.value);
      if(response.obj != null) {
        boundaryPlace = response.obj;
      }
      var kmlResponse = response.kml;
      if(kmlResponse.compareTo('')==0) {
        return;
      }
      else
        {
          runKml(kmlResponse);
        }
      final output = await apiClient.tryPlaceResponseForID(placeID,_searchAroundCoords.value);
      if(output.obj != null) {
        places = output.obj;
      }
      placeList.addAll(output.places);
      kmlResponse += output.kml;
      if(kmlResponse.compareTo('')==0) {
        return;
      }
      else
      {
        kmlResponse = KMLGenerator.generateKml('69', kmlResponse);
        //getx.Get.to(()=>TestScreen(kml: kmlResponse));
        runKml(kmlResponse);
      }
  }

  void runKml(String kmlResponse) async {

    print("tapped");
    String filename = generateRandomString(7);
    await connectionClient.connectToLG();
    if(!connectionClient.isConnected.value)
      return;
    File? file = await connectionClient.makeFile(filename,
        kmlResponse);
    print("made successfully");
    await connectionClient.kmlFileUpload(
        file!, filename);
    print("uploaded successfully");
    await connectionClient.runKml(filename);
  }
  String generateRandomString(int len) {
    var r = Random.secure();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz_';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
}
