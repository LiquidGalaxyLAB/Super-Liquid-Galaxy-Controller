import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_liquid_galaxy_controller/components/MapKmlElement.dart';
import 'package:super_liquid_galaxy_controller/components/galaxy_button.dart';
import 'package:super_liquid_galaxy_controller/components/glassbox.dart';
import 'package:super_liquid_galaxy_controller/components/kml_elements/linestring.dart';
import 'package:super_liquid_galaxy_controller/components/kml_elements/placemark.dart';
import 'package:super_liquid_galaxy_controller/components/kml_elements/polygon.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/screens/test.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';
import 'package:super_liquid_galaxy_controller/utils/geo_utils.dart';
import 'package:super_liquid_galaxy_controller/utils/kmlgenerator.dart';
import 'package:super_liquid_galaxy_controller/utils/lg_connection.dart';

import '../data_class/kml_element.dart';
import '../data_class/map_position.dart';
import '../generated/assets.dart';
import '../utils/map_movement_controller.dart';

class KmlUploader extends StatefulWidget {
  const KmlUploader({super.key});

  @override
  State<KmlUploader> createState() => _KmlUploaderState();
}

class _KmlUploaderState extends State<KmlUploader> {
  MapPosition position = MapPosition(
    latitude: 40.7128,
    longitude: -74.0060,
    // Example: New York City
    zoom: 5,
    bearing: 45,
    // 45 degrees east of north
    tilt: 45, // City level zoom
  );

  late MapMovementController mapMovementController;

  late double screenHeight;
  late double screenWidth;
  late DataRetrieverHandler dataController;
  late CallbackHandler callbackController;
  late LGConnection sshClient;

  int elementIndex = 0;
  List<String> labels = ['Placemark', 'Polyline', 'Polygon'];
  List<List<dynamic>> kmlElements = [
    ['Placemark', Icons.place_outlined],
    ['Polyline', Icons.polyline],
    ['Polygon', Icons.pentagon_rounded]
  ];
  List<KmlElement> kmlList = [];
  KmlElement? loadElement;

