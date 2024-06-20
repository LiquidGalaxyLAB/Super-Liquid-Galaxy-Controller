import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';
import '../coordinate_field.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';

class PlacemarkElement extends StatefulWidget {
  PlacemarkElement({super.key, required this.width,required this.height});

  double height;
  double width;
  @override
  State<PlacemarkElement> createState() => _PlacemarkElementState();
}

class _PlacemarkElementState extends State<PlacemarkElement> {

  @override
  Widget build(BuildContext context) {
    // height = widget.key.;
    // width = MediaQuery.of(context).size.width;


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 35.0),
      child: SingleChildScrollView(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("COORDINATES:",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 25.0),),
              const SizedBox(height: 20.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      CoordinateField(width: widget.width*0.5, inputType: TextInputType.number, headerText: "X:"),
                      const SizedBox(height: 10.0),
                      CoordinateField(width: widget.width*0.5,inputType: TextInputType.number, headerText: "Y:"),
                    ],
                  ),
                  const SizedBox(width: 5.0,),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text("LABEL:",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 25.0),),
              const SizedBox(height: 20.0),
              CoordinateField(width: widget.width*0.5, headerText: "Name:", inputType: TextInputType.text),
              const SizedBox(height: 20.0),
              const Text("DESCRIPTION:",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 25.0),),
              const SizedBox(height: 20.0),
              CoordinateField(width: widget.width*0.5, headerText: "Body:", inputType: TextInputType.text)
            ],
            ),
          ],
        ),
      ),
    );
  }
}
