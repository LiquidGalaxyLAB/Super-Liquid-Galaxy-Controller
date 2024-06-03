import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';

import '../utils/lg_connection.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
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
                bottom: const TabBar(
                  dividerColor: Colors.transparent,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Color(0xff5D87F4),
                  indicatorColor: Color(0xff5D87F4),
                  tabs: [
                    // Tab(text: "Connection",icon: ImageIcon(AssetImage(Assets.iconsConnection),size: 60.0)),
                    // Tab(text: "SSH Commands",icon: ImageIcon(AssetImage(Assets.iconsSsh),size: 60.0)),
                    // Tab(text: "API Keys",icon: ImageIcon(AssetImage(Assets.iconsKey),size: 60.0)),
                    Tab(child: Row(mainAxisSize: MainAxisSize.min,children: [ImageIcon(AssetImage(Assets.iconsConnection),size: 60.0),Text("Connection",style: TextStyle(fontSize: 30.0),),]),),
                    Tab(child: Row(mainAxisSize: MainAxisSize.min,children: [ImageIcon(AssetImage(Assets.iconsSsh),size: 60.0),Text("SSH Commands",style: TextStyle(fontSize: 30.0),),]),),
                    Tab(child: Row(mainAxisSize: MainAxisSize.min,children: [ImageIcon(AssetImage(Assets.iconsKey),size: 60.0),Text("API Keys",style: TextStyle(fontSize: 30.0),),]),)
                  ],
                ),
              ),
              body: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      // gradient: LinearGradient(colors: [
                      //   Colors.white.withOpacity(0.25),
                      //   Colors.white.withOpacity(0.05)
                      // ]),
                    image: DecorationImage(
                        image: AssetImage(Assets.assetsBackgroundspace),
                        fit: BoxFit.cover),
                  ),
                  child:TabBarView(children: [

                  ],

                  )),
            ),
          ),
        ));
  }
}
