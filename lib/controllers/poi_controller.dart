import 'dart:io';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_info.dart';
import 'package:super_liquid_galaxy_controller/screens/test.dart';
import 'package:super_liquid_galaxy_controller/utils/constants.dart';
import 'package:super_liquid_galaxy_controller/utils/wikidatafetcher.dart';

import '../data_class/map_position.dart';
import '../utils/geo_utils.dart';
import '../utils/kmlgenerator.dart';
import 'api_manager.dart';
import 'lg_connection.dart';

class PoiController extends GetxController {
  late ApiManager apiClient;
  late LGConnection connectionClient;
  late WikiDataFetcher dataFetcher;
  //late PlaceInfo place;

  var descriptionIsLoading = false.obs;
  var descriptionIsError = false.obs;
  var imageIsLoading = false.obs;
  var imageIsError = false.obs;
  var isOrbit = false.obs;
  var isVoicing = false.obs;

  var description = ''.obs;
  var imageLink = ''.obs;
  var poiList = <PlaceInfo>[].obs;
  var place = PlaceInfo(coordinate: Coordinates(latitude: 0.0, longitude: 0.0), label: "Loading...", address: "Loading..", category: "Loading...", name: "Loading....").obs;

  FlutterTts flutterTts = FlutterTts();

  @override
  void onInit() {
    apiClient = Get.find();
    connectionClient = Get.find();
    dataFetcher = WikiDataFetcher();
    //flutterTts.setLanguage("en-US");
    flutterTts.setCompletionHandler((){
      print("completed");
      isVoicing.value = false;
    });
    super.onInit();
  }

  void setInfo(PlaceInfo pl) {
    place.value = pl;
    //screenSize = s;
    //context = con;
    description.value = place.value.description ?? '';
    imageLink.value = place.value.imageLink ?? '';
    poiList.clear();
  }

  void fetchAllInfo() async {
    await fetchDescription();
    await loadImage();
    await fetchNearbyPois();
    await setKML();
    await zoomToLocation();
  }

  void voiceButtonPressed() async {
    if (isVoicing.value) {
      isVoicing.value = false;
      flutterTts.stop();
    } else {
      isVoicing.value = true;
      print("playing");
      String text;

      if (description.value.indexOf('\t') != -1) {
        text = description.value.substring(
            0,
            min(description.value.indexOf('\t'),
                min(1500, description.value.length - 1)));
      } else {
        text = description.value.substring(
            0,

                min(1500, description.value.length - 1));
      }
      print(text);
      var state = await flutterTts.speak(text);


      print("started $state");

      await flutterTts.awaitSpeakCompletion(true);
      print("completed");
      isVoicing.value = false;
    }
  }

  Future<void> fetchDescription() async {
    descriptionIsLoading.value = true;
    descriptionIsError.value = false;
    dataFetcher.setData(place.value);
    try {
      description.value = await dataFetcher.getInfo() ?? "Loading....";
      if (description.value == "Loading....") {
        throw Exception("No Data Found");
      }
      place.value.description = description.value;
      descriptionIsLoading.value = false;
      descriptionIsError.value = false;
    } catch (e) {
      descriptionIsLoading.value = false;
      descriptionIsError.value = true;
    }
  }

  Future<void> loadImage() async {
    imageIsLoading.value = true;
    imageIsError.value = false;
    try {
      imageLink.value = await dataFetcher.getImages() ?? '';
      place.value.imageLink = imageLink.value;
      if (imageLink.value == "") {
        throw Exception("No Data Found");
      }
      imageIsLoading.value = false;
      imageIsError.value = false;
    } catch (e) {
      imageIsLoading.value = false;
      imageIsError.value = true;
    }
    print("masterLink: ${imageLink.value}");
  }

  Future<void> fetchNearbyPois() async {
    try {
      var response = await apiClient.tryPlaceResponseForCoordinates(
          place.value.coordinate);
      print(response.places);
      print(response.obj);
      print(response.kml);
      if (response.places.isNotEmpty) {
        poiList.clear();
        poiList.addAll(response.places);
      }
    }
    catch(error)
    {
      if(!Get.isSnackbarOpen)
        {
          Get.showSnackbar(GetSnackBar(
            backgroundColor: Colors.red.shade300,
            title: "Network Error",
            message: "Error: $error",
            isDismissible: true,
            duration: 2.seconds,
          ));
        }
      fetchNearbyPois();
    }
  }

  /*zoomToBoundsLocation() async
  {
    print("bounds");
    List<maps.LatLng> points= [];
    points.add(place.value.coordinate.toLatLngMap(place.value.coordinate));
    for(final point in poiList)
      {
        points.add(point.coordinate.toLatLngMap(point.coordinate));
      }
    MapPosition position =
    MapPosition.fromCameraPosition(
        GeoUtils.getBoundsZoomLevel(
            points,
            Get.context!.size!));
    position.updateFromCoordinates(place.value.coordinate);
    await connectionClient.flyToInstantWithoutSaving(position);
    await connectionClient.cleanBalloon();
    print(position);
  }*/

  zoomToLocation() async {
    print("loc");
    MapPosition position =
    MapPosition.fromCameraPosition(
        GeoUtils.getBoundsZoomLevel(
            [place.value.coordinate.toLatLngMap(place.value.coordinate)],
            Get.context!.size!));

    //String kml= KMLGenerator.generateKml('69', KMLGenerator.orbitLookAtLinear(position));
    //Get.to(()=> TestScreen(kml: kml));
    await connectionClient.flyToInstantWithoutSaving(position);
    await connectionClient.cleanBalloon();
    print(position);
  }

  startOrbit(MapPosition position) async
  {
    /*MapPosition position =
    MapPosition.fromCameraPosition(
        GeoUtils.getBoundsZoomLevel(
            [place.value.coordinate.toLatLngMap(place.value.coordinate)],
            MediaQuery.of(context).size));*/
    //await Future.delayed(const Duration(milliseconds: 8000));
    position.tilt = 60.0;
    for (int i = 0; i <= 360; i += 17) {
      if(!isOrbit.value)
        {
          return;
        }
      //print(MapPosition(latitude: position.latitude, longitude: position.longitude, bearing: i.toDouble(), tilt: position.tilt, zoom: position.zoom));
      connectionClient.flyToOrbit(
          MapPosition(latitude: position.latitude, longitude: position.longitude, bearing: i.toDouble(), tilt: position.tilt, zoom: position.zoom));
      await Future.delayed(const Duration(milliseconds: 1000));
    }

    startOrbit(position);
  }

  void orbitButtonPressed() async {
    isOrbit.value = !isOrbit.value;
    if(isOrbit.value)
      {
        await zoomToLocation();
        MapPosition position =
        MapPosition.fromCameraPosition(
            GeoUtils.getBoundsZoomLevel(
                [place.value.coordinate.toLatLngMap(place.value.coordinate)],
                Get.context!.size!));
        print("sizes: ${Get.context!.size!}");
        print("sizes: ${Get.size}");

        await startOrbit(position);
      }
    else{
      await zoomToLocation();
    }

  }

  setKML() {
    String kml = KMLGenerator.generateKml('69', KMLGenerator.getPOIKML(place.value, poiList));
    runKml(kml);
  }

  Future<void> runKml(String kmlResponse) async {

    //print("tapped");
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
