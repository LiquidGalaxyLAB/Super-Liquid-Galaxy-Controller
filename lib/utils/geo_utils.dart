import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as ll;
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

  static LatLngBounds getBoundingBox(List<Coordinates> coordinatesList) {
    if (coordinatesList.isEmpty) {
      throw ArgumentError("The coordinates list cannot be empty.");
    }

    double minLat = double.infinity;
    double minLng = double.infinity;
    double maxLat = -double.infinity;
    double maxLng = -double.infinity;

    for (var coord in coordinatesList) {
      if (coord.latitude < minLat) minLat = coord.latitude;
      if (coord.longitude < minLng) minLng = coord.longitude;
      if (coord.latitude > maxLat) maxLat = coord.latitude;
      if (coord.longitude > maxLng) maxLng = coord.longitude;
    }

    /*maxLng +=360;
    maxLng %=360;
    minLng +=360;
    minLng %=360;*/

    print(minLng);
    print(maxLng);
    LatLng southwest = LatLng(minLat, minLng);
    LatLng northeast = LatLng(maxLat, maxLng);

    print(LatLngBounds(southwest: southwest,northeast:  northeast));
    return LatLngBounds(southwest: southwest,northeast:  northeast);
  }

  static List<LatLngBounds> splitLatLngBounds(LatLngBounds bounds, double maxDistance) {
    final distance = ll.Distance();

    final LatLng southWest = bounds.southwest;
    final LatLng northEast = bounds.northeast;

    // Normalize longitudes to the range [-180, 180]
    double swLng = southWest.longitude;
    double neLng = northEast.longitude;

    if (swLng > neLng) {
      neLng += 360;  // Handle wrap-around
    }

    // Calculate the distance between the southwest and northeast corners
    double totalLatDistance = distance.as(
      ll.LengthUnit.Meter,
      ll.LatLng(southWest.latitude, southWest.longitude),
      ll.LatLng(northEast.latitude, southWest.longitude),
    );

    double totalLngDistance = distance.as(
      ll.LengthUnit.Meter,
      ll.LatLng(southWest.latitude, swLng),
      ll.LatLng(southWest.latitude, neLng),
    );

    // Check if the bounds are already within the maxDistance
    if (totalLatDistance <= maxDistance && totalLngDistance <= maxDistance) {
      return [bounds];
    }

    // Number of divisions along latitude and longitude
    int latDivisions = (totalLatDistance / maxDistance).ceil();
    int lngDivisions = (totalLngDistance / maxDistance).ceil();

    // Calculate the latitude and longitude step size
    double latStep = (northEast.latitude - southWest.latitude) / latDivisions;
    double lngStep = (neLng - swLng) / lngDivisions;

    List<LatLngBounds> boundsList = [];

    for (int i = 0; i < latDivisions; i++) {
      for (int j = 0; j < lngDivisions; j++) {
        LatLng sw = LatLng(
          southWest.latitude + i * latStep,
          (swLng + j * lngStep) % 360,
        );
        LatLng ne = LatLng(
          sw.latitude + latStep,
          (sw.longitude + lngStep) % 360,
        );

        // Adjust if the northeast point exceeds the original bounds
        if (ne.latitude > northEast.latitude) {
          ne = LatLng(northEast.latitude, ne.longitude);
        }
        if (ne.longitude > northEast.longitude) {
          ne = LatLng(ne.latitude, northEast.longitude % 360);
        }

        boundsList.add(LatLngBounds(southwest: sw, northeast: ne));
      }
    }
    return boundsList;
  }

  /*static double calculateCoverage(LatLngBounds bounds, List<LatLng> polygon) {
    var bboxPolygon = turf.bboxPolygon([
      bounds.southwest.longitude,
      bounds.southwest.latitude,
      bounds.northeast.longitude,
      bounds.northeast.latitude,
    ]);

    var polygonFeature = turf.Polygon([polygon.map((e) => [e.longitude, e.latitude]).toList()]);

    var intersection = turf.intersect(bboxPolygon, polygonFeature);
    if (intersection == null) {
      return 0.0;
    }

    var bboxArea = turf.area(bboxPolygon);
    var intersectionArea = turf.area(intersection);

    return intersectionArea / bboxArea;
  }*/

  static List<Coordinates> getLatLngBoundsPolygon(LatLngBounds bounds) {
    LatLng southwest = bounds.southwest;
    LatLng northeast = bounds.northeast;
    LatLng northwest = LatLng(northeast.latitude, southwest.longitude);
    LatLng southeast = LatLng(southwest.latitude, northeast.longitude);

    return [
      Coordinates.fromLatLngMap(southwest),
      Coordinates.fromLatLngMap(northwest),
      Coordinates.fromLatLngMap(northeast),
      Coordinates.fromLatLngMap(southeast),
    ];
  }


}

