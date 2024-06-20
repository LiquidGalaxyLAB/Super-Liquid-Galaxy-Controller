import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';

import '../coordinate_field.dart';

class LineStringElement extends StatefulWidget {
  LineStringElement({super.key, required this.width, required this.height});

  double height;
  double width;

  @override
  State<LineStringElement> createState() => _LineStringElementState();
}

class _LineStringElementState extends State<LineStringElement> {
  List<Coordinates> pointList = [];
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // height = widget.key.;
    // width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 35.0),
      child: SingleChildScrollView(
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
                inputType: TextInputType.text),
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
                inputType: TextInputType.text),
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

                            print(pointList.length);
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
                            message:
                                "One or more CoordinateFields are empty",
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
            const Text(
              "POINTS RECORDED:",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 20.0),
            ),
            Container(
              height: pointList.length*widget.width*0.1,

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
                          "(${pointList[index].latitude},${pointList[index].longitude})",
                          style: const TextStyle(color: Colors.white,fontSize: 17.0),
                        )
                      ],
                    );
                  }),
            ),

          ],
        ),
      ),
    );
  }
}
