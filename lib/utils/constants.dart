import 'dart:math';

import '../generated/assets.dart';
class Constants {
  static double appBarHeight = 80;
  static double tabBarWidthDivider = 5;
  static double splashAspectRatio = 2864 / 3000;
  static double lgZoomScale = 130000000.0;
  static double appZoomScale = 11;
  static double tourZoomScale = 16;
  static double orbitZoomScale = 13;
  static double defaultZoomScale = 2;
  static double dashboardUIRoundness = 20;
  static double dashboardUISpacing = 10;
  static double dashboardUIHeightFactor = 0.65;
  static Duration animationDuration = const Duration(milliseconds: 375);
  static double animationDurationDouble = 375;
  static Duration screenshotDelay = const Duration(milliseconds: 1000);
  static double animationDistance = 50;
  static double orbitRange = 40000;
  static double tabBarTextSize = 17;
  static double appBarTextSize = 18;
  static double homePageTextSize = 17;
  static double dashboardTextSize = 16;
  static double tourTextSize = 17;
  static double dashboardChartTextSize = 17;
  static List<String> tourismCategories = [
    "city_gate",
    "archaeological_site",
    "sights",
    "attraction",
    "temple",
    "memorial",
    "place_of_worship",
    "artwork",
    "viewpoint",
    "monument",
    "castle",
    "ruines",
    "tomb",
    "shrine",
    "wayside_cross",
    "chapel",
    "fort",
    "tower",
    "locomotive",
    "battlefield",
    "boundary_stone",
    "default"
  ];
  static List<String> assetPaths = [
    Assets.placeIconsGate,
    Assets.placeIconsArchaeology,
    Assets.placeIconsSights,
    Assets.placeIconsSights,
    Assets.placeIconsTemple,
    Assets.placeIconsObelisk,
    Assets.placeIconsTemple,
    Assets.placeIconsSights,
    Assets.placeIconsObelisk,
    Assets.placeIconsCastle,
    Assets.placeIconsArchaeology,
    Assets.placeIconsTombstone,
    Assets.placeIconsShrine,
    Assets.placeIconsTombstone,
    Assets.placeIconsChapel,
    Assets.placeIconsCastle,
    Assets.placeIconsObelisk,
    Assets.placeIconsObelisk,
    Assets.placeIconsObelisk,
    Assets.placeIconsStrategy,
    Assets.placeIconsObelisk,
    Assets.placeIconsObelisk,
  ];
}
extension ZoomLG on num {
  double get zoomLG =>
      Constants.lgZoomScale / pow(2, this); // Formula to match zoom of GMap with LG
}

extension RigCalculator on num {
  double get rightMostRig => (this ~/ 2 +1);
  double get leftMostRig => (this ~/ 2 +2);
}