import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:super_liquid_galaxy_controller/components/galaxytextfield.dart';
import 'package:super_liquid_galaxy_controller/components/location_selector.dart';
import 'package:super_liquid_galaxy_controller/controllers/tour_controller.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';
import 'package:super_liquid_galaxy_controller/screens/place_view_poi.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';

import '../components/glassbox.dart';
import '../data_class/place_info.dart';

class PoiExploration extends StatefulWidget {
  const PoiExploration({super.key});

  @override
  State<PoiExploration> createState() => _PoiExplorationState();
}

class _PoiExplorationState extends State<PoiExploration> {
  late double screenHeight;
  late double screenWidth;
  late TourController tourController;
  TextEditingController queryController = TextEditingController();
  ScrollController queryScrollController = ScrollController();
  ScrollController tourScrollController = ScrollController();
  //late AnimationController lottieController;

  List<String> tourismCategories = [
    "city_gate",
    "archaeological_site",
    "sights",
    "attraction",
    "temple",
    "memorial",
    "place_of_worship",
    "artwork",
    "viewpoint",
    "monument",
    "castle",
    "ruines",
    "tomb",
    "shrine",
    "wayside_cross",
    "chapel",
    "fort",
    "tower",
    "locomotive",
    "battlefield",
    "boundary_stone",
    "default"
  ];
  List<String> assetPaths = [
    Assets.placeIconsGate,
    Assets.placeIconsArchaeology,
    Assets.placeIconsSights,
    Assets.placeIconsSights,
    Assets.placeIconsTemple,
    Assets.placeIconsObelisk,
    Assets.placeIconsTemple,
    Assets.placeIconsSights,
    Assets.placeIconsObelisk,
    Assets.placeIconsCastle,
    Assets.placeIconsArchaeology,
    Assets.placeIconsTombstone,
    Assets.placeIconsShrine,
    Assets.placeIconsTombstone,
    Assets.placeIconsChapel,
    Assets.placeIconsCastle,
    Assets.placeIconsObelisk,
    Assets.placeIconsObelisk,
    Assets.placeIconsObelisk,
    Assets.placeIconsStrategy,
    Assets.placeIconsObelisk,
    Assets.placeIconsObelisk,
  ];

