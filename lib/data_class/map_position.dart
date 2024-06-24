import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/data_class/look_at.dart';

class MapPosition {
  double latitude;
  double longitude;
  double bearing;
  double tilt;
  double zoom;

  MapPosition({
    required this.latitude,
    required this.longitude,
    required this.bearing,
    required this.tilt,
    required this.zoom,
  });

  // Override toString for better debugging output
  @override
  String toString() {
    return 'MapPosition(latitude: $latitude, longitude: $longitude, bearing: $bearing, tilt: $tilt, zoom: $zoom)';
  }

  // Override == for value comparison
  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;
    if (other is! MapPosition) return false;
    return latitude == other.latitude &&
        longitude == other.longitude &&
        bearing == other.bearing &&
        tilt == other.tilt &&
        zoom == other.zoom;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ bearing.hashCode ^ tilt.hashCode ^ zoom.hashCode;


  CameraPosition toCameraPosition() {
    return CameraPosition(
      target: LatLng(latitude, longitude),
      bearing: bearing,
      tilt: tilt,
      zoom: zoom,
    );
  }

  void updateFromCameraPosition(CameraPosition cameraPosition) {
    latitude = cameraPosition.target.latitude;
    longitude = cameraPosition.target.longitude;
    bearing = cameraPosition.bearing;
    tilt = cameraPosition.tilt;
    zoom = 591657550.500000 / pow(2, cameraPosition.zoom);
  }

  void updateFromCoordinates(Coordinates coordinates) {
    latitude = coordinates.latitude;
    longitude = coordinates.longitude;
  }

  toLookAt(int rigCount)
  {
    return LookAt(longitude, latitude, zoom/rigCount, tilt, bearing);
  }

}
