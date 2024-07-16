import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as getx;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:super_liquid_galaxy_controller/data_class/map_position.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_details_response.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_info.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_response.dart';
import 'package:super_liquid_galaxy_controller/utils/api_manager.dart';
import 'package:super_liquid_galaxy_controller/utils/geo_utils.dart';
import 'package:super_liquid_galaxy_controller/utils/lg_connection.dart';
import 'package:super_liquid_galaxy_controller/utils/wikidatafetcher.dart';

import '../data_class/coordinate.dart';
import '../data_class/kml_element.dart';
import '../screens/test.dart';
import 'kmlgenerator.dart';

class TourController extends getx.GetxController {
  late ApiManager apiClient;
  late LGConnection connectionClient;
  var _searchAroundCoords = Coordinates(latitude: 12.0, longitude: 12.0).obs;
  PlaceDetailsResponse? boundaryPlace;
  var label = ''.obs;
  PlaceResponse? places;
  List<PlaceInfo> masterList = <PlaceInfo>[];
  getx.RxList<PlaceInfo> placeList = <PlaceInfo>[].obs;
  final isLoading = false.obs;
  final isError = false.obs;
  BuildContext? context;
  //Set<String> categories = {};

  @override
  void onInit() {
    apiClient = getx.Get.find();
    connectionClient = getx.Get.find();
    super.onInit();
  }

  void setSearchAround(Coordinates point, String label1) {
    _searchAroundCoords.value = point;
    label.value = label1;
    placeList.clear();
    masterList.clear();
    getPlaceBounds();
  }

  Coordinates getSearchAround() {
    return _searchAroundCoords.value;
  }

  Size getScreenSize(BuildContext context) => MediaQuery.of(context).size;

  void getPlaceBounds() async {

      isLoading.value = true;
      isError.value = false;
      try{
      var queryText = label.value.split('\n').reversed.join(", ");
      bool isCountry = label.value.split('\n').where((String str) {
            return str.isNotEmpty;
          }).length ==
          1;
      if (isCountry) {
        queryText = label.value.split('\n')[0];
      }
      print(queryText);
      String placeID = await apiClient.tryGeoCodeResponseFromPoint(
          _searchAroundCoords.value, isCountry);
      print("id: $placeID");

      final response = await apiClient.tryBoundaryResponseForID(
          placeID, _searchAroundCoords.value);
      if (response.obj != null) {
        boundaryPlace = response.obj;
      }
      var kmlResponse = response.kml;
      if (kmlResponse.compareTo('') == 0) {
        return;
      }
      List<Coordinates> geometryPoints = [];
      if (response.coords != null) {
        geometryPoints.addAll(response.coords!);
      }
      /*else
        {
          runKml(kmlResponse);
        }*/
      final output = await apiClient.tryPlaceResponseForID(
          placeID, _searchAroundCoords.value);
      if (output.obj != null) {
        places = output.obj;
      }
      isLoading.value = false;
      placeList.addAll(output.places);
      masterList.addAll(output.places);
      kmlResponse += output.kml;
      if (kmlResponse.compareTo('') == 0) {
        return;
      } else {
        var coords = <LatLng>[];
        for (final point in placeList.value) {
          coords.add(point.coordinate.toLatLngMap(point.coordinate));
          //categories.add(point.category);
        }
        for (final point in geometryPoints) {
          coords.add(point.toLatLngMap(point));
          //categories.add(point.category);
        }

        if (boundaryPlace != null) {
          kmlResponse = KMLGenerator.generateKml('69', kmlResponse);
        }

        //getx.Get.to(()=>TestScreen(kml: kmlResponse));
        await runKml(kmlResponse);
        if (context != null) {
          var position = MapPosition.fromCameraPosition(
              GeoUtils.getBoundsZoomLevel(coords, getScreenSize(context!)));
          await connectionClient.moveTo(position);
        }
        adjustPlaceMarks();
      }
    }
    catch(e)
    {
      isLoading.value = false;
      isError.value = true;
    }
  }

  Future<void> runKml(String kmlResponse) async {

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

  void adjustPlaceMarks() {
    
    const maxLength = 20;
    for(var (index,place) in placeList.indexed)
      {
        String text = place.name;
        text = text.trim();
        if(text.length >= maxLength)
          {
            text=text.replaceRange(maxLength, text.length,  '...');
          }
        else
          {
            text = text + ' '*(maxLength-text.length+3);
          }
        text = text.substring(0,1).toUpperCase()+text.substring(1);
        placeList[index].label = text;
      }
    placeList.add(PlaceInfo(coordinate: Coordinates(latitude: 0.0, longitude: 0.0), label: "label", address: "address", category: "category", name: "name"));
    placeList.removeLast();
    masterList.clear();
    masterList.addAll(placeList);
    /*int counter =0;
    String indexes  ='';
    for(final place in masterList)
      {
        print('${place.label.trim()} - ${place.wikipediaTitle}');
      }
    print(indexes);
    print('count: $counter');*/

    // WikiDataFetcher wikiDataFetcher = getx.Get.find();
    // wikiDataFetcher.setData(masterList[3]);
    // wikiDataFetcher.getInfo();

  }

  void filterList(String query)
  {
    placeList.clear();
    for(final item in masterList)
      {
        if(item.label.toLowerCase().contains(query.toLowerCase()) || item.address.toLowerCase().contains(query.toLowerCase()))
          {
            placeList.add(item);
          }
      }
    //adjustPlaceMarks();
  }
}
