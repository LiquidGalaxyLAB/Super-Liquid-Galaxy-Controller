import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/screens/kml_builder.dart';
import 'package:super_liquid_galaxy_controller/screens/maps_controller.dart';
import 'package:get/get.dart';
import '../generated/assets.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class NavIsland extends StatelessWidget {
  NavIsland({super.key, required this.height, required this.width, this.child});

  double height;
  double width;
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
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
                    ])),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: height * 0.12,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black.withOpacity(0.4)),
                      child: Center(
                          child: Text(
                        "GALAXY HUB",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 30.0),
                      )),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){},
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          width: double.infinity,
                          height: height * 0.37,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black.withOpacity(0.4)),
                          child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                            children: [
                              ImageIcon(AssetImage(Assets.iconsLandmark),size: height*0.15,color: Colors.white),
                              Text(
                                "POI EXPLORATION",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 20.0),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: (){print("blah");},
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              width: width*0.34,
                              height: height * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.black.withOpacity(0.4)),
                              child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ImageIcon(AssetImage(Assets.iconsTravel),size: height*0.12,color: Colors.white),
                                      Text(
                                        "TOUR ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12.0,),
                                      ),
                                      Text(
                                        "MANAGEMENT",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 15.0,),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0,),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: (){print("blah");},
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    height: height * 0.12,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black.withOpacity(0.4)),
                                    child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 10.0),
                                            ImageIcon(AssetImage(Assets.iconsController),size: height*0.1,color: Colors.white),
                                            SizedBox(width: 10.0),
                                            Text(
                                              "GEO-QUEST",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 15.0),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: (){
                                    Get.to(() => MapController());
                                  },
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    height: height * 0.12,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black.withOpacity(0.4)),
                                    child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 10.0),
                                            ImageIcon(AssetImage(Assets.iconsArcade),size: height*0.1,color: Colors.white),
                                            SizedBox(width: 10.0),
                                            Text(
                                              "LG CONTROLLERS",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 15.0),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: (){Get.to(()=>KmlUploader());},
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    height: height * 0.12,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black.withOpacity(0.4)),
                                    child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 10.0),
                                            ImageIcon(AssetImage(Assets.iconsCode),size: height*0.1,color: Colors.white),
                                            SizedBox(width: 10.0),
                                            Text(
                                              "KML MAKER",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 15.0),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
