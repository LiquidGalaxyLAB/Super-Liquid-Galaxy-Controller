import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/components/galaxy_button.dart';
import 'package:super_liquid_galaxy_controller/components/galaxytextfield.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';
import 'package:super_liquid_galaxy_controller/controllers/lg_connection.dart';
import 'package:get/get.dart';

import '../components/custom_dialog.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class SSHCommandsTab extends StatefulWidget {
  const SSHCommandsTab({super.key});

  @override
  State<SSHCommandsTab> createState() => _SSHCommandsTabState();
}

class _SSHCommandsTabState extends State<SSHCommandsTab> with AutomaticKeepAliveClientMixin {
  late double screenHeight;
  late double screenWidth;
  late LGConnection client;

  @override
  void initState() {
    super.initState();
    initializeLGClient();
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

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.05,
            horizontal: screenHeight * 0.25),
        child: SingleChildScrollView(
          child: Obx((){
            return Column(mainAxisSize: MainAxisSize.max, children: [
              GalaxyButton(
                height: screenHeight * 0.1,
                width: screenWidth * 0.7,
                backgroundColor: client.isConnected.value? GalaxyColors.blue : Colors.grey,
                actionText: "SET SLAVES REFRESH",
                icon: Icons.av_timer_rounded,
                onTap: () {
                  if(!client.isConnected.value) {
                    return;
                  }
                  showAlertMessage("Warning!",
                      "This will set a refresh rate on all slave Screens on LG rig",
                      client.setRefresh);
                  //client.setRefresh();
                },
              ),
              GalaxyButton(
                height: screenHeight * 0.1,
                width: screenWidth * 0.7,
                backgroundColor: client.isConnected.value? GalaxyColors.blue : Colors.grey,
                actionText: "RESET SLAVES REFRESH",
                icon: Icons.timer_off_outlined,
                onTap: () {
                  if(!client.isConnected.value) {
                    return;
                  }
                  showAlertMessage("Warning!",
                      "This will reset the refresh rate on all slave Screens on LG rig",
                      client.resetRefresh);
                  // client.resetRefresh();
                },
              ),
              GalaxyButton(
                height: screenHeight * 0.1,
                width: screenWidth * 0.7,
                backgroundColor: client.isConnected.value? GalaxyColors.blue : Colors.grey,
                actionText: "CLEAR KML & LOGOS",
                icon: Icons.cleaning_services_sharp,
                onTap: () {
                  if(!client.isConnected.value) {
                    return;
                  }
                  showAlertMessage("Warning!",
                      "This will clear all KMLs on the LG rig",
                      client.clearKml);

                  //client.clearKml();
                },
              ),
              GalaxyButton(
                height: screenHeight * 0.1,
                width: screenWidth * 0.7,
                backgroundColor: client.isConnected.value? GalaxyColors.blue : Colors.grey,
                actionText: "REBOOT LG",
                icon: Icons.refresh_rounded,
                onTap: () {
                  if(!client.isConnected.value) {
                    return;
                  }
                  showAlertMessage("Warning!",
                      "This will restart all the LG-rig machines",
                      client.rebootLG);

                  // client.rebootLG();
                },
              ),
              GalaxyButton(
                height: screenHeight * 0.1,
                width: screenWidth * 0.7,
                backgroundColor: client.isConnected.value? GalaxyColors.blue : Colors.grey,
                actionText: "RE-LAUNCH LG",
                icon: Icons.reset_tv_rounded,
                onTap: () {
                  if(!client.isConnected.value) {
                    return;
                  }
                  showAlertMessage("Warning!",
                      "Relaunches the Liquid Galaxy core on all rig systems",
                      client.relaunch);
                  // client.relaunch();
                },
              ),
              GalaxyButton(
                height: screenHeight * 0.1,
                width: screenWidth * 0.7,
                backgroundColor: client.isConnected.value? GalaxyColors.blue : Colors.grey,
                actionText: "SHUTDOWN LG",
                icon: Icons.settings_power_rounded,
                onTap: () {
                  if(!client.isConnected.value) {
                    return;
                  }
                  showAlertMessage("Warning!",
                      "This will shut-down all LG-rig machines",
                      client.shutdown);
                  // client.shutdown();
                },
              ),


            ]);}
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void initializeLGClient() async {
    client = Get.find();
    await client.reConnectToLG();
    if (!client.connectStatus()) {
      if (!Get.isSnackbarOpen) {
        Get.showSnackbar(GetSnackBar(
          backgroundColor: Colors.red.shade300,
          title: "Connection Error",
          message: "Unable to connect to Liquid Galaxy rig",
          isDismissible: true,
          duration: 3.seconds,
        ));
      }
    }
  }

  showAlertMessage(String title, String content, Function action) {
    Get.dialog(
      AlertDialog(
        title: Text(title, style: TextStyle(color: Colors.red),),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text("CANCEL", style: TextStyle(color: Colors.black),),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text("CONTINUE", style: TextStyle(color: Colors.red),),
            onPressed: () async {
              await action();
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
