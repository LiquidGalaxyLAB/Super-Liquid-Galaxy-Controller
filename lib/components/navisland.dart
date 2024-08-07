import 'dart:ui';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_liquid_galaxy_controller/controllers/lg_connection.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/screens/geoquest.dart';
import 'package:super_liquid_galaxy_controller/screens/kml_builder.dart';
import 'package:super_liquid_galaxy_controller/screens/maps_controller.dart';
import 'package:super_liquid_galaxy_controller/screens/poi_exploration.dart';
import 'package:super_liquid_galaxy_controller/screens/test.dart';
import 'package:super_liquid_galaxy_controller/screens/tour_builder.dart';
import 'package:super_liquid_galaxy_controller/utils/balloongenerator.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';
import 'package:super_liquid_galaxy_controller/utils/kmlgenerator.dart';

import '../generated/assets.dart';
import '../utils/constants.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class NavIsland extends StatelessWidget {
  NavIsland({super.key, required this.height, required this.width, this.child, required this.getPlanet,required this.changePlanet});

  double height;
  double width;
  Widget? child;
  Function() getPlanet;
  Function() changePlanet;

  int i =0;

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
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(15),
                      //     color: Colors.black.withOpacity(0.4)),
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
                        onTap: () async {
                          if(getPlanet()!=0)
                            {
                              await changePlanet();
                            }
                          Get.to(() => PoiExploration());
                        },
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
                              onTap: () async {
                                if(getPlanet()!=0)
                                {
                                  await changePlanet();
                                }
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



                                        if(getPlanet()!=0)
                                        {
                                          await changePlanet();
                                        }
                                        Get.to(()=>GeoQuest());

                                        

                                        /*i++;
                                        try {
                                          LGConnection connection = Get.find();
                                          await connection.cleanBalloon();
                                          await connection.renderInSlave(2,(i%2==0)?Constants.testKml:Constants.testKml1);
                                        } catch (e) {
                                          if (!Get.isSnackbarOpen) {
                                            Get.showSnackbar(GetSnackBar(
                                              backgroundColor:
                                                  Colors.red.shade300,
                                              title: "Error",
                                              message: "$e",
                                              isDismissible: true,
                                              duration: 5.seconds,
                                            ));
                                          }
                                        }*/

                                        /*Coordinates start = Coordinates(latitude: 0.0, longitude: 0.0);
                                        Coordinates end = Coordinates(latitude: 12.0, longitude: 12.0);
                                        final distance = Distance();
                                        final length = distance.distance(start.toLatLng(start), end.toLatLng(end));
                                        String kml = KMLGenerator.generatefootPrintLine(start.toLatLng(start), end.toLatLng(end), length/10, length/20);
                                        Get.to(()=>TestScreen(kml: KMLGenerator.generateKml('69', kml)));*/

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
                                      onTap: () async {
                                        if(getPlanet()!=0)
                                        {
                                          await changePlanet();
                                        }
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
                                      onTap: () async {
                                        if(getPlanet()!=0)
                                        {
                                          await changePlanet();
                                        }
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
