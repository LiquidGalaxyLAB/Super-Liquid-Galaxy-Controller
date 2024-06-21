import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:super_liquid_galaxy_controller/components/galaxy_button.dart';
import 'package:super_liquid_galaxy_controller/components/glassbox.dart';
import 'package:super_liquid_galaxy_controller/components/kml_elements/linestring.dart';
import 'package:super_liquid_galaxy_controller/components/kml_elements/placemark.dart';
import 'package:super_liquid_galaxy_controller/components/kml_elements/polygon.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';

import '../data_class/KmlElement.dart';
import '../generated/assets.dart';

class KmlUploader extends StatefulWidget {
  const KmlUploader({super.key});

  @override
  State<KmlUploader> createState() => _KmlUploaderState();
}

class _KmlUploaderState extends State<KmlUploader> {
  late double screenHeight;
  late double screenWidth;
  late DataRetrieverHandler dataController;

  int elementIndex = 0;
  List<String> labels = ['Placemark', 'Polyline', 'Polygon'];
  List<List<dynamic>> kmlElements = [
    ['Placemark', Icons.place_outlined],
    ['Polyline', Icons.polyline],
    ['Polygon', Icons.pentagon_rounded]
  ];
  List<KmlElement> kmlList = [];

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
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageIcon(
                const AssetImage(Assets.iconsCode),
                color: Colors.white,
                size: screenHeight * 0.08,
              ),
              const SizedBox(width: 20),
              const Text(
                "DYNAMIC KML BUILDER",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GlassBox(
                        height: screenHeight * 0.25,
                        width: screenWidth * 0.64,
                        backgroundGradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.07),
                            Colors.white.withOpacity(0.07)
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Text(
                                "KML FILE:",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 25.0),
                              ),

                              Divider(thickness: 1.0,),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Visibility(
                                  visible: kmlList.isEmpty,
                                  child: const Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image(
                                              image: AssetImage(Assets.iconsKml),
                                            fit: BoxFit.scaleDown,
                                          ),
                                          const Text(
                                            "ADD ELEMENTS \n TO VIEW \n KML FILE",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                              Visibility(
                                visible: kmlList.isNotEmpty,
                                child: Expanded(
                                    child: Scrollbar(
                                      controller: ScrollController(),
                                      radius: const Radius.circular(20.0),
                                      thickness: 2.0,
                                      child: ListView.builder(
                                        itemCount: kmlList.length,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                                var element = kmlList[index];
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                      Icon(
                                                      kmlElements[element.index][1],
                                                      color: Colors.white,
                                                      size: 25.0,
                                                    ),
                                                    const SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    Text(
                                                      "${kmlElements[element.index][0]} : ${element.elementData?.label}",
                                                      style: const TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.w400),
                                                    )
                                                  ],
                                                );
                                              }),
                                    )),
                              )
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 20.0,
                    ),

                    //MAPS TO USE ?????
                    GlassBox(
                      height: screenHeight * 0.4,
                      width: screenWidth * 0.64,
                      backgroundGradient: const LinearGradient(
                        colors: [Colors.white, Colors.white],
                      ),
                      child: FlutterMap(
                        options: const MapOptions(
                          initialCenter: LatLng(51.509364, -0.128928),
                          initialZoom: 9.2,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          RichAttributionWidget(
                            attributions: [
                              TextSourceAttribution(
                                  'OpenStreetMap contributors',
                                  onTap: () {}),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GalaxyButton(
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.31,
                          actionText: "VISUALIZE IN LG",
                          icon: Icons.smart_screen,
                          isLeading: true,
                          onTap: () {},
                          backgroundColor: GalaxyColors.blue.withOpacity(0.4),
                        ),
                        GalaxyButton(
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.31,
                          actionText: "VISUALIZE IN MAP",
                          icon: Icons.map,
                          isLeading: true,
                          onTap: () {},
                          backgroundColor: GalaxyColors.blue.withOpacity(0.4),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GlassBox(
                height: double.infinity,
                width: screenWidth * 0.27,
                backgroundGradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.2)
                  ],
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 35.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DropdownMenu(
                          width: screenWidth * 0.2,
                          onSelected: (label) {
                            setState(() {
                              elementIndex = labels.indexOf(label!);
                            });
                          },
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 20.0),
                          leadingIcon: Icon(kmlElements[elementIndex][1]),
                          trailingIcon: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              VerticalDivider(
                                width: 2.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.white,
                              )
                            ],
                          ),
                          dropdownMenuEntries: kmlElements
                              .map((pair) => DropdownMenuEntry<String>(
                                  label: pair[0],
                                  value: pair[0],
                                  leadingIcon:
                                      Icon(pair[1], color: Colors.grey)))
                              .toList(),
                          inputDecorationTheme: InputDecorationTheme(
                              suffixIconColor: Colors.white,
                              filled: true,
                              alignLabelWithHint: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              fillColor: Colors.black.withOpacity(0.5),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                          initialSelection: 'Placemark',
                        ),
                        Expanded(child: kmlElementOptionsWidget(elementIndex)),
                        MaterialButton(
                          minWidth: screenWidth * 0.2,
                          height: screenHeight * 0.06,
                          color: GalaxyColors.green.withOpacity(0.4),
                          onPressed: () {
                            if (dataController.dataRetriever != null) {
                              addElementToList(dataController.dataRetriever!());
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.add_box_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                'ADD ELEMENT',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20.0),
                              )
                            ],
                          ),
                        )
                      ]),
                ),
              ),
            )
          ],
        ),
      )
    ]));
  }

  addElementToList(KmlElement elementData) {
    setState(() {
      kmlList.add(elementData);
    });
  }

  Widget kmlElementOptionsWidget(int elementIndex) {
    switch (elementIndex) {
      case 0:
        {
          return PlacemarkElement(
            width: screenWidth * 0.25,
            height: screenHeight * 0.9,
            handlerCallback: ((handler) {
              dataController = handler;
            }),
          );
        }
      case 1:
        {
          return LineStringElement(
            width: screenWidth * 0.25,
            height: screenHeight * 0.9,
            handlerCallback: ((handler) {
              dataController = handler;
            }),
          );
        }
      case 2:
        {
          return PolygonElement(
            width: screenWidth * 0.25,
            height: screenHeight * 0.9,
            handlerCallback: ((handler) {
              dataController = handler;
            }),
          );
        }
      default:
        {
          return PlacemarkElement(
            width: screenWidth * 0.25,
            height: screenHeight * 0.9,
            handlerCallback: ((handler) {
              dataController = handler;
            }),
          );
        }
    }
  }
}