  @override
  void initState() {
    tourController = Get.find();
    //lottieController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    //_determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    tourController.context = context;
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
            ),
          ),
          Scaffold(
            resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              /*floatingActionButton: Container(
                height: screenHeight * 0.125,
                width: screenWidth * 0.2,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: FloatingActionButton.extended(
                      elevation: 20.0,
                      onPressed: () {
                        tourController.tourButtonPressed();
                      },
                      backgroundColor: Colors.white,
                      label: Container(
                          width: screenWidth * 0.1,
                          // color: Colors.orange.withOpacity(0.2),
                          child: FittedBox(
                              fit: BoxFit.contain, child: Text("START TOUR"))),
                      icon: Container(
                        //height: screenHeight * 0.1,
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: Obx(() {
                                lottieController?.dispose();
                                lottieController = AnimationController(
                                    vsync: this,
                                    duration: const Duration(seconds: 2));
                                return (tourController.isTouring.value)?Lottie.asset(Assets.lottieOrbitBlack,
                                    decoder: customDecoder,
                                    repeat: true,
                                    controller: lottieController,
                                    fit: BoxFit.fill,
                                    width: 25.0,
                                    height: 25.0, onLoaded: (c) {
                                      //lottieController.forward(from: 0.0);
                                      lottieController?.repeat();
                                    }):ImageIcon(
                                    AssetImage(Assets.iconsOrbit));

                                *//*return Stack(
                              children: [


                                Visibility(
                                  visible: !tourController.isTouring.value,
                                    child: ImageIcon(
                                        AssetImage(Assets.iconsOrbit))),
                                Visibility(
                                  visible: tourController.isTouring.value,
                                  child: Lottie.asset(Assets.lottieOrbit,
                                      decoder: customDecoder,
                                      repeat: true,
                                      controller: lottieController,
                                      fit: BoxFit.fill,
                                      width: 25.0,
                                      height: 25.0, onLoaded: (c) {
                                    //lottieController.forward(from: 0.0);
                                    lottieController?.repeat();
                                  }),
                                )
                              ],
                            );*//*
                              })))),
                ),
              ),*/
              appBar: AppBar(
                  toolbarHeight: screenHeight * 0.11,
                  backgroundColor: Colors.transparent,
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ImageIcon(
                          const AssetImage(Assets.placeIconsObelisk),
                          color: Colors.white,
                          size: screenHeight * 0.1,
                        ),
                        const SizedBox(width: 20),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                          child: Text(
                            "POI EXPLORATION",
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
                              const AssetImage(Assets.iconsSshIndicator),
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
                              const AssetImage(Assets.iconsApiIndicator),
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
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /*Center(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 15.0, sigmaX: 15.0),
                        child: Container(
                          height: screenHeight * 0.25,
                          width: screenWidth * 0.93,
                          decoration: BoxDecoration(
                              color: GalaxyColors.lightgrey.withOpacity(0.35),
                              backgroundBlendMode: BlendMode.screen,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              child: Obx(() {
                                return Scrollbar(
                                  //trackVisibility: true,
                                  thickness: 5.0,
                                  radius: const Radius.circular(20.0),
                                  thumbVisibility:
                                  tourController.tourList.isNotEmpty,
                                  controller: tourScrollController,

                                  child: Stack(children: [
                                    Visibility(
                                      visible: tourController.tourList.isNotEmpty,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        controller: tourScrollController,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Container(
                                              height: screenHeight * 0.23,
                                              width: (index ==
                                                  tourController
                                                      .tourList.length -
                                                      1)
                                                  ? screenWidth * 0.2
                                                  : screenWidth * 0.4,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Expanded(
                                                              flex: 4,
                                                              child: FittedBox(
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  child:
                                                                  ImageIcon(
                                                                    AssetImage(tourismCategories.contains(tourController
                                                                        .tourList[
                                                                    index]
                                                                        .category)
                                                                        ? (assetPaths[tourismCategories.indexOf(tourController
                                                                        .tourList[
                                                                    index]
                                                                        .category)])
                                                                        : (assetPaths[
                                                                    assetPaths.length -
                                                                        1])),
                                                                    color: Colors
                                                                        .white,
                                                                  ))),
                                                          Expanded(
                                                              flex: 2,
                                                              child: FittedBox(
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  child: Text(
                                                                    tourController
                                                                        .tourList[
                                                                    index]
                                                                        .name,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ))),
                                                          Expanded(
                                                              flex: 4,
                                                              child: Text(
                                                                tourController
                                                                    .tourList[
                                                                index]
                                                                    .address,
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                                maxLines: 3,
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                      visible: !(index ==
                                                          tourController.tourList
                                                              .length -
                                                              1),
                                                      child: const SizedBox(
                                                        width: 12.0,
                                                      )),
                                                  Visibility(
                                                    visible: !(index ==
                                                        tourController
                                                            .tourList.length -
                                                            1),
                                                    child: Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        child: Row(
                                                          mainAxisSize:
                                                          MainAxisSize.max,
                                                          children: [
                                                            Container(
                                                              width:
                                                              screenHeight *
                                                                  0.03,
                                                              height:
                                                              screenHeight *
                                                                  0.03,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      300.0),
                                                                  color: Colors
                                                                      .green),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                height:
                                                                screenHeight *
                                                                    0.005,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        300.0),
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                            ),
                                                            Container(
                                                              width:
                                                              screenHeight *
                                                                  0.035,
                                                              height:
                                                              screenHeight *
                                                                  0.035,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      300.0),
                                                                  color: Colors
                                                                      .green),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: tourController.tourList.length,
                                      ),
                                    ),
                                    Obx(() {
                                      return Visibility(
                                        visible: tourController.tourList.isEmpty,
                                        child: Center(
                                          child: Container(
                                            width: screenWidth * 0.5,
                                            //color: Colors.orange.withOpacity(0.2),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Lottie.asset(
                                                    Assets.lottieAddplaces,
                                                    decoder: customDecoder,
                                                    repeat: true,
                                                  ),
                                                ),
                                                const Expanded(
                                                    child: FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Padding(
                                                          padding: EdgeInsets.all(
                                                              15.0),
                                                          child: Text(
                                                              "ADD PLACES \nTO TOUR",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                        )))
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                  ]),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),*/
                    const SizedBox(
                      height: 10.0,
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
                                    controller: queryController,
                                    iconData: Icons.search_rounded,
                                    textInputType: TextInputType.text,
                                    fillColor:
                                    GalaxyColors.lightgrey.withOpacity(0.25),
                                    onTextChanged: (query) {
                                      tourController.filterList(query);
                                    },
                                    focusColor: Colors.white,
                                    labelWeight: FontWeight.w300,
                                    paddingSize: 0.0,
                                    contentPadding: 40.0,
                                    isPassword: false)),
                            LocationSelector(
                              width: screenWidth * 0.25,
                              iconSize: screenHeight * 0.1,
                              searchSize: screenWidth * 0.85,
                              tourController: tourController,
                              submitData: (Coordinates point, String label) {
                                setSearchAround(point, label);
                                queryController.clear();
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          child: Obx(() {
                            return Stack(children: [
                              Visibility(
                                visible: tourController.placeList.isNotEmpty &&
                                    !tourController.isLoading.value &&
                                    !tourController.isError.value,
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  thickness: 5.0,
                                  controller: queryScrollController,
                                  radius: Radius.circular(20.0),
                                  child: ListView.builder(
                                    controller: queryScrollController,
                                    itemBuilder: (_, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: screenHeight * 0.13,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: screenHeight * 0.13,
                                                    decoration: BoxDecoration(
                                                        color: GalaxyColors
                                                            .prussianBlue
                                                            .withOpacity(0.3),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        if(tourController.isTouring.value)
                                                        {
                                                          tourController.tourButtonPressed();
                                                        }
                                                        var output = await Get.to(
                                                                () => PlaceViewPoi(
                                                                place: tourController
                                                                    .placeList[
                                                                2 * index]));
                                                        if (output != null) {
                                                          print(output);
                                                          // PlaceInfo placeOutput =
                                                          //     output;
                                                          // tourController
                                                          //     .addToTourList(
                                                          //     placeOutput);
                                                        }
                                                        tourController.runKml(
                                                            tourController.kml);
                                                        if (tourController
                                                            .lookAtPosition !=
                                                            null) {
                                                          tourController.zoomToLocation(
                                                              tourController
                                                                  .lookAtPosition!);
                                                        }
                                                      },
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 30.0),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                flex: 1,
                                                                child: Container(
                                                                    child: FittedBox(
                                                                        fit: BoxFit.contain,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              5.0),
                                                                          child:
                                                                          ImageIcon(
                                                                            AssetImage(
                                                                              assetPaths[(tourismCategories.contains(tourController.placeList[2 * index].category))
                                                                                  ? (tourismCategories.indexOf(tourController.placeList[2 * index].category))
                                                                                  : (tourismCategories.length - 1)],
                                                                            ),
                                                                            color: Colors
                                                                                .white,
                                                                          ),
                                                                        )))),
                                                            SizedBox(
                                                              width: 8.0,
                                                            ),
                                                            Expanded(
                                                                flex: 6,
                                                                child: Container(
                                                                    child: FittedBox(
                                                                        fit: BoxFit.contain,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal:
                                                                              8.0,
                                                                              vertical:
                                                                              5.0),
                                                                          child:
                                                                          Text(
                                                                            tourController.placeList[2 * index].label.compareTo('') ==
                                                                                0
                                                                                ? tourController.placeList[2 * index].name
                                                                                : tourController.placeList[2 * index].label,
                                                                            style:
                                                                            TextStyle(
                                                                              color:
                                                                              Colors.white,
                                                                            ),
                                                                          ),
                                                                        ))))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: ((index !=
                                                    ((tourController.placeList
                                                        .length %
                                                        2 ==
                                                        0)
                                                        ? tourController
                                                        .placeList
                                                        .length ~/
                                                        2 -
                                                        1
                                                        : ((tourController
                                                        .placeList
                                                        .length ~/
                                                        2)))) ||
                                                    tourController
                                                        .placeList.length %
                                                        2 ==
                                                        0),
                                                child: Expanded(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: GalaxyColors
                                                              .prussianBlue
                                                              .withOpacity(0.3),
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              20.0)),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          if ((index !=
                                                              ((tourController.placeList.length %
                                                                  2 ==
                                                                  0)
                                                                  ? tourController
                                                                  .placeList
                                                                  .length ~/
                                                                  2 -
                                                                  1
                                                                  : ((tourController
                                                                  .placeList
                                                                  .length ~/
                                                                  2)))) ||
                                                              tourController
                                                                  .placeList
                                                                  .length %
                                                                  2 ==
                                                                  0) {
                      
                                                            if(tourController.isTouring.value)
                                                            {
                                                              tourController.tourButtonPressed();
                                                            }
                                                            var output = await Get
                                                                .to(() => PlaceViewPoi(
                                                                place: tourController
                                                                    .placeList[2 *
                                                                    index +
                                                                    1]));
                                                            if (output != null) {
                                                              print(output);
                                                              // PlaceInfo
                                                              // placeOutput =
                                                              //     output;
                                                              // tourController
                                                              //     .addToTourList(
                                                              //     placeOutput);
                                                            }
                                                            tourController.runKml(
                                                                tourController.kml
                                                            );
                                                            if (tourController
                                                                .lookAtPosition !=
                                                                null) {
                                                              tourController
                                                                  .zoomToLocation(
                                                                  tourController
                                                                      .lookAtPosition!);
                                                            }
                                                          }
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 30.0),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  flex: 1,
                                                                  child: Container(
                                                                      child: FittedBox(
                                                                          fit: BoxFit.contain,
                                                                          child: Padding(
                                                                            padding: const EdgeInsets
                                                                                .all(
                                                                                5.0),
                                                                            child:
                                                                            ImageIcon(
                                                                              AssetImage(
                                                                                ((index != ((tourController.placeList.length % 2 == 0) ? tourController.placeList.length ~/ 2 - 1 : ((tourController.placeList.length ~/ 2)))) || tourController.placeList.length % 2 == 0)
                                                                                    ? assetPaths[(tourismCategories.contains(tourController.placeList[2 * index + 1].category)) ? (tourismCategories.indexOf(tourController.placeList[2 * index + 1].category)) : (tourismCategories.length - 1)]
                                                                                    : assetPaths[assetPaths.length - 1],
                                                                              ),
                                                                              color:
                                                                              Colors.white,
                                                                            ),
                                                                          )))),
                                                              SizedBox(
                                                                width: 8.0,
                                                              ),
                                                              Expanded(
                                                                  flex: 6,
                                                                  child: Container(
                                                                      child:
                                                                      FittedBox(
                                                                          fit: BoxFit.contain,
                                                                          child:
                                                                          Padding(
                                                                            padding:
                                                                            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                                                                            child:
                                                                            Text(
                                                                              ((index != ((tourController.placeList.length % 2 == 0) ? tourController.placeList.length ~/ 2 - 1 : ((tourController.placeList.length ~/ 2)))) || tourController.placeList.length % 2 == 0) ? tourController.placeList[2 * index + 1].label : 'Blah',
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                          )
                                                                      )
                                                                  )
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount:
                                    ((tourController.placeList.length % 2 == 0)
                                        ? tourController.placeList.length ~/ 2
                                        : ((tourController.placeList.length ~/
                                        2) +
                                        1)),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: tourController.isLoading.value,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Lottie.asset(
                                          Assets.lottieLoadingPlaces,
                                          decoder: customDecoder,
                                          repeat: true,
                                        ),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Text("Places are Loading...",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 35.0))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: (tourController.isError.value ||
                                    tourController.placeList.isEmpty) &&
                                    !tourController.isLoading.value,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Lottie.asset(
                                          Assets.lottieLoadingFailed,
                                          decoder: customDecoder,
                                          repeat: true,
                                        ),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Text(
                                            tourController.isError.value
                                                ? "Error occured while fetching places"
                                                : "No Places found to visit here",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 35.0))
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ]);
                          })
                      
                          /*GridView.builder(
                          itemCount: 12,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (_, int index) {
                            return InkWell(
                                onTap: () {
                                  //tap
                                },
                                onLongPress: () {
                                  //long press
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: MaterialButton(
                                    onPressed: () {},
                                    color: Colors.white.withOpacity(0.6),
                                    height: screenHeight*0.15,
                                  ),
                                ));
                          })*/
                          ,
                        ),
                      ),
                    )
                  ],
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
          Coordinates(latitude: point.latitude, longitude: point.longitude),
          'Default');
    });
  }

  void setSearchAround(Coordinates point, String label) {
    setState(() {
      tourController.setSearchAround(point, label);
    });
    print(tourController.getSearchAround());
  }

  Future<LottieComposition?> customDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(bytes, filePicker: (files) {
      return files.firstWhere(
            (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    });
  }
}
