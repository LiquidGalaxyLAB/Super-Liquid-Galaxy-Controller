import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linear_timer/linear_timer.dart';
import 'package:super_liquid_galaxy_controller/controllers/autocomplete_controller.dart';
import 'package:super_liquid_galaxy_controller/controllers/geoquest_controller.dart';
import 'package:super_liquid_galaxy_controller/controllers/lg_connection.dart';
import 'package:super_liquid_galaxy_controller/controllers/map_movement_controller.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/data_class/map_position.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';

class GeoQuest extends StatefulWidget {
  const GeoQuest({super.key});

  @override
  State<GeoQuest> createState() => GeoQuestState();
}

class GeoQuestState extends State<GeoQuest> with TickerProviderStateMixin {
  //final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();

  AutocompleteController textController = AutocompleteController();
  bool locationSet = false;
  MapPosition position = MapPosition(
      latitude: 28.65665656297236,
      longitude: -17.885454520583153,
      bearing: 0.0,
      tilt: 41.82725143432617,
      zoom: 18489298.453125);

  late LGConnection client;
  late MapMovementController mapMovementController;
  late GeoQuestController geoQuestController;
  late double screenHeight;
  late double screenWidth;
  bool widgetVisible = true;
  bool voiceCommandActive = false;
  LinearTimerController? controller;

