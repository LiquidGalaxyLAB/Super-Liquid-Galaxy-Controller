import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/components/galaxy_button.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class SSHCommandsTab extends StatefulWidget {
  const SSHCommandsTab({super.key});

  @override
  State<SSHCommandsTab> createState() => _SSHCommandsTabState();
}

class _SSHCommandsTabState extends State<SSHCommandsTab> {
  late double screenHeight;
  late double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

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
            ),
            GalaxyButton(
              height: screenHeight * 0.1,
              width: screenWidth * 0.7,
              backgroundColor: GalaxyColors.blue,
              actionText: "RESET SLAVES REFRESH",
              icon: Icons.timer_off_outlined,
            ),
            GalaxyButton(
              height: screenHeight * 0.1,
              width: screenWidth * 0.7,
              backgroundColor: GalaxyColors.blue,
              actionText: "CLEAR KML & LOGOS",
              icon: Icons.cleaning_services_sharp,
            ),
            GalaxyButton(
              height: screenHeight * 0.1,
              width: screenWidth * 0.7,
              backgroundColor: GalaxyColors.blue,
              actionText: "REBOOT LG",
              icon: Icons.refresh_rounded,
            ),
            GalaxyButton(
              height: screenHeight * 0.1,
              width: screenWidth * 0.7,
              backgroundColor: GalaxyColors.blue,
              actionText: "RE-LAUNCH LG",
              icon: Icons.reset_tv_rounded,
              onTap: (){},
            ),
            GalaxyButton(
              height: screenHeight * 0.1,
              width: screenWidth * 0.7,
              backgroundColor: GalaxyColors.blue,
              actionText: "SHUTDOWN LG",
              icon: Icons.settings_power_rounded,
            ),

          ]),
        ),
      ),
    );
  }
}
