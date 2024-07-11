import 'package:latlong2/latlong.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as mp;

class Coordinates {
  late double latitude;
  late double longitude;

  Coordinates({
    required this.latitude,
    required this.longitude,
  });
  Coordinates.fromLatLng(LatLng point) {
    latitude = point.latitude;
    longitude = point.longitude;
  }

  Coordinates.fromLatLngMap(mp.LatLng point) {
    latitude = point.latitude;
    longitude = point.longitude;

    longitude += 360.0;
    longitude %= 360.0;
  }

  // Override toString for better debugging output
  @override
  String toString() {
    return 'Coordinates(latitude: $latitude, longitude: $longitude)';
  }

  // Optionally, you can still override == and hashCode for value comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Coordinates otherCoordinates = other as Coordinates;
    return latitude == otherCoordinates.latitude && longitude == otherCoordinates.longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
