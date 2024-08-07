import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_liquid_galaxy_controller/components/glassbox.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';
import 'package:super_liquid_galaxy_controller/tabs/about.dart';
import 'package:super_liquid_galaxy_controller/tabs/apikey_tab.dart';
import 'package:super_liquid_galaxy_controller/tabs/connection_tab.dart';
import 'package:super_liquid_galaxy_controller/tabs/sshcommands_tab.dart';
import 'package:super_liquid_galaxy_controller/controllers/api_manager.dart';
import 'package:super_liquid_galaxy_controller/controllers/lg_connection.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late double screenHeight;
  late double screenWidth;
  late LGConnection connectionClient;
  late ApiManager apiClient;

  @override
  void initState() {
    connectionClient = Get.find();
    apiClient = Get.find();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Stack(children: [
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Assets.assetsBackgroundspace),
              fit: BoxFit.cover),
        ),
      ),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.75, sigmaY: 0.75),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      DefaultTabController(
        length: 4,
        initialIndex: 0,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: screenHeight * 0.11,
            leading: BackButton(
              color: Colors.white,
            ),
            backgroundColor: Colors.transparent,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "SETTINGS",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              Obx((){
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GlassBox(
                      height: screenHeight * 0.1,
                      width: screenHeight * 0.1,
                      backgroundGradient: LinearGradient(colors: [
                        Colors.grey.withOpacity(0.2),
                        Colors.grey.withOpacity(0.2)
                      ]),
                      child: ImageIcon(
                        AssetImage(Assets.iconsSshIndicator),
                        color: connectionClient.isConnected.value ? Colors.green : Colors.red,
                        size: screenHeight *0.06,
                      )),
                );}
              ),

              Obx((){
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GlassBox(
                      height: screenHeight * 0.1,
                      width: screenHeight * 0.1,
                      backgroundGradient: LinearGradient(colors: [
                        Colors.grey.withOpacity(0.2),
                        Colors.grey.withOpacity(0.2)
                      ]),
                      child: ImageIcon(
                        AssetImage(Assets.iconsApiIndicator),
                        color: apiClient.isConnected.value ? Colors.green : Colors.red,
                        size: screenHeight *0.07,
                      )),
                );}
              ),
            ],
            bottom: TabBar(
              dividerColor: Colors.transparent,
              unselectedLabelColor: Colors.grey,
              labelColor: Color(0xff5D87F4),
              indicatorColor: Color(0xff5D87F4),
              tabs: [
                Tab(
                  height: screenHeight * 0.1,
                  child: Container(
                    //color: Colors.green.withOpacity(0.3),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(mainAxisSize: MainAxisSize.min, children: const [
                          ImageIcon(AssetImage(Assets.iconsConnection), size: 60.0),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "  Connection",
                            style: TextStyle(fontSize: 30.0),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                Tab(
                  height: screenHeight * 0.1,
                  child: Container(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(mainAxisSize: MainAxisSize.min, children: const [
                          ImageIcon(AssetImage(Assets.iconsSsh), size: 60.0),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "  SSH Commands",
                            style: TextStyle(fontSize: 30.0),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                Tab(
                  height: screenHeight * 0.1,
                  child: Container(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(mainAxisSize: MainAxisSize.min, children: const [
                          ImageIcon(AssetImage(Assets.iconsKey), size: 60.0),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "  API Keys",
                            style: TextStyle(fontSize: 30.0),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                Tab(
                  height: screenHeight * 0.1,
                  child: Container(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(mainAxisSize: MainAxisSize.min, children: const [
                          ImageIcon(AssetImage(Assets.iconsInformation), size: 45.0),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "  About  ",
                            style: TextStyle(fontSize: 30.0),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: const [ConnectionTab(), SSHCommandsTab(), ApiKeyTab(),AboutTab()],
          ),
        ),
      ),
    ]));
  }
}
