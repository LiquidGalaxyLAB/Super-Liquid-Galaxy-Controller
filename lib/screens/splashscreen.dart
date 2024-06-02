import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';
import 'package:super_liquid_galaxy_controller/screens/dashboard.dart';
import 'package:typethis/typethis.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {




  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      // animationDuration: Duration(seconds: 1),
      // duration: Duration(seconds: 1),
      backgroundColor: Colors.white,
      onInit: () {
        debugPrint("On Init");
      },
      onEnd: () {

      },
      splashScreenBody: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(Assets.assetsLogo),
            ),
            const SizedBox(
              width: 50,
            ),
            Container(
              width: 1,
              height: 200,
              color: Colors.black,
            ),
            const SizedBox(
              width: 50,
            ),
            const TypeThis(
              string: "Super Liquid Galaxy Controller",
              speed: 50,
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w100),
            )
          ],
        ),
      ),
      nextScreen: DashBoard(),
    );
  }
}
