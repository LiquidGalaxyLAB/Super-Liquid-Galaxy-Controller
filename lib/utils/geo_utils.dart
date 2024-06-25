import 'dart:math';

import '../data_class/coordinate.dart';

class GeoUtils {
  // Convert latitude and longitude to Cartesian coordinates
  static List<double> _toCartesian(double lat, double lon) {
    double latRad = lat * pi / 180.0;
    double lonRad = lon * pi / 180.0;
    double x = cos(latRad) * cos(lonRad);
    double y = cos(latRad) * sin(lonRad);
    double z = sin(latRad);
    return [x, y, z];
  }

  // Convert Cartesian coordinates back to latitude and longitude
  static List<double> _toLatLon(double x, double y, double z) {
    double lon = atan2(y, x);
    double hyp = sqrt(x * x + y * y);
    double lat = atan2(z, hyp);
    return [lat * 180.0 / pi, lon * 180.0 / pi];
  }

  // Calculate geographic center
  static Coordinates calculateGeographicCenter(List<Coordinates> coords) {
    double x = 0.0;
    double y = 0.0;
    double z = 0.0;

    for (var coord in coords) {
      var cartesian = _toCartesian(coord.latitude, coord.longitude);
      x += cartesian[0];
      y += cartesian[1];
      z += cartesian[2];
    }

    int total = coords.length;
    x /= total;
    y /= total;
    z /= total;

    var center = _toLatLon(x, y, z);
    return Coordinates(latitude: center[0], longitude: center[1]);
  }

  // Calculate the Haversine distance
  static double haversine(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Earth radius in kilometers
    double phi1 = lat1 * pi / 180.0;
    double phi2 = lat2 * pi / 180.0;
    double deltaPhi = (lat2 - lat1) * pi / 180.0;
    double deltaLambda = (lon2 - lon1) * pi / 180.0;

    double a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  // Calculate the <LookAt> element
  static String calculateLookAt(List<Coordinates> coords, double tiltAngle) {
    // Calculate center point
    var center = calculateGeographicCenter(coords);
    double centerLat = center.latitude;
    double centerLon = center.longitude;

    // Calculate bounding box
    double minLat = coords.map((c) => c.latitude).reduce(min);
    double maxLat = coords.map((c) => c.latitude).reduce(max);
    double minLon = coords.map((c) => c.longitude).reduce(min);
    double maxLon = coords.map((c) => c.longitude).reduce(max);

    // Calculate range using the haversine formula
    double diagonalDistance = haversine(minLat, minLon, maxLat, maxLon);
    double tiltRadians = tiltAngle * pi / 180.0; // Convert tilt to radians
    double range = (diagonalDistance / 2.0) / cos(tiltRadians);

    // Create the <LookAt> element
    return '''
    <LookAt>
        <longitude>$centerLon</longitude>
        <latitude>$centerLat</latitude>
        <altitude>0</altitude>
        <heading>0</heading>
        <tilt>$tiltAngle</tilt>
        <range>$range</range>
    </LookAt>
    ''';
  }
}

