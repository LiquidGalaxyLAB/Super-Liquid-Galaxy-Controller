import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/data_class/kml_element.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:get/get.dart';
import '../coordinate_field.dart';

class PlacemarkElement extends StatefulWidget {
  PlacemarkElement(
      {super.key,
      required this.width,
      required this.height,
      required this.handlerCallback(DataRetrieverHandler handler)});

  double height;
  double width;
  final Function handlerCallback;

  @override
  State<PlacemarkElement> createState() => _PlacemarkElementState();
}

class DataRetrieverHandler {
  Function? dataRetriever;
}

class _PlacemarkElementState extends State<PlacemarkElement> {
  TextEditingController coordinateLatController = TextEditingController();
  TextEditingController coordinateLongController = TextEditingController();
  TextEditingController labelController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DataRetrieverHandler handler = DataRetrieverHandler();
    handler.dataRetriever = this.retrieveData;
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        width: widget.width * 0.5,
                        inputType: TextInputType.number,
                        headerText: "X:",
                        controller: coordinateLatController,
                      ),
                      const SizedBox(height: 10.0),
                      CoordinateField(
                        width: widget.width * 0.5,
                        inputType: TextInputType.number,
                        headerText: "Y:",
                        controller: coordinateLongController,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
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
                controller: labelController,
              ),
              const SizedBox(height: 20.0),
              const Text("DESCRIPTION:",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 25.0)),
              const SizedBox(height: 20.0),
              CoordinateField(
                width: widget.width * 0.5,
                headerText: "Body:",
                inputType: TextInputType.text,
                controller: descController,
              )
            ],
          ),
        ),
      ),
    );
  }

  KmlElement? retrieveData() {
    try {
      if(!validateData()) {
        return null;
      }

      print("place-mark sent");
      return KmlElement(
          index: 0,
          elementData: Placemark(
              coordinate: Coordinates(
                  latitude:
                      double.parse(coordinateLatController.text.toString()),
                  longitude:
                      double.parse(coordinateLongController.text.toString())),
              label: labelController.text.toString(),
              description: descController.text.toString()));
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  bool validateData() {
    if(coordinateLongController.text.isEmpty||coordinateLatController.text.isEmpty||labelController.text.isEmpty||descController.text.isEmpty)
      {
        if (!Get.isSnackbarOpen) {
          Get.showSnackbar(GetSnackBar(
            backgroundColor: Colors.red.shade300,
            title: "EMPTY FIELDS",
            message:
            "One or more Fields are empty",
            isDismissible: true,
            duration: 5.seconds,
          ));
        }
        return false;
      }
    else {
      return true;
    }
  }
}
