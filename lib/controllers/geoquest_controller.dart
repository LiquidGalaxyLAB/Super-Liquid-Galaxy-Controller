import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';
import 'package:super_liquid_galaxy_controller/utils/constants.dart';
import 'package:super_liquid_galaxy_controller/utils/geo_utils.dart';

import '../data_class/country_data.dart';

class GeoQuestController extends GetxController {
  late GoogleMapController _mapController;
  var currentMapType = MapType.normal.obs;
  Timer? _gameTimer;
  var timeFraction = 1.0.obs;
  var minTime = "01".obs;
  var secTime = "30".obs;
  var score = 0.obs;
  var currentCoords = Coordinates(latitude: 0.0, longitude: 0.0).obs;
  var screenCoords = Coordinates(latitude: 0.0, longitude: 0.0).obs;
  var currentState = "".obs;
  var currentCountry = "".obs;
  late List<CountryData> jsonList;
  late List<dynamic> dataList;
  late List<String> choiceList;

  void startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      //print(timer.tick);
      timeFraction.value = 1 - (timer.tick * 0.1 / Constants.geoQuestTime);
      if (timeFraction.value == 0.0) {
        stopTimer();
        onSubmitted();
      }
      if ((timer.tick * 0.1) - (timer.tick * 0.1).toInt() == 0.0) {
        setTime(Constants.geoQuestTime.toInt() - (timer.tick * 0.1).toInt());
      }
    });
  }

  void stopTimer() {
    _gameTimer?.cancel();
  }

  void setTime(int seconds) {
    final duration = Duration(seconds: seconds);
    final min = duration.inMinutes;
    final sec = seconds % 60;

    //print("TIME: $min:$sec");
    minTime.value = "0$min";
    secTime.value = (sec < 10) ? "0$sec" : "$sec";
  }
  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<List<CountryData>> getResponse() async {
    var res = await rootBundle.loadString('assets/data/country.json');
    var list = jsonDecode(res);
    List<CountryData> output = [];
    for (Map<String, dynamic> item in list) {
      CountryData data = CountryData.fromJson(item);
      output.add(data);
    }
    return output;
  }

  Future<void> initializeJsonList() async {
    jsonList = await getResponse();
    dataList = [];
    dataList.addAll(jsonList);
    choiceList = [];
    for (CountryData country in dataList) {
      var stateList = jsonList[jsonList.indexOf(country)].state;
      if (stateList == null || stateList.isEmpty || country.name == null) {
        continue;
      }
      List<StateData> states = [];
      states.addAll(stateList.where((state) {
        return (state.name != null);
      }));
      //print("choice$states");
      for (StateData state in states) {
        choiceList.add("${state.name},${country.name}");
      }
    }
  }

  void startGame() {
    showStartMessage();
  }

  Future<void> showStartMessage() async {
    await Future.delayed(Duration(seconds: 3));
    Get.defaultDialog(
        title: "Welcome to Geo-Quest",
        content: Text(
            textAlign: TextAlign.center,
            "This is a Geo-Guessr like game where the goal is to place the pointer as close to the mentioned state as quick as possible. Earn the highest scores!"),
        confirm: InkWell(
          onTap: () async {
            print("Submitted");
            Get.back();
            await startGameLogic();
          },
          child: Text(
            "START GAME!",
            style: TextStyle(color: Colors.green),
          ),
        ),

        barrierDismissible: false);
  }

  Future<void> startGameLogic() async {

    final _random = Random.secure();

// generate a random index based on the list length
// and use it to retrieve the element
    var element = choiceList[_random.nextInt(choiceList.length)];
    var state = element.split(',')[0];
    var country = element.split(',')[1];
    try {
      print("$state, $country");
      var out = await locationFromAddress("$state, $country").timeout(Duration(seconds: 25), onTimeout: (){
        throw Exception("Location fetch timeout...");
      });
      print(out);
      if (out.isNotEmpty) {
        // widget.submitData(
        //     Coordinates(latitude: out[0].latitude, longitude: out[0].longitude));
        currentCoords.value = Coordinates(latitude: out[0].latitude, longitude: out[0].longitude);
        currentState.value = state;
        currentCountry.value = country;
        startTimer();
      }
      else {

        if (!Get.isSnackbarOpen) {
          Get.showSnackbar(GetSnackBar(
            backgroundColor: Colors.red.shade300,
            title: "Location Error",
            message: "Could not Geocode Area. Please Check your Network. Empty",
            isDismissible: true,
            duration: 3.seconds,
          ));
        }
      }
    }
    catch(e)
    {
      print("here");
      if (!Get.isSnackbarOpen) {
        Get.showSnackbar(GetSnackBar(
          backgroundColor: Colors.red.shade300,
          title: "Location Error",
          message: "Could not Geocode Area. Please Check your Network. $e",
          isDismissible: true,
          duration: 3.seconds,
        ));
      }
    }
  }
  Future<LottieComposition?> customDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(bytes, filePicker: (files) {
      return files.firstWhere(
            (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    });
  }

  void onSubmitted() async {
    stopTimer();
    var targetCoords = currentCoords.value;
    var submittedCoords = screenCoords.value;
    var currentScore = 0.0;
    Get.dialog(
        Lottie.asset(Assets.lottieLoadingspinner,
            decoder: customDecoder, repeat: true,width: 200.0,height: 200.0),
    barrierDismissible: false);
    var submittedState = "";
    try{
      var out = await placemarkFromCoordinates(
          submittedCoords.latitude, submittedCoords.longitude);
      print(out);
      submittedState = "";
      if (out.isNotEmpty) {
        var likelyPoint = out[0];
        if (likelyPoint.administrativeArea == null) {
          for (final item in out) {
            likelyPoint =
                (item.administrativeArea == null) ? likelyPoint : item;
          }
        }
        submittedState = likelyPoint.administrativeArea!;
        print(submittedState);

      }
    }catch(e){
      submittedState = "";
    }
    Navigator.pop(Get.overlayContext!, true);
    bool isCorrect = false;
    if(submittedState.trim().toLowerCase().compareTo(currentState.toLowerCase())==0 )
      {
        currentScore+=500;
        isCorrect = true;
      }
    print("before$currentScore");
    currentScore += GeoUtils.getScore(targetCoords, submittedCoords);
    var distance = GeoUtils.getDistance(targetCoords, submittedCoords);
    print("after$currentScore");

    Get.defaultDialog(
      title: (isCorrect)?"You Guessed Right!":"Nice try!",
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(Assets.lottieCongrats,
                  repeat: false,
                  decoder: customDecoder,width: 200.0,height: 200.0),
              SizedBox(height: 20.0,),
              Visibility(
                  visible: isCorrect,
                  child: Text("CORRECT GUESS BONUS: +500",style: TextStyle(color: Colors.green),)),
              SizedBox(height: 20.0,),
              Text("Distance Difference : $distance KM",style: TextStyle(color: Colors.black, fontSize: 24.0),),
              SizedBox(height: 20.0,),
              Text("Score : $currentScore",style: TextStyle(color: Colors.black, fontSize: 24.0),),

            ],
          ),
        ),

        barrierDismissible: false);
    score.value+=currentScore.toInt();
    await Future.delayed(Duration(seconds: 5));
    Navigator.pop(Get.overlayContext!, true);
    startGameLogic();
  }
}
