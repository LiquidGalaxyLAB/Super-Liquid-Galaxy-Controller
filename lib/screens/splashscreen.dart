import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:super_liquid_galaxy_controller/controllers/showcase_controller.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';
import 'package:super_liquid_galaxy_controller/screens/dashboard.dart';
import 'package:page_transition/page_transition.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late ShowcaseController showcaseController;

  @override
  void initState() {
    super.initState();
    showcaseController = Get.find();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splash: Assets.assetsSlgcLogos,
      splashIconSize: double.infinity,
      screenFunction: () async{
        return ShowCaseWidget(builder: (context){
          return DashBoard();
        },
        onFinish: (){showcaseController.setDashboardCompleted();},);
      },
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
