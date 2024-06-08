import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_liquid_galaxy_controller/components/navisland.dart';
import 'package:super_liquid_galaxy_controller/components/planet_selector.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';
import 'package:super_liquid_galaxy_controller/screens/settings.dart';

import '../components/connection_flag.dart';
import '../components/glassbox.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late double screenHeight;
  late double screenWidth;

  @override
  void initState() {
    super.initState();
    log("ui", "dashboard-built");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
            body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Assets.assetsBackgroundspace), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset("assets/earth.gif",
                  height: screenHeight, width: screenWidth, fit: BoxFit.cover),
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage(Assets.assetsLogo),
                          height: screenHeight * 0.1,
                        ),
                        SizedBox(width: 20),
                        Image(
                          image: AssetImage(Assets.assetsLogotxt),
                          height: screenHeight * 0.05,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                    child: GlassBox(
                      height: screenHeight * 0.1,
                      width: screenHeight * 0.1,
                      child: Icon(
                        Icons.settings,
                        size: 60,
                        color: Colors.white,
                      ),
                      onTap: () {
                        log("gesture", "settings tapped");
                        Get.to(() => Settings());
                      },
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassBox(
                      height: 50,
                      width: 200,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConnectionFlag(
                            status: false,
                            backgroundColor: Colors.white.withOpacity(0.0),
                            selectedText: 'LG CONNECTED',
                            unSelectedText: 'LG NOT CONNECTED',
                            fontSize: 15.0,
                          ),
                        ],
                      )),
                  SizedBox(width: 20),
                  GlassBox(
                      height: 50,
                      width: 270,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConnectionFlag(
                            status: false,
                            backgroundColor: Colors.white.withOpacity(0.0),
                            selectedText: 'AI SERVER CONNECTED',
                            unSelectedText: 'AI SERVER NOT CONNECTED',
                            fontSize: 15.0,
                          ),
                        ],
                      )),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [PlanetSelector()],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: NavIsland(
                    height: screenHeight * 0.60, width: screenWidth * 0.25),
              )
            ],
          )
        ],
      ),
    )));
  }

  void log(String name, String message) {
    developer.log(message, name: name);
  }
}
