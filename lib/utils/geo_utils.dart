import 'dart:math';
import 'dart:ui';
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

  static CameraPosition getOptimalCameraPosition(List<LatLng> coordinates, Size mapSize) {
    if (coordinates.isEmpty) {
      return const CameraPosition(target: LatLng(0, 0), zoom: 0);
    }

    var coords = <Coordinates>[];
    for(final point in coordinates) {
      coords.add(Coordinates.fromLatLngMap(point));
    }
    LatLngBounds bounds = getBoundingBox(coords);

    // Calculate the center of the bounds
    double centerLat = (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
    double centerLng = (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
    LatLng center = LatLng(centerLat, centerLng);

    // Calculate the zoom level considering tilt
    double latRange = bounds.northeast.latitude - bounds.southwest.latitude;
    double lngRange = bounds.northeast.longitude - bounds.southwest.longitude;

    double maxRange = max(latRange, lngRange);

    double tilt = 45.0;

    // Adjust the maxRange based on tilt
    double tiltFactor = cos(tilt * pi / 180); // Assuming tilt of 45 degrees
    maxRange = maxRange / tiltFactor;

    double scale = mapSize.width / 256 / (2 * pi) * pow(2, 20); // 256 is the tile size, 20 is max zoom level

    double zoom = (log(scale / maxRange) / log(2)).floorToDouble();

    // Adjust the zoom level if it's too high or too low
    zoom = zoom.clamp(0, 20);

    // Set the tilt


    return CameraPosition(
      target: center,
      zoom: zoom,
      tilt: tilt,
    );
  }

  static double log2(num x) => log(x) / log(2);

  static CameraPosition getOptimalCameraPosition1(List<LatLng> coordinates, Size mapSize) {
    if (coordinates.isEmpty) {
      return const CameraPosition(target: LatLng(0, 0), zoom: 0);
    }

    var coords = <Coordinates>[];
    for (final point in coordinates) {
      coords.add(Coordinates.fromLatLngMap(point));
    }
    LatLngBounds bounds = getBoundingBox(coords);

    // Constants for Earth's radius in meters and equatorial circumference
    const double earthRadius = 6378137;
    const double equatorialCircumference = 2 * pi * earthRadius;

    // Calculate the center of the bounds
    double centerLat = (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
    double centerLng = (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
    LatLng center = LatLng(centerLat, centerLng);

    // Calculate the lat/lng distance
    double latDiff = bounds.northeast.latitude - bounds.southwest.latitude;
    double lngDiff = bounds.northeast.longitude - bounds.southwest.longitude;

    // Calculate the distance in meters
    double latDistance = latDiff * (equatorialCircumference / 360);
    double lngDistance = lngDiff * (equatorialCircumference / 360) * cos(center.latitude * pi / 180);

    // Determine the maximum distance
    double maxDistance = max(latDistance, lngDistance);

    // Print debug information
    print('Bounds: $bounds');
    print('Center: $center');
    print('Latitude Distance: $latDistance');
    print('Longitude Distance: $lngDistance');
    print('Max Distance: $maxDistance');

    // Calculate zoom level
    double zoomLevel = log2(256 * (mapSize.width / maxDistance)) - 8;

    // Print zoom level before clamping
    print('Calculated Zoom Level: $zoomLevel');

    // Ensure zoom level is within bounds
    zoomLevel = zoomLevel.clamp(0, 21).toDouble();

    // Print final zoom level
    print('Clamped Zoom Level: $zoomLevel');

    // Create CameraPosition
    return CameraPosition(
      target: center,
      zoom: zoomLevel,
      tilt: 45,
    );
  }

  static CameraPosition getBoundsZoomLevel(List<LatLng> coordinates, Size mapDim) {

    if (coordinates.isEmpty) {
      return const CameraPosition(target: LatLng(0, 0), zoom: 0);
    }

    var coords = <Coordinates>[];
    for (final point in coordinates) {
      coords.add(Coordinates.fromLatLngMap(point));
    }
    LatLngBounds bounds = getBoundingBox(coords);

    double centerLat = (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
    double centerLng = (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
    LatLng center = LatLng(centerLat, centerLng);

    const WORLD_DIM = Size(256, 256);
    const ZOOM_MAX = 21;

    double latRad(double lat) {
      var sinV = sin(lat * pi / 180);
      var radX2 = log((1 + sinV) / (1 - sinV)) / 2;
      return max(min(radX2, pi), -pi) / 2;
    }

    int zoom(mapPx, worldPx, fraction) {
      return (log(mapPx / worldPx / fraction) / ln2).floor();
    }

    var ne = bounds.northeast;
    var sw = bounds.southwest;

    var latFraction = (latRad(ne.latitude) - latRad(sw.latitude)) / pi;

    print(latFraction);
    latFraction = max(0.000001,latFraction);

    var lngDiff = ne.longitude - sw.longitude;
    var lngFraction = ((lngDiff < 0) ? (lngDiff + 360) : lngDiff) / 360;

    print(lngFraction);
    lngFraction = max(0.000001, lngFraction);

    var latZoom = zoom(mapDim.height, WORLD_DIM.height, latFraction);
    var lngZoom = zoom(mapDim.width, WORLD_DIM.width, lngFraction);

    var zoomV = min(latZoom.toDouble(), min(lngZoom.toDouble(), ZOOM_MAX.toDouble()));

    return CameraPosition(target: center,zoom: zoomV, tilt: 30.0);
  }



  // Calculate the <LookAt> element
  /*static String calculateLookAt(List<Coordinates> coords, double tiltAngle) {
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
  }*/

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

