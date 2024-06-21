import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/tabs/apikey_tab.dart';
import 'package:super_liquid_galaxy_controller/tabs/connection_tab.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';
import 'package:super_liquid_galaxy_controller/tabs/sshcommands_tab.dart';

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

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Stack(
          children: [
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
                  filter: ImageFilter.blur(sigmaX: 0.75,sigmaY: 0.75),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05)
                    ),
                  ),
                ),
            DefaultTabController(
            length: 3,
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
                bottom: TabBar(
                  dividerColor: Colors.transparent,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Color(0xff5D87F4),
                  indicatorColor: Color(0xff5D87F4),
                  tabs: [
                    Tab(
                      height: screenHeight*0.1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(mainAxisSize: MainAxisSize.min, children: const [
                          ImageIcon(AssetImage(Assets.iconsConnection), size: 60.0),
                          SizedBox(width: 10.0,),
                          Text(
                            "Connection  ",
                            style: TextStyle(fontSize: 30.0),
                          ),
                        ]),
                      ),
                    ),
                    Tab(
                      height: screenHeight*0.1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(mainAxisSize: MainAxisSize.min, children: const [
                          ImageIcon(AssetImage(Assets.iconsSsh), size: 60.0),
                          SizedBox(width: 10.0,),
                          Text(
                            "SSH Commands  ",
                            style: TextStyle(fontSize: 30.0),
                          ),
                        ]),
                      ),
                    ),
                    Tab(
                      height: screenHeight*0.1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(mainAxisSize: MainAxisSize.min, children: const [
                          ImageIcon(AssetImage(Assets.iconsKey), size: 60.0),
                          SizedBox(width: 10.0,),
                          Text(
                              "API Keys  ",
                            style: TextStyle(fontSize: 30.0),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(children: const [
                      ConnectionTab(),
                      SSHCommandsTab(),
                      ApiKeyTab()
                    ],
                    ),
                ),
            ),
          ]
        )
    );
  }
}