  @override
  void initState() {
    super.initState();
    client = Get.find();
    mapMovementController = Get.find();
    geoQuestController = Get.find();
    geoQuestController.initializeJsonList();
    geoQuestController.processKilled = false;
    //geoQuestController.startGame();
    geoQuestController.screenCoords.value = Coordinates(latitude: position.latitude, longitude: position.longitude) ;
    bootLGClient();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return SafeArea(
      child: Stack(children: [
        Scaffold(
          body: GoogleMap(
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              new Factory<OneSequenceGestureRecognizer>(
                    () => new EagerGestureRecognizer(),
              ),
            ].toSet(),
            minMaxZoomPreference: MinMaxZoomPreference.unbounded,
            mapToolbarEnabled: true,
            tiltGesturesEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            compassEnabled: false,
            mapType: MapType.hybrid,
            initialCameraPosition: position.toCameraPosition(),
            onMapCreated: (controller){
              geoQuestController.onMapCreated(controller);
              mapMovementController.onMapCreated(controller);
            },
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            onLongPress: (LatLng point) {
              setState(() {
                widgetVisible = !widgetVisible;
              });
            },
          ),
        ),
        Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  geoQuestController.startTimer();
                  /*controller?.dispose();
                    controller?.start(restart: true);*/
                });
              },
              child: Image.asset(
                Assets.iconsPin,
                color: null,
                width: screenHeight * 0.15,
                height: screenHeight * 0.15,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Material(
              color: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    width: screenWidth * 0.45,
                    height: screenHeight * 0.125,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16.0,16.0,0.0,16.0),
                              child: Container(
                                child: const FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    "GEO-QUEST",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: VerticalDivider(
                            color: Colors.white,
                            thickness: 3.0,
                          ),
                        ),
                        Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(
                                            8.0, 16.0, 16.0, 2.0),
                                        child: Container(
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text(
                                              "Score:",
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(
                                            8.0, 0.0, 16.0, 16.0),
                                        child: Container(
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Obx((){
                                              return Text(
                                                "${geoQuestController.score}",
                                                style: TextStyle(color: Colors.white),
                                              );
                                            })
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  IconButton(onPressed: (){
                    geoQuestController.showStartMessage();
                  }, color: Colors.white, icon: Icon(Icons.info, size: screenHeight* 0.07,))
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: screenWidth * 0.3,
              height: screenHeight * 0.125,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 3,
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                        child: Container(
                            width: screenHeight * 0.1,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Obx(() {
                                return Text(
                                  "${geoQuestController
                                      .minTime}:${geoQuestController.secTime}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                );
                              }),
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                          width: screenHeight * 0.1,
                          child: Obx(() {
                            return LinearProgressIndicator(
                              value: geoQuestController.timeFraction.value,
                              minHeight: screenHeight * 0.05,
                              backgroundColor: Colors.white,
                              color: GalaxyColors.green,
                            );
                          })),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                        onTap: (){
                          geoQuestController.startGameLogic();
                        },
                        child: Icon(Icons.restart_alt_sharp, color: Colors.white,size: screenHeight*0.07,)),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.1,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Obx(() {
                                      return Text(
                                        (geoQuestController.currentState.value.length !=0)?"${geoQuestController.currentState.value}, ${geoQuestController.currentCountry.value}":"Start game...",
                                        style: TextStyle(color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      );

                                    }),
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: VerticalDivider(
                            color: Colors.white,
                            thickness: 3,
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                child: InkWell(
                                    onTap: () {
                                      geoQuestController.onSubmitted();
                                    },
                                    radius: 150.0,
                                    child: Image.asset(Assets.iconsLocsubmit)),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      radius: 150.0,
                        onTap: (){
                        if(!geoQuestController.gameIsPlaying.value)
                        geoQuestController.startGameLogic();
                        else
                          geoQuestController.stopGameLogic();

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          width: screenWidth * 0.2,
                          height: screenHeight * 0.1,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 8,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(25.0, 16.0, 0.0, 16.0),
                                    child: Obx((){
                                      return Container(
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child:
                                          Text(
                                            geoQuestController.gameIsPlaying.value?"STOP GAME":"START GAME",
                                            style: TextStyle(color: Colors.white,
                                                fontWeight: FontWeight.bold),

                                          ),
                                        ),
                                      );
                                    })
                                  )),
                              Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Icon(Icons.gamepad_rounded, color: Colors.white,size: screenHeight*0.07,)),
                                    ),
                                  )
                            ],
                          ),
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  void _onCameraMove(CameraPosition camera) async {
    position.updateFromCameraPosition(camera);
    geoQuestController.screenCoords.value = Coordinates(latitude: camera.target.latitude, longitude: camera.target.longitude);
    print("camera: $position");
    _onCameraIdle();
  }

  void _onCameraIdle() async {
    await client.moveTo(position);
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      locationSet = true;
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        locationSet = true;
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      locationSet = true;
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var point = await Geolocator.getCurrentPosition();
    //_getCity(locator.latitude, locator.longitude);
    setState(() {
      position.latitude = point.latitude;
      position.longitude = point.longitude;
      locationSet = true;
    });
  }

  void updateToCurrentLocation() async {
    await _determinePosition();
    // final GoogleMapController controller = await _controller.future;
    // await controller.animateCamera(
    //     CameraUpdate.newCameraPosition(position.toCameraPosition()));
    mapMovementController.moveTo(position.toCameraPosition());
  }

  void bootLGClient() async {
    await client.reConnectToLG();
    if (!client.connectStatus()) {
      if (!Get.isSnackbarOpen) {
        Get.showSnackbar(GetSnackBar(
          backgroundColor: Colors.red.shade300,
          title: "COULD NOT CONNECT :(!",
          message: "Could not establish connection with LG rig.",
          isDismissible: true,
          duration: 1.seconds,
        ));
      }

    } else {
      if (!Get.isSnackbarOpen) {
        Get.showSnackbar(GetSnackBar(
          backgroundColor: Colors.green.shade300,
          title: "CONNECTED!",
          message: "Your Maps controller is now connected to the LG rig.",
          isDismissible: true,
          duration: 5.seconds,
        ));
      }
    }
  }

  void updateToInitialLocation() {
    mapMovementController.moveTo(position.toCameraPosition());
  }

  @override
  void dispose() {
    geoQuestController.stopTimer();
    Get.closeAllSnackbars();
    geoQuestController.processKilled = true;
    Get.delete<GeoQuestController>();
    super.dispose();
  }
}
