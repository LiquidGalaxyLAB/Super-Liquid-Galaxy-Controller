import 'dart:math' as Math;
import 'dart:math';

import 'package:latlong2/latlong.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/data_class/kml_element.dart';
import 'package:super_liquid_galaxy_controller/utils/geo_utils.dart';

class KMLGenerator {
  static String generateBlank(String id) {
    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document id="$id">
  </Document>
</kml>
    ''';
  }

  static getPlacemark(Placemark placeMark) => '''<Placemark>
  <name>${placeMark.label}</name>
  <description>
  ${placeMark.description}
  </description>
  <Point>
  <coordinates>${placeMark.coordinate.longitude},${placeMark.coordinate.latitude}</coordinates>
  </Point>
  </Placemark>''';

  static getCoordinateList(List<Coordinates> list) {
    var coordinates = '';
    for (final coordinate in list) {
      coordinates += '${coordinate.longitude},${coordinate.latitude},0 ';
    }
    return '''<coordinates>${coordinates}</coordinates>''';
  }

  static getLineString(LineString placeMark) => '''<Placemark>
  <name>${placeMark.label}</name>
  <description>
  ${placeMark.description}
  </description>
  <styleUrl>#lineStyle</styleUrl>
  <LineString>
  <tessellate>1</tessellate>
  ${getCoordinateList(placeMark.coordinates)}
  </LineString>
  </Placemark>''';

  static getLinearRing(PolyGon placeMark) => '''<Placemark>
  <name>${placeMark.label}</name>
  <description>
  ${placeMark.description}
  </description>
  <styleUrl>#polyStyle</styleUrl>
  <Polygon>
  <extrude>1</extrude>
  <outerBoundaryIs>
  <LinearRing>
  ${getCoordinateList(placeMark.coordinates)}
  </LinearRing>
  </outerBoundaryIs>
  </Polygon>
  </Placemark>''';

  static String generateCustomKml(String id, List<KmlElement> list) {
    var visList = '';
    List<Coordinates> coordsList = [];
    for (final item in list) {
      switch (item.index) {
        case 0:
          {
            Placemark element = item.elementData;
            visList += getPlacemark(element);
            coordsList.add(element.coordinate);
          }
        case 1:
          {
            LineString element = item.elementData;
            visList += getLineString(element);
            coordsList.addAll(element.coordinates);
          }
        case 2:
          {
            PolyGon element = item.elementData;
            element.coordinates.add(element.coordinates[0]);
            visList += getLinearRing(element);
            coordsList.addAll(element.coordinates);
          }
        default:
          {
            Placemark element = item.elementData;
            visList += getPlacemark(element);
            coordsList.add(element.coordinate);
          }
      }
    }

    var lookAt = '';
    lookAt += GeoUtils.calculateLookAt(coordsList, 45);

    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document id="$id">
  <Style id="lineStyle">
      <LineStyle>
        <color>7fffffff</color>
        <width>4</width>
      </LineStyle>
      <PolyStyle>
        <color>7f00ff00</color>
      </PolyStyle>
    </Style>
    <Style id="polyStyle">
      <LineStyle>
        <width>3</width>
        <color>ffff5500</color>
      </LineStyle>
      <PolyStyle>
        <color>a1ffaa00</color>
      </PolyStyle>
    </Style>
  ${visList}
  </Document>
</kml>
    ''';
  }

