import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_liquid_galaxy_controller/components/kml_elements/placemark.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';

import '../../data_class/kml_element.dart';
import '../coordinate_field.dart';

class LineStringElement extends StatefulWidget {
  LineStringElement(
      {super.key,
      required this.width,
      required this.height,
      required this.handlerCallback(DataRetrieverHandler handler)});

  double height;
  double width;
  final Function handlerCallback;

  @override
  State<LineStringElement> createState() => _LineStringElementState();
}

class _LineStringElementState extends State<LineStringElement> {
  List<Coordinates> pointList = [];
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DataRetrieverHandler handler = DataRetrieverHandler();
    handler.dataRetriever = this.retrieveData;
    handler.dataSetter = this.setData;
    widget.handlerCallback(handler);
  }

  @override
  Widget build(BuildContext context) {
    // height = widget.key.;
    // width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 35.0),
      child: Scrollbar(
        controller: ScrollController(),
        radius: const Radius.circular(20.0),
        thickness: 2.0,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "LABEL:",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 25.0),
                  ),
                  const SizedBox(height: 20.0),
                  CoordinateField(
                    width: widget.width * 0.5,
                    headerText: "Name:",
                    inputType: TextInputType.text,
                    controller: nameController,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "DESCRIPTION:",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 25.0),
                  ),
                  const SizedBox(height: 20.0),
                  CoordinateField(
                    width: widget.width * 0.5,
                    headerText: "Body:",
                    inputType: TextInputType.text,
                    controller: bodyController,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "COORDINATES:",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 25.0),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          CoordinateField(
                              controller: latController,
                              width: widget.width * 0.5,
                              inputType: TextInputType.number,
                              headerText: "X:"),
                          const SizedBox(height: 10.0),
                          CoordinateField(
                              controller: longController,
                              width: widget.width * 0.5,
                              inputType: TextInputType.number,
                              headerText: "Y:"),
                        ],
                      ),
                      const SizedBox(
                        width: 7.0,
                      ),
                      FloatingActionButton(
                          onPressed: () {
                            if (latController.text.isNotEmpty &&
                                longController.text.isNotEmpty) {
                              try {
                                setState(() {
                                  pointList.add(Coordinates(
                                      latitude: double.parse(
                                          latController.text.toString()),
                                      longitude: double.parse(
                                          longController.text.toString())));

                                });
                                latController.clear();
                                longController.clear();
                              } catch (e) {
                                print(e.toString());
                              }
                            } else {
                              if (!Get.isSnackbarOpen) {
                                Get.showSnackbar(GetSnackBar(
                                  backgroundColor: Colors.red.shade300,
                                  title: "EMPTY FIELDS",
                                  message: "One or more CoordinateFields are empty",
                                  isDismissible: true,
                                  duration: 5.seconds,
                                ));
                              }
                            }
                          },
                          backgroundColor: GalaxyColors.darkBlue.withOpacity(0.4),
                          child: const Icon(Icons.add))
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Visibility(
                    visible: pointList.isNotEmpty,
                    child: const Text(
                      "POINTS RECORDED:",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 20.0),
                    ),
                  ),
                  Container(
                    height: pointList.length * widget.width * 0.1,
                    width: widget.width*0.5,
                    child: ListView.builder(
                        itemCount: pointList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.circle,
                                color: Colors.white,
                                size: 15.0,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "(${pointList[index].latitude.toStringAsFixed(2)},${pointList[index].longitude.toStringAsFixed(2)})",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 17.0),
                              )
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  KmlElement? retrieveData() {
    try {
      if (!validateData()) {
        return null;
      }
      return KmlElement(
          index: 1,
          elementData: LineString(
              coordinates: pointList,
              label: nameController.text.toString(),
              description: bodyController.text.toString()));
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  void setData(KmlElement element) {
    if (element.index != 1) {
      return;
    }
    LineString ele = element.elementData;
    nameController.text=ele.label;
    bodyController.text=ele.description;
    pointList.clear();
    pointList.addAll(ele.coordinates);
  }

  bool validateData() {
    if (nameController.text.isEmpty ||
        bodyController.text.isEmpty) {
      if (!Get.isSnackbarOpen) {
        Get.showSnackbar(GetSnackBar(
          backgroundColor: Colors.red.shade300,
          title: "EMPTY FIELDS",
          message: "One or more Fields are empty",
          isDismissible: true,
          duration: 5.seconds,
        ));
      }
      return false;
    } else if (pointList.length < 2) {
      if (!Get.isSnackbarOpen) {
        Get.showSnackbar(GetSnackBar(
          backgroundColor: Colors.red.shade300,
          title: "INVALID FIELDS",
          message: "Less than two coordinates cannot create a linestring",
          isDismissible: true,
          duration: 5.seconds,
        ));

      }
      return false;
    } else {
      return true;
    }

  }
}
