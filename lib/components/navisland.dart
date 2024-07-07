import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:super_liquid_galaxy_controller/screens/kml_builder.dart';
import 'package:super_liquid_galaxy_controller/screens/maps_controller.dart';
import 'package:super_liquid_galaxy_controller/screens/test.dart';
import 'package:super_liquid_galaxy_controller/screens/tour_builder.dart';
import 'package:super_liquid_galaxy_controller/utils/kmlgenerator.dart';

import '../generated/assets.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class NavIsland extends StatelessWidget {
  NavIsland({super.key, required this.height, required this.width, this.child});

  double height;
  double width;
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: width,
          height: height,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.1)
                    ])),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: height * 0.12,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black.withOpacity(0.4)),
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "GALAXY HUB",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: height * 0.05),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          width: double.infinity,
                          height: height * 0.33,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black.withOpacity(0.4)),
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ImageIcon(AssetImage(Assets.iconsLandmark),
                                      size: height * 0.15, color: Colors.white),
                                  Text(
                                    "POI EXPLORATION",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20.0),
                                  ),
                                ],
                              ),
                            )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Get.to(() => TourBuilder());
                              },
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                width: width * 0.34,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.black.withOpacity(0.4)),
                                child: Center(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ImageIcon(AssetImage(Assets.iconsTravel),
                                        size: height * 0.12,
                                        color: Colors.white),
                                    Container(
                                      width: double.infinity,
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Text(
                                            "TOUR \nMANAGEMENT",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        LatLng start = LatLng(1, 5);
                                        LatLng end = LatLng(7, 11);

                                        double dashLength =
                                            10000.0; // Length of each dash in meters
                                        double gapLength =
                                            5000.0; // Length of gap between dashes in meters

                                        String kmlOutput =
                                            KMLGenerator.generatefootPrintLine(
                                                end,
                                                start,
                                                dashLength,
                                                gapLength);
                                        print(kmlOutput.length);

                                        print(kmlOutput);
                                        Get.to(
                                            () => TestScreen(kml: kmlOutput));
                                      },
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color:
                                                Colors.black.withOpacity(0.4)),
                                        child: Center(
                                            child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 10.0),
                                            ImageIcon(
                                                AssetImage(
                                                    Assets.iconsController),
                                                size: height * 0.1,
                                                color: Colors.white),
                                            SizedBox(width: 10.0),
                                            Expanded(
                                              child: Container(
                                                height: double.infinity,
                                                child: FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 12.0),
                                                    child: Text(
                                                      "GEO-QUEST     ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 15.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Expanded(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() => MapController());
                                      },
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color:
                                                Colors.black.withOpacity(0.4)),
                                        child: Center(
                                            child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 10.0),
                                            ImageIcon(
                                                AssetImage(Assets.iconsArcade),
                                                size: height * 0.1,
                                                color: Colors.white),
                                            SizedBox(width: 10.0),
                                            Expanded(
                                                child: Container(
                                                    height: double.infinity,

                                                    child: FittedBox(
                                                      fit: BoxFit.fitWidth,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12.0,
                                                                horizontal:
                                                                    12.0),
                                                        child: Text(
                                                          "LG CONTROLLERS",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 15.0),
                                                        ),
                                                      ),
                                                    ))),
                                          ],
                                        )),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Expanded(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() => KmlUploader());
                                      },
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color:
                                                Colors.black.withOpacity(0.4)),
                                        child: Center(
                                            child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 10.0),
                                            ImageIcon(
                                                AssetImage(Assets.iconsCode),
                                                size: height * 0.1,
                                                color: Colors.white),
                                            SizedBox(width: 10.0),
                                            Expanded(
                                                child: Container(
                                                    height: double.infinity,

                                                    child: FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12.0,
                                                                  vertical:
                                                                      12.0),
                                                          child: Text(
                                                            "KML MAKER     ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 15.0),
                                                          ),
                                                        ))))
                                          ],
                                        )),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
