import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/components/galaxy_button.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';
import 'package:super_liquid_galaxy_controller/utils/lg_connection.dart';
import 'package:get/get.dart';
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
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            GalaxyButton(
              height: screenHeight * 0.1,
              width: screenWidth * 0.7,
              backgroundColor: GalaxyColors.blue,
              actionText: "SET SLAVES REFRESH",
              icon: Icons.av_timer_rounded,
              onTap: () {
                client.setRefresh();
              },
            ),
            GalaxyButton(
              height: screenHeight * 0.1,
              width: screenWidth * 0.7,
              backgroundColor: GalaxyColors.blue,
              actionText: "RESET SLAVES REFRESH",
              icon: Icons.timer_off_outlined,
              onTap: () {
                client.resetRefresh();
              },
            ),
            GalaxyButton(
              height: screenHeight * 0.1,
              width: screenWidth * 0.7,
              backgroundColor: GalaxyColors.blue,
              actionText: "CLEAR KML & LOGOS",
              icon: Icons.cleaning_services_sharp,
              onTap: () {
                client.clearKml();
              },
            ),
            GalaxyButton(
              height: screenHeight * 0.1,
              width: screenWidth * 0.7,
              backgroundColor: GalaxyColors.blue,
              actionText: "REBOOT LG",
              icon: Icons.refresh_rounded,
              onTap: () {
                client.rebootLG();
              },
            ),
            GalaxyButton(
              height: screenHeight * 0.1,
              width: screenWidth * 0.7,
              backgroundColor: GalaxyColors.blue,
              actionText: "RE-LAUNCH LG",
              icon: Icons.reset_tv_rounded,
              onTap: () {
                client.relaunch();
              },
            ),
            GalaxyButton(
              height: screenHeight * 0.1,
              width: screenWidth * 0.7,
              backgroundColor: GalaxyColors.blue,
              actionText: "SHUTDOWN LG",
              icon: Icons.settings_power_rounded,
              onTap: () {
                client.shutdown();
              },
            ),

          ]),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void initializeLGClient() async {
    client = LGConnection.instance;
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
}
