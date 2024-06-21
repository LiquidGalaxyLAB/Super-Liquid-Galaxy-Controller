import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:super_liquid_galaxy_controller/data_class/map_position.dart';
import 'package:super_liquid_galaxy_controller/utils/lg_connection.dart';

class MapController extends StatefulWidget {
  const MapController({super.key});

  @override
  State<MapController> createState() => MapControllerState();
}

class MapControllerState extends State<MapController> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  MapPosition position = MapPosition(
      latitude: 28.65665656297236,
      longitude: -17.885454520583153,
      bearing: 61.403038024902344,
      tilt: 41.82725143432617,
      zoom: 591657550.500000 / pow(2, 13.15393352508545));

  late LGConnection client;


  @override
  void initState() {
    super.initState();
    updateToCurrentLocation();
    bootLGClient();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          minMaxZoomPreference: MinMaxZoomPreference.unbounded,
          mapToolbarEnabled: true,
          tiltGesturesEnabled: true,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          compassEnabled: true,
          mapType: MapType.hybrid,
          initialCameraPosition: position.toCameraPosition()
          ,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onCameraMove: _onCameraMove,
        ),
      ),
    );
  }

  void _onCameraMove(CameraPosition camera) {
    position.updateFromCameraPosition(camera);
    print(position);
  }

  void _onCameraIdle() {
    // motionControls(
    //     latvalue, longvalue, zoomvalue / rigcount, tiltvalue, bearingvalue);
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var point = await Geolocator.getCurrentPosition();
    //_getCity(locator.latitude, locator.longitude);
    setState(() {
      position.latitude = point.latitude;
      position.longitude = point.longitude;
    });
  }

  void updateToCurrentLocation() async {
    await _determinePosition();
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(position.toCameraPosition()));
  }

  void bootLGClient() async {
    client = LGConnection.instance;
    await client.reConnectToLG();
    if(!client.connectStatus())
      {

      }
  }
}
