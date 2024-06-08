import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/components/galaxytextfield.dart';
import 'package:super_liquid_galaxy_controller/components/glassbox.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class ApiKeyTab extends StatefulWidget {
  const ApiKeyTab({super.key});

  @override
  State<ApiKeyTab> createState() => _ApiKeyTabState();
}

class _ApiKeyTabState extends State<ApiKeyTab> {
  late double screenHeight;
  late double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.05, horizontal: screenHeight * 0.25),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.max, children: [

            Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        height: screenHeight * 0.07,
                        width: screenWidth * 0.4,
                        child: Stack(
                            children: [
                              BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                child: Container(),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.1)),
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: LinearGradient(colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.1)
                                    ]
                                    )
                                ),
                              ),

                              Center(
                                  child: Padding(padding: EdgeInsets.all(8.0),))
                            ])))),


            GlassBox(
              height: screenHeight * 0.07,
              width: screenWidth * 0.4,
              child: Text(
                "Geo-Apify Places API",
                style: TextStyle(color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.w200),
              ),
            ),
            GalaxyTextField(
                hintText: "eg, ZaCELgL.0imfnc8mVLWwsAawjYr4Rx",
                labelText: "PLACES API-KEY",
                iconData: Icons.code,
                textInputType: TextInputType.text,
                isPassword: true)
          ]),
        ),
      ),
    );
  }
}