  @override
  void initState() {
    sshClient = Get.find();
    mapMovementController = Get.find();
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
                              const Divider(
                                thickness: 1.0,
                              ),
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
                                  )),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w400),
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
                      child: Mapkmlelement(
                        position: position,
                        mapMovementController: mapMovementController,
                        elementIndex: elementIndex,
                        handlerCallback: ((handler) {
                          callbackController = handler;
                        }),
                        submitData: (KmlElement data) {
                          setState(() {
                            loadElement = data;
                            dataController.dataSetter!(data);
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GalaxyButton(
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.315,
                          actionText: "VISUALIZE IN LG",
                          icon: Icons.smart_screen,
                          isLeading: true,
                          onTap: () async {
                            print("tapped");
                            String filename = generateRandomString(7);
                            await sshClient.connectToLG();
                            //await sshClient.clearKml();
                            File? file = await sshClient.makeFile(
                                filename,
                                KMLGenerator.generateCustomKml(
                                    'slave_1', kmlList));

                            MapPosition position =
                                MapPosition.fromCameraPosition(
                                    GeoUtils.getBoundsZoomLevel(
                                        getCoordsList(kmlList),
                                        MediaQuery.of(context).size));
                            //Get.to(()=>TestScreen(kml: KMLGenerator.generateCustomKml('slave_1', kmlList)));
                            //String kml = KMLGenerator.generateCustomKml('slave_1', kmlList);

                            print("made successfully");
                            await sshClient.kmlFileUpload(file!, filename);
                            print("uploaded successfully");
                            await sshClient.runKml(filename);
                            print("ran kml successfully");
                            await sshClient.moveTo(position);
                            print("Moved");

                          },
                          backgroundColor: GalaxyColors.blue.withOpacity(0.4),
                        ),
                        GalaxyButton(
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.315,
                          actionText: "DOWNLOAD KML",
                          icon: Icons.save_alt_rounded,
                          isLeading: true,
                          onTap: () async {
                            //await sshClient.clearKml();
                            String kml = KMLGenerator.generateCustomKml(
                                'slave_1', kmlList);
                            saveStringToExternalStorageWithProgress(
                                kml,
                                'custom_kml_ID_${generateRandomString(7)}',
                                'kml', (progress) {
                              print(progress);
                            });
                          },
                          backgroundColor: GalaxyColors.blue.withOpacity(0.4),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 20.0, 30.0, 20.0),
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.2)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 35.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: screenHeight * 0.1,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: DropdownMenu(
                                onSelected: (label) {
                                  setState(() {
                                    elementIndex = labels.indexOf(label!);
                                    callbackController.callBack!(elementIndex);
                                  });
                                },
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
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
                                        borderRadius:
                                            BorderRadius.circular(20.0))),
                                initialSelection: 'Placemark',
                              ),
                            ),
                          ),
                          Expanded(
                              child: kmlElementOptionsWidget(elementIndex)),
                          MaterialButton(
                            minWidth: screenWidth * 0.2,
                            height: screenHeight * 0.06,
                            color: GalaxyColors.green.withOpacity(0.4),
                            onPressed: () {
                              if (dataController.dataRetriever != null) {
                                addElementToList(
                                    dataController.dataRetriever!());
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Container(
                              child: const FittedBox(
                                fit: BoxFit.contain,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                              ),
                            ),
                          )
                        ]),
                  ),
                ),
              ),
            )
          ],
        ),
      )
    ]));
  }

  String generateRandomString(int len) {
    var r = Random.secure();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz_';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  addElementToList(KmlElement elementData) {
    setState(() {
      kmlList.add(elementData);
      print("added: $elementData");
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

  Future<void> saveStringToExternalStorageWithProgress(String content,
      String filename, String extension, Function(double) onProgress) async {
    // Request storage permissions
    String response = await getAndroidVersion();
    bool isAbove13 = false;
    if (response.compareTo('') == 0) {
      print('Failed to fetch android version');
    } else {
      if (int.tryParse(response)! >= 13) {
        isAbove13 = true;
      }
    }
    if (isAbove13 || await Permission.storage.request().isGranted) {
      // Get the external storage directory
      Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        // Create the file path with the custom extension
        String path = '${directory.path}/$filename.$extension';
        // Write the string content to the file in chunks
        File file = File(path);
        RandomAccessFile raf = await file.open(mode: FileMode.write);
        int totalLength = content.length;
        int chunkSize = 1024; // Write in chunks of 1KB
        int writtenLength = 0;

        for (int i = 0; i < totalLength; i += chunkSize) {
          int end = (i + chunkSize < totalLength) ? i + chunkSize : totalLength;
          await raf.writeString(content.substring(i, end));
          writtenLength += (end - i);
          // Calculate and report progress
          double progress = writtenLength / totalLength;
          onProgress(progress);
        }

        await raf.close();
        print('File saved at $path');
        showSuccessSnackbar("File saved at $path");
      } else {
        print('External storage directory not found');
      }
    } else {
      print('Storage permission denied');
    }
  }

  Future<String> getAndroidVersion() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.release;
    } else {
      return "unsupported";
    }
  }

  static List<LatLng> getCoordsList(List<KmlElement> list) {
    List<LatLng> coordsList = [];
    for (final item in list) {
      switch (item.index) {
        case 0:
          {
            Placemark element = item.elementData;
            coordsList.add(element.coordinate.toLatLngMap(element.coordinate));
          }
        case 1:
          {
            LineString element = item.elementData;
            coordsList.addAll(element.coordinates.map((Coordinates point) {
              return point.toLatLngMap(point);
            }));
          }
        case 2:
          {
            PolyGon element = item.elementData;
            element.coordinates.add(element.coordinates[0]);
            coordsList.addAll(element.coordinates.map((Coordinates point) {
              return point.toLatLngMap(point);
            }));
          }
        default:
          {
            Placemark element = item.elementData;
            coordsList.add(element.coordinate.toLatLngMap(element.coordinate));
          }
      }
    }
    return coordsList;
  }

  void showSuccessSnackbar(String message) {
    if (!Get.isSnackbarOpen) {
      Get.showSnackbar(GetSnackBar(
        backgroundColor: Colors.green.shade300,
        title: "Download Successful",
        message: message,
        isDismissible: true,
        duration: 5.seconds,
      ));
    }
  }
}
