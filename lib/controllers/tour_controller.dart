import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as getx;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:super_liquid_galaxy_controller/controllers/api_manager.dart';
import 'package:super_liquid_galaxy_controller/controllers/lg_connection.dart';
import 'package:super_liquid_galaxy_controller/data_class/hive_info.dart';
import 'package:super_liquid_galaxy_controller/data_class/map_position.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_details_response.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_info.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_response.dart';
import 'package:super_liquid_galaxy_controller/screens/test.dart';
import 'package:super_liquid_galaxy_controller/utils/balloongenerator.dart';
import 'package:super_liquid_galaxy_controller/utils/constants.dart';
import 'package:super_liquid_galaxy_controller/utils/geo_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
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
  String tourKml = "";
  String tourBalloon = "";
  MapPosition? lookAtPosition;
  List<PlaceInfo> masterList = <PlaceInfo>[];
  getx.RxList<PlaceInfo> placeList = <PlaceInfo>[].obs;
  getx.RxList<getx.RxList<PlaceInfo>> savedList = <getx.RxList<PlaceInfo>>[].obs;
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
    setupHive();
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
      if(!apiClient.isConnected.value)
        {
          print("error here: ApiClient Disconnected");
          isLoading.value = false;
          isError.value = true;
          return;
        }

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
      adjustPlaceMarks();
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
        //await runKml(kmlResponse);
        if (context != null) {
          var position = MapPosition.fromCameraPosition(
              GeoUtils.getBoundsZoomLevel(coords, getScreenSize(context!)));
          lookAtPosition = position;
          //await connectionClient.moveTo(position);
        }

        //tourBalloon = BalloonGenerator.listBalloon(placeList, connectionClient.rigCount().rightMostRig.toInt());
        if(lookAtPosition!=null && connectionClient.isConnected.value) {
          tourBalloon = BalloonGenerator.listBalloonForTours(placeList, connectionClient.rigCount().rightMostRig.toInt(),lookAtPosition!);
        }
        else{
          tourBalloon = BalloonGenerator.listBalloonForTours(placeList, 3, lookAtPosition!);
        }
        adjustPlaceMarks();
      }
    }on FormatException {
      rethrow;
    }
    catch (e) {
      print("error here: ${e}");
      isLoading.value = false;
      isError.value = true;
    }

      await setTourKMLs();

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
      tourKml = kml;
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

  Future<void> setTourKMLs() async {
    print("Tour p1");
    if (lookAtPosition != null) {
      await zoomToLocation(lookAtPosition!);
      if(tourBalloon == "" && connectionClient.isConnected.value)
        {
          tourBalloon = BalloonGenerator.listBalloonForTours(placeList, connectionClient.rigCount().rightMostRig.toInt(),MapPosition(latitude: placeList.first.coordinate.latitude, longitude: placeList.first.coordinate.longitude, bearing: 0.0, tilt: 45, zoom: 5));
        }
    }
    print("Tour p2");
    try {
      await connectionClient.cleanBalloon();
      int rigCount = 0;
      try{
        rigCount=connectionClient.rigCount().rightMostRig.toInt();
      }catch(e)
    {
      rigCount=3;
    }
    print("Tour p3");
      await connectionClient.renderInSlave(rigCount, tourBalloon);
    }
    catch(e)
    {
      print("$e");
    }
    await runKml(kml);
    //getx.Get.to(()=>TestScreen(kml: kml));
  }

  Future<void> zoomToPoi(PlaceInfo place) async {
    //print("loc");
    MapPosition position = MapPosition.fromCameraPosition(
        GeoUtils.getBoundsZoomLevel(
            [place.coordinate.toLatLngMap(place.coordinate)],
            getx.Get.context!.size!));
    await connectionClient.flyToInstantWithoutSaving(position);
    //await connectionClient.cleanBalloon();
    print("location req done");
    print(position);
  }

  runTour(List<PlaceInfo> listPoi) async {
    List<LatLng> cc = [];
    for (final place in listPoi) {
      print("now running ${place.name}");
      cc.add(place.coordinate.toLatLngMap(place.coordinate));
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
      await connectionClient.cleanBalloon();
      await connectionClient.renderBalloon(BalloonGenerator.poiBalloonForTours(place, position));
      await Future.delayed(Duration(seconds: Constants.zoomInDuration));
      await startOrbit(position, place);

      //await runKml(tourKml);
      // for (int i = 0; i <= 4; i++) {
      //   print("orbit$i");
      //   await startOrbit(position);
      //   if (!isTouring.value) {
      //     return;
      //   }
      //}
    }
    print("pois done");
    MapPosition zoomPosition = MapPosition.fromCameraPosition(
        GeoUtils.getBoundsZoomLevel(cc, getx.Get.context!.size!));
    await connectionClient.flyToInstantWithoutSaving(zoomPosition);
    isTouring.value = false;

    //await runTour(listPoi);
  }

  Future<void> startOrbit(MapPosition position, PlaceInfo place) async {
    position.tilt = 60.0;
    String placeKml = KMLGenerator.getTourPOIKML(place);
    await runKml(KMLGenerator.generateKml('69', placeKml));

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
    await runKml(tourKml);
    return;
    //startOrbit(position);
  }

  killAllProcesses()
  {
    label.value = '';
    kml = "";
    tourKml = "";
    tourBalloon = "";
    masterList.clear();
    placeList.value.clear();
    isLoading.value = false;
    isError.value = false;
    isTouring.value = false;
    closeHiveBoxes();
  }

  void saveTour() async {
    //await setupHive();

    final countBox = Hive.box<int>('tourCount');
    //countBox.put('count', 0);
    final listBox = Hive.box<Map>('tourList');

    final lists = listBox.get('lists');
    Map<dynamic,dynamic> mp = lists ?? {};

    List<HiveInfo> hiveList = [];
    for(final place in tourList)
      {
        hiveList.add(HiveInfo.fromPlaceInfo(place));
      }

    if(hiveList.isNotEmpty) {
      mp[mp.length+1] = hiveList;
    }

    listBox.put('lists', mp);
    countBox.put('count', mp.length);
  }

  void updateTours(Map<int, List<HiveInfo>> mp, int count)
  {
    final countBox = Hive.box<int>('tourCount');
    final listBox = Hive.box<Map>('tourList');
    listBox.put('lists', mp);
    countBox.put('count', count);
  }

  void updateSavedTours(List<List<PlaceInfo>> p)
  {
    Map<int, List<HiveInfo>> mp = {};
    for(final (index,info) in p.indexed)
      {
        mp[index] = info.map((e)=>HiveInfo.fromPlaceInfo(e)).toList();
      }
    updateTours(mp, p.length);
  }

  Future<List<List<PlaceInfo>>> getTourLists() async {
    //await setupHive();
    final countBox = Hive.box<int>('tourCount');
    int? count = countBox.get('count');
    print("retrieved count $count");
    final listBox = Hive.box<Map>('tourList');
    final lists = listBox.get('lists');
    Map<dynamic,dynamic> mp = lists ?? {};
    List<List<PlaceInfo>> savedPlaces = [];
    for(final item in mp.values)
      {
        print("item     $item");
        List<PlaceInfo> temp = [];
        for(HiveInfo it in item)
          {
            print("($it),");
            temp.add(it.toPlaceInfo());
          }
        if(temp.isNotEmpty) {
          savedPlaces.add(temp);
        }
      }
    savedList.value.clear();

    for(final item in savedPlaces)
      {
        savedList.value.add(item.obs);
      }
    return savedPlaces;
  }

  Future<void> setupHive() async
  {
    var path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
    Hive.registerAdapter(HiveInfoAdapter());
    Hive.registerAdapter(HiveInfoListAdapter());
    await Hive.openBox<int>('tourCount');
    await Hive.openBox<Map>('tourList');
  }

  void closeHiveBoxes() async {
    //await Hive.close();
  }

  void deleteSavedListItem(int index) {
    savedList.value.removeAt(index);
    updateSavedTours(savedList.value);
  }

  void addCurrentTour() {
    savedList.value.add(tourList);
    updateSavedTours(savedList.value);
  }

  void setCurrentTour(List<PlaceInfo> places) {
    tourList.clear();
    tourList.addAll(places);
  }

  /*Map<int, List<HiveInfo>> getMapFromList(List<HiveInfo> hiveList, ) {
    Map<int,List<HiveInfo>> mp;

  }*/
}

class HiveInfoListAdapter extends TypeAdapter<List<HiveInfo>> {
  @override
  final int typeId = 13;

  @override
  List<HiveInfo> read(BinaryReader reader) {
    return (reader.readList() as List).cast<HiveInfo>();
  }

  @override
  void write(BinaryWriter writer, List<HiveInfo> obj) {
    writer.writeList(obj);
  }
}