  static String generateKml(String id, String kml) {
    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document id="$id">
  <Style id="lineStyle">
      <LineStyle>
        <color>7fffffff</color>
        <width>4</width>
      </LineStyle>
      <PolyStyle>
        <color>7f00ff00</color>
      </PolyStyle>
    </Style>
    <Style id="rs">
      <LineStyle>
        <color>ff00ffff</color>
        <width>5</width>
      </LineStyle>
    </Style>
    <Style id="polyStyle">
      <LineStyle>
        <width>3</width>
        <color>ffff5500</color>
      </LineStyle>
      <PolyStyle>
        <color>a1ffaa00</color>
      </PolyStyle>
    </Style>
    <Style id="ps">
      <LineStyle>
        <width>3</width>
        <color>ff777777</color>
      </LineStyle>
      <PolyStyle>
        <color>ffffffff</color>
      </PolyStyle>
    </Style>
  $kml
  </Document>
</kml>
    ''';
  }

  static String generateFootprintTopPolygon(
      LatLng center, double length, double width, double angle) {
    final Distance distance = Distance();
    List<LatLng> footprintPoints = [];
    //double x = 0.7;
    // Generate points around the ellipse
    for (int i = 0; i <= 360; i += 5) {
      double theta = i * (Math.pi / 180);
      double x = (length / 2) * Math.cos(theta);
      double y;
      if (i <= 225 && i >= 135) {
        y = (width / 2.0) * Math.sin(130.0 * (Math.pi / 180.0));
        continue;
      } else {
        y = (width / 2) * Math.sin(theta);
      }
      // Rotate the point by the given angle
      double rotatedX = x * Math.cos(angle) - y * Math.sin(angle);
      double rotatedY = x * Math.sin(angle) + y * Math.cos(angle);

      print(
          "$i -($x,$y), ($rotatedX,$rotatedY) - dist: ${Math.sqrt(rotatedX * rotatedX + rotatedY * rotatedY)}");

      LatLng point = distance.offset(
          center,
          Math.sqrt(rotatedX * rotatedX + rotatedY * rotatedY),
          (Math.atan2(rotatedY, rotatedX) * (180 / Math.pi)));
      print("$center -> $point");

      footprintPoints.add(point);
    }

    // Generate KML string for the polygon
    String kml = '''
      <Placemark>
      <styleUrl>#ps</styleUrl>
        <Polygon>
        <extrude>2</extrude>
        <altitudeMode>relativeToGround</altitudeMode>
          <outerBoundaryIs>
            <LinearRing>
              <coordinates>
  ''';

    for (LatLng point in footprintPoints) {
      kml += '${point.longitude},${point.latitude},100 ';
    }

    kml += '''
              </coordinates>
            </LinearRing>
          </outerBoundaryIs>
        </Polygon>
      </Placemark>
  ''';

    return kml;
  }

  static String generateFootprintBottomPolygon(
      LatLng center, double length, double width, double angle) {
    final Distance distance = Distance();
    List<LatLng> footprintPoints = [];
    //double x = 0.7;
    // Generate points around the ellipse
    for (int i = 0; i < 360; i += 5) {
      double theta = i * (Math.pi / 180);
      double x = (length / 2) * Math.cos(theta);
      double y;
      if (i < 60 || i >= 300) {
        y = (width / 2.0) * Math.sin(130.0 * (Math.pi / 180.0));
        continue;
      } else {
        y = (width / 2) * Math.sin(theta);
      }

      //double y = ( i<=225 && i>=135)?((width / 2.0) * Math.sin(225.0 * (Math.pi / 180.0))):(width / 2) * Math.sin(theta);

      // Rotate the point by the given angle
      double rotatedX = x * Math.cos(angle) - y * Math.sin(angle);
      double rotatedY = x * Math.sin(angle) + y * Math.cos(angle);

      //print("$i - ($rotatedX,$rotatedY) - dist: ${Math.sqrt(rotatedX * rotatedX + rotatedY * rotatedY)}");

      //print(Math.atan2(rotatedY, rotatedX) * (180.0 / Math.pi));
      LatLng point = distance.offset(
          center,
          Math.sqrt(rotatedX * rotatedX + rotatedY * rotatedY),
          (Math.atan2(rotatedY, rotatedX) * (180.0 / Math.pi)));
      footprintPoints.add(point);
    }

    // to close the top of the polygon
    int i = 60;
    double theta = i * (Math.pi / 180);
    double x = (length / 2) * Math.cos(theta);
    double y = (width / 2) * Math.sin(theta);

    //double y = ( i<=225 && i>=135)?((width / 2.0) * Math.sin(225.0 * (Math.pi / 180.0))):(width / 2) * Math.sin(theta);

    // Rotate the point by the given angle
    double rotatedX = x * Math.cos(angle) - y * Math.sin(angle);
    double rotatedY = x * Math.sin(angle) + y * Math.cos(angle);

    //print("$i - ($rotatedX,$rotatedY) - dist: ${Math.sqrt(rotatedX * rotatedX + rotatedY * rotatedY)}");

    LatLng point = distance.offset(
        center,
        Math.sqrt(rotatedX * rotatedX + rotatedY * rotatedY),
        Math.atan2(rotatedY, rotatedX) * (180 / Math.pi));
    footprintPoints.add(point);

    // Generate KML string for the polygon
    String kml = '''
      <Placemark>
      <styleUrl>#ps</styleUrl>
        <Polygon>
        <extrude>2</extrude>
        <altitudeMode>relativeToGround</altitudeMode>
          <outerBoundaryIs>
            <LinearRing>
              <coordinates>
  ''';

    for (LatLng point in footprintPoints) {
      kml += '${point.longitude},${point.latitude},100 ';
    }

    kml += '''
              </coordinates>
            </LinearRing>
          </outerBoundaryIs>
        </Polygon>
      </Placemark>
  ''';

    return kml;
  }

  static String generatefootPrintLine(
      LatLng start, LatLng end, double dashLength, double gapLength) {
    final Distance distance = Distance();
    final double totalDistance = distance(start, end);
    final double segmentLength = dashLength + gapLength;
    int numSegments = (totalDistance / segmentLength).floor();
    //numSegments = 1;
    List<String> kmlSegments = [];

    for (int i = 0; i < numSegments; i++) {
      // Calculate the start point of the dash
      LatLng footBottom = distance.offset(
          start, i * segmentLength, distance.bearing(start, end));
      // Calculate the end point of the dash
      LatLng footTop =
          distance.offset(footBottom, dashLength, distance.bearing(start, end));

      print("Line Segment - Bearing: ${distance.bearing(start, end)}");
      kmlSegments.add(generateFootprintBottomPolygon(footTop, dashLength,
          gapLength, degToRadian(distance.bearing(start, end))));
      kmlSegments.add(generateFootprintTopPolygon(footBottom, dashLength / 2,
          gapLength, degToRadian(distance.bearing(start, end))));
    }

    String kml = '';
    kml += kmlSegments.join();
    //kml += '</Folder>';

    return generateKml('69', kml);
  }

  static double transformAngle(double angle) {
    // Normalize the input angle to be within [-180, 180]
    angle = angle % 360;
    if (angle > 180) {
      angle -= 360;
    } else if (angle < -180) {
      angle += 360;
    }

    // Transform the angle based on the positive Y-axis
    double transformedAngle = 90 - angle;

    // Normalize the transformed angle to be within [0, 360]
    if (transformedAngle < 0) {
      transformedAngle += 360;
    }

    return transformedAngle;
  }

  static String generateDashedLineString(
      LatLng start, LatLng end, double dashLength, double gapLength) {
    final Distance distance = Distance();
    final double totalDistance = distance(start, end);
    final double segmentLength = dashLength + gapLength;
    final int numSegments = (totalDistance / segmentLength).floor();

    List<String> kmlSegments = [];

    /*kmlSegments.add('''
    <Placemark>
    <Style>
      <LineStyle>
        <color>ff4d4d4d</color>
        <width>15</width>
      </LineStyle>
    </Style>
      <LineString>
      <tessellate>1</tessellate>
        <coordinates>
          ${start.longitude},${start.latitude},0
          ${end.longitude},${end.latitude},0
        </coordinates>
      </LineString>
    </Placemark>
      ''');*/

    var bearing = distance.bearing(start, end);
    LatLng roadStart1 =
        distance.offset(start, gapLength, bearing - 90);
    LatLng roadStart2 =
        distance.offset(start, gapLength, bearing + 90);
    LatLng roadEnd1 =
        distance.offset(end, gapLength, bearing + 90);
    LatLng roadEnd2 =
        distance.offset(end, gapLength, bearing - 90);
    kmlSegments.add('''<Placemark>
  <Style>
      <PolyStyle>
        <color>ff4d4d4d</color>
      </PolyStyle>
    </Style>
  <Polygon>
  <outerBoundaryIs>
  <LinearRing>
  <tessellate>1</tessellate>
  <coordinates>
  ${getCoordinateList([
          Coordinates.fromLatLng(roadEnd1),
          Coordinates.fromLatLng(roadEnd2),
          Coordinates.fromLatLng(roadStart1),
          Coordinates.fromLatLng(roadStart2),
          Coordinates.fromLatLng(roadEnd1),
        ])}
 </coordinates>
  </LinearRing>
  </outerBoundaryIs>
  </Polygon>
  </Placemark>''');

    for (int i = 0; i < numSegments; i++) {
      // Calculate the start point of the dash
      LatLng dashStart = distance.offset(
          start, i * segmentLength, distance.bearing(start, end));
      // Calculate the end point of the dash
      LatLng dashEnd =
          distance.offset(dashStart, dashLength, distance.bearing(start, end));

      kmlSegments.add('''
    <Placemark>
    <styleUrl>#rs</styleUrl>
      <LineString>
        <coordinates>
          ${dashStart.longitude},${dashStart.latitude},0
          ${dashEnd.longitude},${dashEnd.latitude},0
        </coordinates>
      </LineString>
    </Placemark>
    ''');
    }

    String kml = '';
    kml += kmlSegments.join();
    //kml += '</Folder>';

    return generateKml('69', kml);
  }

  static double smoothCurve(double x) {
    // Ensure x is within the range [0, 1]
    if (x < 0) return 0;
    if (x > 1) return 0;
    return sin(pi * x);
  }

  static String generateAirplaneTrack(
      LatLng start, LatLng end, double dashLength, double gapLength) {
    final Distance distance = Distance();
    final double totalDistance = distance(start, end);
    final double segmentLength = dashLength + gapLength;
    final int numSegments = (totalDistance / segmentLength).floor();

    List<String> kmlSegments = [];
    const double maxHeight = 500000.0;
    var stepCount = numSegments*2;
    var stepSize = 1.0/stepCount;
    var steps = 0.0;
    // var altitude = 0.0;
    for (int i = 0; i < numSegments; i++) {
      // Calculate the start point of the dash
      LatLng dashStart = distance.offset(
          start, i * segmentLength, distance.bearing(start, end));
      // Calculate the end point of the dash
      LatLng dashEnd =
      distance.offset(dashStart, dashLength, distance.bearing(start, end));
      var altitude1 = smoothCurve(steps)*maxHeight;
      steps+=stepSize;
      var altitude2 = smoothCurve(steps)*maxHeight;
      steps+=stepSize;
      kmlSegments.add('''
    <Placemark>
      <LineString>
      <altitudeMode>relativeToGround</altitudeMode>
        <coordinates>
          ${dashStart.longitude},${dashStart.latitude},$altitude1
          ${dashEnd.longitude},${dashEnd.latitude},$altitude2
        </coordinates>
      </LineString>
    </Placemark>
    ''');
    }

    String kml = '';
    kml += kmlSegments.join();
    //kml += '</Folder>';

    return generateKml('69', kml);
  }

  static generateFootprints(
      LatLng start, LatLng end, double dashLength, double gapLength) {
    final Distance distance = Distance();
    final double totalDistance = distance(start, end);
    final double segmentLength = dashLength + gapLength;
    int numSegments = (totalDistance / segmentLength).floor();

    numSegments = 1;

    List<List<LatLng>> pointList = [];
    List<String> kmlSegments = [];

    for (int i = 0; i < numSegments; i++) {
      LatLng point1 = distance.offset(
          start, i * segmentLength, distance.bearing(start, end));
      LatLng point2 = distance.offset(
          point1, dashLength * 0.3, distance.bearing(start, end));
      LatLng point3 = distance.offset(
          point2, dashLength * 0.1, distance.bearing(start, end));
      LatLng point4 = distance.offset(
          point3, dashLength * 0.6, distance.bearing(start, end));

      pointList.add([point1, point2, point3, point4]);

      kmlSegments.add(createEllipse(point1, point3, gapLength));
      kmlSegments.add(createEllipse(point2, point4, gapLength));
    }

    //print(pointList);

    String kml = '';
    kml += kmlSegments.join();

    return generateKml('69', kml);
  }

  static String createEllipse(
      LatLng bottomPoint, LatLng topPoint, double width) {
    final Distance distance = Distance();
    LatLng center = distance.offset(
        bottomPoint,
        distance.distance(bottomPoint, topPoint) / 2.0,
        distance.bearing(bottomPoint, topPoint));
    final double length = distance.distance(bottomPoint, topPoint);
    final double angle = distance.bearing(bottomPoint, topPoint);
    List<LatLng> ellipsePoints = [];
    print("kml: $angle");
    print("kml: top point -$topPoint");
    print("kml: bottom point -$bottomPoint");

    for (int i = 0; i <= 360; i += 5) {
      double theta = i * (Math.pi / 180);
      double rotatedX = (length / 2.0) * Math.cos(theta);
      double rotatedY = (width / 2.0) * Math.sin(theta);
      // double rotatedX = x * Math.cos(angle) - y * Math.sin(angle);
      // double rotatedY = x * Math.sin(angle) + y * Math.cos(angle);
      LatLng point = distance.offset(
          center,
          Math.sqrt(rotatedX * rotatedX + rotatedY * rotatedY),
          Math.atan2(rotatedY, rotatedX) * (180.0 / Math.pi));
      if (((Math.atan2(rotatedY, rotatedX) * (180.0 / Math.pi)) - angle)
              .abs() <=
          2)
        print(
            "kml: point debug - $point, ${Math.atan2(rotatedY, rotatedX) * (180.0 / Math.pi)}");
      ellipsePoints.add(point);
    }
    String kml = '''
      <Placemark>
      <styleUrl>#ps</styleUrl>
        <Polygon>
        <extrude>2</extrude>
        <altitudeMode>relativeToGround</altitudeMode>
          <outerBoundaryIs>
            <LinearRing>
              <coordinates>
  ''';

    for (LatLng point in ellipsePoints) {
      kml += '${point.longitude},${point.latitude},100 ';
    }

    kml += '''
              </coordinates>
            </LinearRing>
          </outerBoundaryIs>
        </Polygon>
      </Placemark>
  ''';

    return kml;
  }
}
