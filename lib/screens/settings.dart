import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';

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
        child: Scaffold(
      body: Center(
        child: SvgPicture.asset(Assets.svgOpenMouth,
            width: 250,
            height: 250,
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.softLight )),
      ),
    ));
  }
}
