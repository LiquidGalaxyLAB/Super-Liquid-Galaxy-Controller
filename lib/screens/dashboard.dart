import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_liquid_galaxy_controller/components/custom_dialog.dart';
import 'package:super_liquid_galaxy_controller/components/navisland.dart';
import 'package:super_liquid_galaxy_controller/components/planet_selector.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';
import 'package:super_liquid_galaxy_controller/screens/settings.dart';
import 'package:super_liquid_galaxy_controller/controllers/api_manager.dart';
import 'package:super_liquid_galaxy_controller/controllers/lg_connection.dart';
import 'package:lottie/lottie.dart';

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
  late LGConnection connectionClient;
  late ApiManager apiClient;

  @override
  void initState() {
    super.initState();
    log("ui", "dashboard-built");
    initializeLGClient();
    initializeApiClient();

  }

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

    return SafeArea(
        child: Scaffold(
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Assets.assetsBackgroundspace),
                    fit: BoxFit.cover),
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset("assets/earth.gif",
                          height: screenHeight,
                          width: screenWidth,
                          fit: BoxFit.cover),
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
                            EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 20.0),
                            child: Row(
                              children: [
                                Image(
                                  image: AssetImage(Assets.assetsLogo),
                                  height: screenHeight * 0.1,
                                ),
                                SizedBox(width: 20),
                                Container(
                                  width: screenWidth * 0.4,
                                  height: screenHeight * 0.1,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text("SUPER LIQUID GALAXY CONTROLLER",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30.0),),

                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 20.0),
                            child: GlassBox(
                              height: screenHeight * 0.1,
                              width: screenHeight * 0.1,
                              child: Icon(
                                Icons.settings,
                                size: screenHeight*0.07,
                                color: Colors.white,
                              ),
                              onTap: () async {
                                log("gesture", "settings tapped");
                                await Get.to(() => Settings());
                              },
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 20),
                          GlassBox(
                              height: 50,
                              width: 200,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(() {
                                    return ConnectionFlag(
                                      status: connectionClient.isConnected.value,
                                      backgroundColor: Colors.white.withOpacity(
                                          0.0),
                                      selectedText: 'LG CONNECTED',
                                      unSelectedText: 'LG NOT CONNECTED',
                                      fontSize: 15.0,
                                    );
                                  }
                                  ),
                                ],
                              )),
                          SizedBox(width: 20),
                          GlassBox(
                              height: 50,
                              width: 210,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(() {
                                    return ConnectionFlag(
                                      status: apiClient.isConnected.value,
                                      backgroundColor: Colors.white.withOpacity(
                                          0.0),
                                      selectedText: 'API CONNECTED',
                                      unSelectedText: 'API NOT CONNECTED',
                                      fontSize: 15.0,
                                    );
                                  }
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenHeight*0.15, vertical: screenHeight*0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [PlanetSelector(height: screenHeight*0.2,width: screenWidth*0.4,)],
                        ),
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

                            height: screenHeight * 0.6,
                            width: screenWidth * 0.3
                          ),
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

  void initializeLGClient() async {
    connectionClient = Get.find();
    await connectionClient.connectToLG();
  }
  void initializeApiClient() async {
    apiClient = Get.find();
    await apiClient.testApiKey();
  }

  void _reload() {
    setState(() {});
  }


  //test

  /*Future<void> testDialog() async {
    var customDialog = CustomDialog(
      content: Text("SSH operations are now possible."),
      title: Text("Connection established",style: TextStyle(color: Colors.green.shade500,fontSize: 25.0,fontWeight: FontWeight.bold),),
      firstColor: Colors.green,
      secondColor: Colors.white,
      headerIcon: Lottie.asset(Assets.lottieConnected,
          decoder: customDecoder, repeat: false,width: 200.0,height: 200.0));

    var customDialog1 = CustomDialog(
        content: Text("SSH operations unavailable."),
        title: Text("Connection failed",style: TextStyle(color: Colors.red.shade500,fontSize: 25.0,fontWeight: FontWeight.bold),),
        firstColor: Colors.red.shade400,
        secondColor: Colors.white,
        headerIcon: Lottie.asset(Assets.lottieConnectionfailed,
            decoder: customDecoder, repeat: false,width: 200.0,height: 200.0));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return customDialog1;
      },
    );
  }*/

  Future<LottieComposition?> customDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(bytes, filePicker: (files) {
      return files.firstWhere(
            (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    });
  }



}
