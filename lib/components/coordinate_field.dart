import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/galaxy_colors.dart';

class CoordinateField extends StatefulWidget {
  CoordinateField({super.key, required this.width,required this.headerText,required this.inputType});

  double width;
  String headerText;
  TextInputType inputType;

  @override
  State<CoordinateField> createState() => _CoordinateFieldState();
}

class _CoordinateFieldState extends State<CoordinateField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: GalaxyColors.darkBlue.withOpacity(0.4),
        child: Padding(

            padding: const EdgeInsets.all(5.0),
            child: Row(children: [
              Text(
                " ${widget.headerText} ",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 20.0,
                ),
              ),
              const VerticalDivider(
                color: Colors.white,
                width: 2.0,
              ),
              Container(
                width: widget.width,
                color: Colors.transparent,
                child: TextField(
                  keyboardType: widget.inputType,
                  style: const TextStyle(color: Colors.white,fontSize: 20.0),
                  decoration: const InputDecoration(
                    fillColor: Colors.transparent,
                    focusColor: Colors.grey,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    alignLabelWithHint: true,
                  ),
                ),
              )
            ]
            )
        )
    );
  }
}
