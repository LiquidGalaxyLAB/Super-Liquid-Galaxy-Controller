import 'dart:ui';

import 'package:flutter/material.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class PlanetSelector extends StatefulWidget {
  const PlanetSelector({super.key});

  @override
  State<PlanetSelector> createState() => _PlanetSelectorState();
}

class _PlanetSelectorState extends State<PlanetSelector> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 50.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2.0),
            child: Container(
              child: Stack(children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white.withOpacity(0.1)),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0)),
                      gradient: LinearGradient(colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.05)
                      ])),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0),
                    child: Text(
                      "EARTH",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 110,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          Container(
            height: 150.0,
            width: 2.0,
            color: Colors.white,
          ),
          Icon(Icons.arrow_drop_up_rounded,
              size: 100, color: Colors.white),
          SizedBox(width: 100)
        ],
      ),
    );
  }
}
