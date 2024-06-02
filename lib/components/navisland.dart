import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/components/nav_element.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class NavIsland extends StatelessWidget {
  NavIsland({super.key,required this.height,required this.width,this.child});

  double height;
  double width;
  Widget? child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: width,
          height: height,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.1)
                    ]
                    )
                ),
              ),
      
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 17.0,horizontal: 15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: height/7,
                        width: width,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage(Assets.assetsBackgroundspace),fit: BoxFit.none),
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: Center(
                            child: Text(
                              "Galaxy Hub",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      NavElement(path: Assets.iconsLandmark, text: "POI Exploration", hasDivider: true, onTap: (){
                        print('Pressed');
                      },),
                      SizedBox(height: 20.0),
                      NavElement(path: Assets.iconsTravel, text: "Tour Management", hasDivider: true),
                      SizedBox(height: 20.0),
                      NavElement(path: Assets.iconsArcade, text: "Touch-less controllers", hasDivider: true),
                      SizedBox(height: 20.0),
                      NavElement(path: Assets.iconsController, text: "Geo-Quest", hasDivider: true),
                      SizedBox(height: 20.0),
                      NavElement(path: Assets.iconsCode, text: "KML Uploader", hasDivider: false),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
