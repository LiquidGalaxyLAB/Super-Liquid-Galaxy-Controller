import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data_class/map_position.dart';

class MapMovementController extends GetxController {
  late GoogleMapController _mapController;
  var currentMapType = MapType.normal.obs;
  Timer? _movementTimer;
  MapPosition _currentPosition = MapPosition(
    latitude: 0.0,
    longitude: 0.0,
    bearing: 0.0,
    tilt: 0.0,
    zoom: 0.0,
  );

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void setPosition(MapPosition position) {
    _currentPosition = position;
    _mapController.animateCamera(
        CameraUpdate.newCameraPosition(position.toCameraPosition()));
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

  void _moveCamera(LatLng target) {
    _mapController.animateCamera(CameraUpdate.newLatLng(target));
  }

  void _startMovement(Function(LatLng) updatePosition) {
    _movementTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      LatLng currentLatLng =
          LatLng(_currentPosition.latitude, _currentPosition.longitude);
      LatLng newLatLng = updatePosition(currentLatLng);
      _currentPosition.latitude = newLatLng.latitude;
      _currentPosition.longitude = newLatLng.longitude;
      _moveCamera(newLatLng);
    });
  }

  void moveUp() {
    _startMovement((LatLng current) {
      return LatLng(current.latitude + 0.001, current.longitude);
    });
  }

  void moveDown() {
    _startMovement((LatLng current) {
      return LatLng(current.latitude - 0.001, current.longitude);
    });
  }

  void moveLeft() {
    _startMovement((LatLng current) {
      return LatLng(current.latitude, current.longitude - 0.001);
    });
  }

  void moveRight() {
    _startMovement((LatLng current) {
      return LatLng(current.latitude, current.longitude + 0.001);
    });
  }

  void stop() {
    _movementTimer?.cancel();
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
    switch (index) {
      case 0:
        {
          zoomIn();
        }
      case 1:
        {
          zoomOut();
        }

    }
  }
}
