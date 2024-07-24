import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as getx;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:super_liquid_galaxy_controller/controllers/api_manager.dart';
import 'package:super_liquid_galaxy_controller/controllers/lg_connection.dart';
import 'package:super_liquid_galaxy_controller/data_class/map_position.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_details_response.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_info.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_response.dart';
import 'package:super_liquid_galaxy_controller/utils/constants.dart';
import 'package:super_liquid_galaxy_controller/utils/geo_utils.dart';

import '../data_class/coordinate.dart';
import '../utils/kmlgenerator.dart';

class TourController extends getx.GetxController {
  late ApiManager apiClient;
  late LGConnection connectionClient;
  var _searchAroundCoords = Coordinates(latitude: 12.0, longitude: 12.0).obs;
  PlaceDetailsResponse? boundaryPlace;
  var label = ''.obs;
  PlaceResponse? places;
  String kml = "";
  MapPosition? lookAtPosition;
  List<PlaceInfo> masterList = <PlaceInfo>[];
  getx.RxList<PlaceInfo> placeList = <PlaceInfo>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var isTouring = false.obs;
  BuildContext? context;

  //Set<String> categories = {};

  var tourList = <PlaceInfo>[].obs;

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
    try {
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

      var listPlaces = output.places;
      String state =
          label.value.substring(label.value.indexOf('\n')).trim().toLowerCase();
      String country = label.value
          .substring(0, label.value.indexOf('\n'))
          .trim()
          .toLowerCase();
      // print("$state");
      // print(country);

      for (final p in listPlaces) {
        if (!(country.compareTo('') == 0)) {
          p.country = country;
        }
        if (!(state.compareTo('') == 0)) {
          p.state = state;
        }
      }
      placeList.addAll(listPlaces);
      masterList.addAll(listPlaces);
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
        kml = kmlResponse;
        //getx.Get.to(()=>TestScreen(kml: kmlResponse));
        await runKml(kmlResponse);
        if (context != null) {
          var position = MapPosition.fromCameraPosition(
              GeoUtils.getBoundsZoomLevel(coords, getScreenSize(context!)));
          lookAtPosition = position;
          await connectionClient.moveTo(position);
        }
        adjustPlaceMarks();
      }
    } catch (e) {
      isLoading.value = false;
      isError.value = true;
    }
  }

  Future<void> runKml(String kmlResponse) async {
    print("tapped");
    String filename = generateRandomString(7);
    await connectionClient.connectToLG();
    if (!connectionClient.isConnected.value) return;
    File? file = await connectionClient.makeFile(filename, kmlResponse);
    print("made successfully");
    await connectionClient.kmlFileUpload(file!, filename);
    print("uploaded successfully");
    await connectionClient.runKml(filename);
  }

  String generateRandomString(int len) {
    var r = Random.secure();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz_';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future<void> zoomToLocation(MapPosition position) async {
    print("Location state level");
    await connectionClient.moveTo(position);
  }

  void adjustPlaceMarks() {
    const maxLength = 20;
    for (var (index, place) in placeList.indexed) {
      String text = place.name;
      text = text.trim();
      if (text.length >= maxLength) {
        text = text.replaceRange(maxLength, text.length, '...');
      } else {
        text = text + ' ' * (maxLength - text.length + 3);
      }
      text = text.substring(0, 1).toUpperCase() + text.substring(1);
      placeList[index].label = text;
    }
    placeList.add(PlaceInfo(
        coordinate: Coordinates(latitude: 0.0, longitude: 0.0),
        label: "label",
        address: "address",
        category: "category",
        name: "name"));
    placeList.removeLast();
    masterList.clear();
    masterList.addAll(placeList);

    // WikiDataFetcher wikiDataFetcher = getx.Get.find();
    // wikiDataFetcher.setData(masterList[5]);
    // wikiDataFetcher.getInfo();
  }

  void filterList(String query) {
    placeList.clear();
    for (final item in masterList) {
      if (item.label.toLowerCase().contains(query.toLowerCase()) ||
          item.address.toLowerCase().contains(query.toLowerCase())) {
        placeList.add(item);
      }
    }
    //adjustPlaceMarks();
  }

  void addToTourList(PlaceInfo placeOutput) {
    tourList.add(placeOutput);
  }

  void tourButtonPressed() async {
    isTouring.value = !isTouring.value;
    if (isTouring.value) {
      String kml = createTourKml();
      await runKml(kml);
      await runTour(tourList.value);
    } else {
      await runKml(kml);
      if (lookAtPosition != null) {
        await zoomToLocation(lookAtPosition!);
      }
    }
  }

  String createTourKml() {
    String kml = '';

    for (final place in tourList) {
      kml += KMLGenerator.getTourPOIKML(place);
    }
    for (int i = 0; i < tourList.length - 1; i += 1) {
      kml += KMLGenerator.addTourPaths(tourList[i], tourList[i + 1]);
    }
    print(kml);
    return KMLGenerator.generateKml('69', kml);
  }

  Future<void> zoomToPoi(PlaceInfo place) async {
    //print("loc");
    MapPosition position = MapPosition.fromCameraPosition(
        GeoUtils.getBoundsZoomLevel(
            [place.coordinate.toLatLngMap(place.coordinate)],
            getx.Get.context!.size!));
    await connectionClient.flyToInstantWithoutSaving(position);
    await connectionClient.cleanBalloon();
    print("location req done");
    print(position);
  }

  runTour(List<PlaceInfo> listPoi) async {
    List<LatLng> coordsList = [];
    for (final place in listPoi) {
      coordsList.add(place.coordinate.toLatLngMap(place.coordinate));
      if (!isTouring.value) {
        return;
      }
      await zoomToPoi(place);
      print("zoomed");
      if (!isTouring.value) {
        return;
      }
      MapPosition position = MapPosition.fromCameraPosition(
          GeoUtils.getBoundsZoomLevel(
              [place.coordinate.toLatLngMap(place.coordinate)],
              getx.Get.context!.size!));
      await Future.delayed(Duration(seconds: Constants.zoomInDuration));
      await startOrbit(position);

      MapPosition zoomPosition = MapPosition.fromCameraPosition(
          GeoUtils.getBoundsZoomLevel(
              coordsList,
              getx.Get.context!.size!));
      await connectionClient.flyToInstantWithoutSaving(zoomPosition);
      isTouring.value = false;
      // for (int i = 0; i <= 4; i++) {
      //   print("orbit$i");
      //   await startOrbit(position);
      //   if (!isTouring.value) {
      //     return;
      //   }
      //}
    }



    //await runTour(listPoi);
  }

  Future<void> startOrbit(MapPosition position) async {
    position.tilt = 60.0;
    for (int i = 0; i <= 360; i += 17) {
      if (!isTouring.value) {
        return;
      }
      //print(MapPosition(latitude: position.latitude, longitude: position.longitude, bearing: i.toDouble(), tilt: position.tilt, zoom: position.zoom));
      print("orbitReq");
      connectionClient.flyToOrbit(MapPosition(
          latitude: position.latitude,
          longitude: position.longitude,
          bearing: i.toDouble(),
          tilt: position.tilt,
          zoom: position.zoom));
      await Future.delayed(const Duration(milliseconds: 1000));
    }

    return;
    //startOrbit(position);
  }
}
