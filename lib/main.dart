import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:super_liquid_galaxy_controller/screens/dashboard.dart';
import 'package:super_liquid_galaxy_controller/screens/kml_builder.dart';
import 'package:super_liquid_galaxy_controller/screens/maps_controller.dart';
import 'package:super_liquid_galaxy_controller/screens/test.dart';
import 'package:super_liquid_galaxy_controller/utils/api_manager.dart';
import 'package:super_liquid_galaxy_controller/utils/lg_connection.dart';
import 'package:super_liquid_galaxy_controller/utils/map_movement_controller.dart';
import 'package:super_liquid_galaxy_controller/utils/speech_controller.dart';

AndroidMapRenderer mapRenderer = AndroidMapRenderer.platformDefault;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  /*final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    // Force Hybrid Composition mode.
    mapsImplementation.useAndroidViewSurface = true;
    mapRenderer = await mapsImplementation
        .initializeWithRenderer(AndroidMapRenderer.latest);
  }*/
  Get.lazyPut(() => LGConnection(),fenix: true);
  Get.lazyPut(() => ApiManager(),fenix: true);
  Get.lazyPut(() => SpeechController(),fenix: true);
  Get.lazyPut(() => MapMovementController(),fenix: true);

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
        '/': (context) => const KmlUploader(), // Root route
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
