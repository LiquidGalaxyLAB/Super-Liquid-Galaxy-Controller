import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:super_liquid_galaxy_controller/components/galaxytextfield.dart';
import 'package:super_liquid_galaxy_controller/components/location_selector.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';
import 'package:super_liquid_galaxy_controller/utils/tour_controller.dart';

import '../components/glassbox.dart';

class TourBuilder extends StatefulWidget {
  const TourBuilder({super.key});

  @override
  State<TourBuilder> createState() => _TourBuilderState();
}

class _TourBuilderState extends State<TourBuilder> {
  late double screenHeight;
  late double screenWidth;
  late TourController tourController;

  @override
  void initState() {
    tourController = Get.find();
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Stack(children: [
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Assets.assetsBackgroundspace),
              fit: BoxFit.cover),
        ),
      ),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.75, sigmaY: 0.75),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              toolbarHeight: screenHeight * 0.11,
              backgroundColor: Colors.transparent,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageIcon(
                      const AssetImage(Assets.iconsTravel),
                      color: Colors.white,
                      size: screenHeight * 0.1,
                    ),
                    const SizedBox(width: 20),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                      child: Text(
                        "TOUR MANAGEMENT",
                        style: TextStyle(
                          shadows: [
                            Shadow(color: Colors.white, offset: Offset(0, -8))
                          ],
                          color: Colors.transparent,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              actions: [
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GlassBox(
                        height: screenHeight * 0.1,
                        width: screenHeight * 0.1,
                        cornerRadius: 8.0,
                        backgroundGradient: LinearGradient(colors: [
                          Colors.grey.withOpacity(0.2),
                          Colors.grey.withOpacity(0.2)
                        ]),
                        child: ImageIcon(
                          AssetImage(Assets.iconsSshIndicator),
                          color:
                              tourController.connectionClient.isConnected.value
                                  ? Colors.green
                                  : Colors.red,
                          size: screenHeight * 0.06,
                        )),
                  );
                }),
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GlassBox(
                        height: screenHeight * 0.1,
                        width: screenHeight * 0.1,
                        cornerRadius: 8.0,
                        backgroundGradient: LinearGradient(colors: [
                          Colors.grey.withOpacity(0.2),
                          Colors.grey.withOpacity(0.2),
                        ]),
                        child: ImageIcon(
                          AssetImage(Assets.iconsApiIndicator),
                          color: tourController.apiClient.isConnected.value
                              ? Colors.green
                              : Colors.red,
                          size: screenHeight * 0.07,
                        )),
                  );
                }),
                const SizedBox(
                  width: 50.0,
                )
              ]),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 15.0, sigmaX: 15.0),
                      child: Container(
                        height: screenHeight * 0.35,
                        width: screenWidth * 0.93,
                        decoration: BoxDecoration(
                            color: GalaxyColors.lightgrey.withOpacity(0.35),
                            backgroundBlendMode: BlendMode.screen,
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35.0, vertical: 15.0),
                    child: Container(
                      width: screenWidth * 0.93,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: GalaxyTextField(
                                  hintText: "Search places here...",
                                  labelText: "DISCOVER TOUR DESTINATIONS",
                                  iconData: Icons.search_rounded,
                                  textInputType: TextInputType.text,
                                  fillColor:
                                      GalaxyColors.lightgrey.withOpacity(0.25),
                                  focusColor: Colors.white,
                                  labelWeight: FontWeight.w300,
                                  paddingSize: 0.0,
                                  contentPadding: 40.0,
                                  isPassword: false)),
                          LocationSelector(
                            width: screenWidth * 0.25,
                            iconSize: screenHeight * 0.1,
                            searchSize: screenWidth * 0.85,
                            submitData: (Coordinates point) {
                              setSearchAround(point);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: screenHeight * 0.448,
                      width: screenWidth * 0.93,
                    ),
                  )
                ],
              ),
            ),
          ))
    ]));
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
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var point = await Geolocator.getCurrentPosition();
    //_getCity(locator.latitude, locator.longitude);
    setState(() {
      setSearchAround(
          Coordinates(latitude: point.latitude, longitude: point.longitude));
    });
  }

  void setSearchAround(Coordinates point) {
    setState(() {
      tourController.setSearchAround(point);
    });
    print(tourController.getSearchAround());
  }
}
