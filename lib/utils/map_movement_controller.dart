import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data_class/map_position.dart';

class MapMovementController extends GetxController {
  late GoogleMapController _mapController;
  var currentMapType = MapType.normal.obs;
  Timer? _movementTimer;
  Timer? _zoomTimer;

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }


  void zoomIn() {
    _mapController.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    _mapController.animateCamera(CameraUpdate.zoomOut());
  }

  void switchMapType() {
    currentMapType.value = currentMapType.value == MapType.normal
        ? MapType.satellite
        : MapType.normal;
  }

  void _scrollBy(double x, double y) {
    _mapController.animateCamera(CameraUpdate.scrollBy(x, y));
  }

  void _startMovement(double x, double y) {
    _movementTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _scrollBy(x, y);
    });
  }

  void _startZoom(int index)
  {
    _zoomTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if(index==0)
        zoomIn();
      else
        zoomOut();
    });
  }

  void moveUp() {
    stop();
    _startMovement(0, -100);
  }

  void moveDown() {
    stop();
    _startMovement(0, 100);
  }

  void moveLeft() {
    stop();
    _startMovement(-100, 0);
  }

  void moveRight() {
    stop();
    _startMovement(100, 0);
  }

  void stop() {
    _movementTimer?.cancel();
    _zoomTimer?.cancel();
  }

  void moveTo(CameraPosition cameraPosition) async
  {
    await _mapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition));
  }

  void moveByIndex(int index) {
    switch (index) {
      case 0:
        {
          moveUp();
        }
      case 1:
        {
          moveDown();
        }
      case 2:
        {
          moveLeft();
        }
      case 3:
        {
          moveRight();
        }
    }
  }

  void zoomByIndex(int index) {
    /*switch (index) {
      case 0:
        {
          zoomIn();
        }
      case 1:
        {
          zoomOut();
        }

    }*/
    _startZoom(index);
  }
}
