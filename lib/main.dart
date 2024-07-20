import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_info.dart';
import 'package:super_liquid_galaxy_controller/screens/dashboard.dart';
import 'package:super_liquid_galaxy_controller/screens/maps_controller.dart';
import 'package:super_liquid_galaxy_controller/screens/place_view.dart';
import 'package:super_liquid_galaxy_controller/screens/splashscreen.dart';
import 'package:super_liquid_galaxy_controller/utils/api_manager.dart';
import 'package:super_liquid_galaxy_controller/utils/lg_connection.dart';
import 'package:super_liquid_galaxy_controller/utils/map_movement_controller.dart';
import 'package:super_liquid_galaxy_controller/utils/poi_controller.dart';
import 'package:super_liquid_galaxy_controller/utils/speech_controller.dart';
import 'package:super_liquid_galaxy_controller/utils/tour_controller.dart';
import 'package:super_liquid_galaxy_controller/utils/wikidatafetcher.dart';

AndroidMapRenderer mapRenderer = AndroidMapRenderer.platformDefault;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.lazyPut(() => LGConnection(),fenix: true);
  Get.lazyPut(() => ApiManager(),fenix: true);
  Get.lazyPut(() => SpeechController(),fenix: true);
  Get.lazyPut(() => MapMovementController(),fenix: true);
  Get.lazyPut(() => TourController(),fenix: true);
  Get.lazyPut(() => PoiController(),fenix: true);

  // Get.lazyPut(() => WikiDataFetcher(), fenix:  true);

  LGConnection client = Get.find();
  client.connectToLG();
  SystemChrome.setPreferredOrientations([
    // Lock orientation to landscape
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(), // Root route
        // Settings route
      },
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEEEEEE),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF111111),
        ),
      ),
    );
  }
}
// PlaceView(place: PlaceInfo(coordinate: Coordinates(latitude: 0.0, longitude: 0.0), label: "New York City", address: 'vjhjcckclkcalc', category: 'default', name: 'New York City',description: "New York City comprises 5 boroughs sitting where the Hudson River meets the Atlantic Ocean. At its core is Manhattan, a densely populated borough that’s among the world’s major commercial, financial and cultural centers. Its iconic sites include skyscrapers such as the Empire State Building and sprawling Central Park. Broadway theater is staged in neon-lit Times Square.")
