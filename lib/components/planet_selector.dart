import 'dart:ui';
import 'package:flutter/material.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class PlanetSelector extends StatefulWidget {
  PlanetSelector({super.key,required this.height,required this.width, required this.onPressed});

  double width;
  double height;
  VoidCallback onPressed;
  @override
  State<PlanetSelector> createState() => _PlanetSelectorState();
}

class _PlanetSelectorState extends State<PlanetSelector> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          widget.onPressed();
        },
        child: Container(
          width: widget.width,
          height: widget.height,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(2.0),
                child: Stack(children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Container(),
                  ),
                  Container(
                    height: double.infinity,
                    width: widget.width*0.8,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white.withOpacity(0.1)),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0)),
                        gradient: LinearGradient(colors: [
                          Colors.white.withOpacity(0.25),
                          Colors.white.withOpacity(0.05)
                        ])
                    ),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0),
                        child: Text(
                          "EARTH",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              Container(
                height: 150.0,
                width: 2.0,
                color: Colors.white,
              ),
              Expanded(
                child: Container(
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Icon(Icons.arrow_drop_up_rounded,
                        size: widget.height*0.8, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
