import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:super_liquid_galaxy_controller/components/autocomplete_locationfield.dart';
import 'package:super_liquid_galaxy_controller/components/tray_button.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_suggestion_response.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/data_class/map_position.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';
import 'package:super_liquid_galaxy_controller/utils/autocomplete_controller.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';
import 'package:super_liquid_galaxy_controller/utils/lg_connection.dart';
import 'package:super_liquid_galaxy_controller/utils/map_movement_controller.dart';
import 'package:super_liquid_galaxy_controller/utils/speech_controller.dart';

class MapController extends StatefulWidget {
  const MapController({super.key});

  @override
  State<MapController> createState() => MapControllerState();
}

class MapControllerState extends State<MapController> {
  //final Completer<GoogleMapController> _controller =
 //     Completer<GoogleMapController>();

  AutocompleteController textController = AutocompleteController();
  bool locationSet = false;
  MapPosition position = MapPosition(
      latitude: 28.65665656297236,
      longitude: -17.885454520583153,
      bearing: 61.403038024902344,
      tilt: 41.82725143432617,
      zoom: 591657550.500000 / pow(2, 13.15393352508545));

  late LGConnection client;
  late SpeechController speechController;
  late MapMovementController mapMovementController;
  late double screenHeight;
  late double screenWidth;
  bool widgetVisible = true;
  bool voiceCommandActive = false;

  @override
  void initState() {
    super.initState();
    client = Get.find();
    speechController = Get.find();
    mapMovementController = Get.find();

    speechController.setMapController(mapMovementController);
    updateToCurrentLocation();
    bootLGClient();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
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
            onMapCreated: mapMovementController.onMapCreated,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            onLongPress: (LatLng point) {
              setState(() {
                widgetVisible = !widgetVisible;
              });
            },
          ),
        ),
        Visibility(
          visible: widgetVisible,
          child: Material(
            color: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoCompleteLocationField(
                    hintText: "Enter Location to search here",
                    labelText: "",
                    iconData: Icons.search_rounded,
                    textInputType: TextInputType.text,
                    isPassword: false,
                    fillColor: Colors.white,
                    textColor: Colors.black,
                    autocompleteController: textController,
                    seekTo: goToSearchFeature,
                  ),
                )),
          ),
        ),
        Visibility(
          visible: widgetVisible,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(1.0),
                        borderRadius: BorderRadius.circular(20.0),
                        backgroundBlendMode: BlendMode.screen),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TrayButton(
                          icon: Assets.iconsMic,
                          color: voiceCommandActive ?Colors.green:Colors.grey.shade700,
                          text: "VOICE \n COMMANDS",
                          iconSize: screenHeight * 0.07,
                          action: (){
                            setState(() {
                              voiceCommandActive = !voiceCommandActive;
                            });
                          },
                        ),
                        Obx(() {
                          return TrayButton(
                            icon: Assets.iconsSync,
                            color: client.isConnected.value
                                ? Colors.green
                                : Colors.red,
                            text: "SYNC TO \n  LG",
                            iconSize: screenHeight * 0.07,
                            action: (){
                              bootLGClient();
                            },
                          );
                        }),
                        TrayButton(
                          icon: Assets.iconsNearbypoi,
                          color: Colors.black,
                          text: "NEARBY \n POIs",
                          iconSize: screenHeight * 0.07,
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Visibility(
            visible: voiceCommandActive,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Obx((){
                print('mapTest: command word ui ${speechController.commandWord.value}');
                return Row(
                  children: [
                    AvatarGlow(
                      glowColor: Colors.white,
                      glowShape: BoxShape.circle,
                      animate: speechController.isListening.value,
                      curve: Curves.fastOutSlowIn,
                      child: Material(
                        elevation: 8.0,
                        shape: CircleBorder(),
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20.0),
                          onTapUp: (TapUpDetails tapdetails) {
                            print('up: ${tapdetails.kind}');
                            speechController.stopListening();
                          },
                          onTapDown: (TapDownDetails details) {
                            print('down: ${details.kind}');
                            speechController.startListening();
                          },
                          onTapCancel: () {
                            print('cancel');
                            speechController.stopListening();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(Assets.iconsMic),
                              radius: screenHeight *0.05,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: screenWidth*0.07,),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: Container(
                            height: screenHeight*0.06,
                            width: screenWidth*0.2,
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                                backgroundBlendMode: BlendMode.screen),
                            child: Center(
                              child: Text(
                                speechController.commandWord.value,
                                style: const TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.grey,
                          width: screenWidth*0.2,
                          height: 2.0,
                        ),
                        Container(
                          width: screenWidth*0.2,
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              backgroundBlendMode: BlendMode.screen),
                          child: Material(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(speechController.wordsString.value,style: const TextStyle(color: Colors.black,fontSize: 12.0),),),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                );
              }

              )
            ),
          ),
        )
      ]),
    );
  }

  void _onCameraMove(CameraPosition camera) async {
    if (!locationSet) {
      return;
    }
    position.updateFromCameraPosition(camera);
    print(position);
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

  void goToSearchFeature(Features place) async {
    position.updateFromCoordinates(Coordinates(
        latitude: place.properties!.lat!, longitude: place.properties!.lon!));
    // final GoogleMapController controller = await _controller.future;
    // await controller.animateCamera(
    //     CameraUpdate.newCameraPosition(position.toCameraPosition()));
    mapMovementController.moveTo(position.toCameraPosition());
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
      Get.dialog(
        AlertDialog(
          title: const Text(
            'LG Connection Error',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
              'Connection to the Liquid Galaxy rig could not be established. \nPlease go to the settings page and re-enter credentials. \nThe map will work in stand-alone mode till then.'),
          actions: [
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      );
    }
    else
      {
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
}
