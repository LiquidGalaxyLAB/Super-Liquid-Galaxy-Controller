import 'dart:math' as Math;
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart' as mp;
import 'package:latlong2/latlong.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/data_class/kml_element.dart';
import 'package:super_liquid_galaxy_controller/data_class/map_position.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_details_response.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_info.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_response.dart' as pr;
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

  static String testLookAtKML(String id, List<KmlElement> list, MapPosition position) {
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
    visList += position.toLookAt(int.parse("3")).generateLinearString();
    print(position.toLookAt(int.parse("3")).generateLinearString());
    // var lookAt = '';
    // lookAt += GeoUtils.calculateLookAt(coordsList, 45);

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

    // var lookAt = '';
    // lookAt += GeoUtils.calculateLookAt(coordsList, 45);

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
    <Style id="main">
    <IconStyle>
             <color>ff00ff00</color>
                         <Icon>
                <href>http://maps.google.com/mapfiles/kml/pal3/icon21.png</href>
             </Icon>
          </IconStyle>
</Style>
  ${visList}
  </Document>
</kml>
    ''';
  }

  static String getTourPOIKML(PlaceInfo mainPoi)
  {
    String kml = '';
    kml += '''<Placemark>
  <styleUrl>#main</styleUrl>
  <name>${mainPoi.name}</name>
  <description>
  ${mainPoi.description?.substring(0,Math.min(mainPoi.description!.length-1, 150))}
  </description>
  <Point>
  <coordinates>${mainPoi.coordinate.longitude},${mainPoi.coordinate.latitude}</coordinates>
  </Point>
  </Placemark>''';
    return kml;
  }

  static String getPOIKML(PlaceInfo mainPoi, List<PlaceInfo> nearbyPois)
  {
    String kml = '';
    kml += '''<Placemark>
  <styleUrl>#main</styleUrl>
  <name>${mainPoi.name}</name>
  <description>
  ${mainPoi.description?.substring(0,150)}
  </description>
  <Point>
  <coordinates>${mainPoi.coordinate.longitude},${mainPoi.coordinate.latitude}</coordinates>
  </Point>
  </Placemark>''';

    for(final poi in nearbyPois)
      {
        if(poi.coordinate == mainPoi.coordinate) {
          continue;
        }
        kml+='''<Placemark>
  <styleUrl>#nearby</styleUrl>
  <name>${poi.name}</name>
  <description>
  ADDRESS: ${poi.address} \nLOCATION- Lat: ${poi.coordinate.latitude.toStringAsFixed(5)}, Long: ${poi.coordinate.longitude.toStringAsFixed(5)}
   </description>
  <Point>
  <coordinates>${poi.coordinate.longitude},${poi.coordinate.latitude}</coordinates>
  </Point>
  </Placemark>''';
      }

    return kml;
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
    <Style id="boundStyle">
      <LineStyle>
        <width>3</width>
        <color>ffffffff</color>
      </LineStyle>
      <PolyStyle>
        <color>a1aaff00</color>
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
    <Style id="road">
		<LineStyle>
			<color>ff474747</color>
			<width>20</width>
		</LineStyle>
	</Style>
	<Style id="roaddash">
		<LineStyle>
			<color>ff00ffff</color>
			<width>3</width>
		</LineStyle>
	</Style>
    <Style id="main">
    <IconStyle>
             <color>ff00ff00</color>
             <Icon>
                <href>http://maps.google.com/mapfiles/kml/paddle/ylw-circle.png</href>
             </Icon>
             <scale>2.5</scale>
    </IconStyle>
    </Style>
    <Style id="nearby">
    <IconStyle>
             <color>ff00ff00</color>
             <Icon>
                <href>http://maps.google.com/mapfiles/kml/paddle/wht-blank.png</href>
             </Icon>
             <scale>1.1</scale>
    </IconStyle>
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

      //print(
      //    "$i -($x,$y), ($rotatedX,$rotatedY) - dist: ${Math.sqrt(rotatedX * rotatedX + rotatedY * rotatedY)}");

      LatLng point = distance.offset(
          center,
          Math.sqrt(rotatedX * rotatedX + rotatedY * rotatedY),
          (Math.atan2(rotatedY, rotatedX) * (180 / Math.pi)));
      //print("$center -> $point");

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

  //MAIN FOOTPRINT FUNCTION BELOW

  static String generatefootPrintLine(
      LatLng start, LatLng end, double dashLength, double gapLength) {
    final Distance distance = Distance();
    final double totalDistance = distance(start, end);
    final double segmentLength = dashLength;
    int numSegments = (totalDistance / segmentLength).floor();
    //numSegments = 1;
    List<String> kmlSegments = [];
    //print(distance.bearing(end,start));
    for (int i = 0; i < numSegments; i++) {
      // Calculate the start point of the dash
      var angle = distance.bearing(end,start);
        if(i%2==0) {
          angle+=15;
        } else {
          angle-=15;
        }
      LatLng footBottom = distance.offset(
          start, i * segmentLength, distance.bearing(start, end));
      if(i%2==0) {
        footBottom = distance.offset(
            footBottom, gapLength/2, distance.bearing(start, end)-90);
      } else {
        footBottom = distance.offset(
            footBottom, gapLength/2, distance.bearing(start, end)+90);
      }

        // Calculate the end point of the dash
      LatLng footTop =
          distance.offset(footBottom, dashLength/2, angle);



      //print("Line Segment - Bearing: ${distance.bearing(start, end)}");
      kmlSegments.add(generateFootprintBottomPolygon(footBottom, dashLength/2,
          gapLength, degToRadian(angle)));
      kmlSegments.add(generateFootprintTopPolygon(footTop, dashLength,
          gapLength, degToRadian(angle)));

      i++;
      angle = distance.bearing(end,start);
      if(i%2==0) {
        angle+=15;
      } else {
        angle-=15;
      }
      footBottom = distance.offset(
          start, ((i-1) * segmentLength)+(segmentLength*0.75), distance.bearing(start, end));
      if(i%2==0) {
        footBottom = distance.offset(
            footBottom, gapLength/3, distance.bearing(start, end)-90);
      } else {
        footBottom = distance.offset(
            footBottom, gapLength/3, distance.bearing(start, end)+90);
      }

      // Calculate the end point of the dash
      footTop =
      distance.offset(footBottom, dashLength/2, angle);



      //print("Line Segment - Bearing: ${distance.bearing(start, end)}");
      kmlSegments.add(generateFootprintBottomPolygon(footBottom, dashLength/2,
          gapLength, degToRadian(angle)));
      kmlSegments.add(generateFootprintTopPolygon(footTop, dashLength,
          gapLength, degToRadian(angle)));
    }

    String kml = '';
    kml += kmlSegments.join();
    //kml += '</Folder>';

    return kml;
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

    return kml;
  }

  static String generateRoadTrack(LatLng start, LatLng end, double dashLength, double gapLength)
  {
    String kml = '';
    final Distance distance = Distance(calculator: Haversine());
    final double totalDistance = distance(start, end);
    final double segmentLength = dashLength + gapLength;
    final int numSegments = (totalDistance / segmentLength).floor();
    kml+= '''
    <Placemark>
    <styleUrl>#road</styleUrl>
      <LineString>
      <tessellate>1</tessellate>
        <coordinates>
          ${start.longitude},${start.latitude},100
          ${end.longitude},${end.latitude},100
        </coordinates>
      </LineString>
    </Placemark>
    ''';

    for (int i = 0; i < numSegments; i++) {
      LatLng dashStart = distance.offset(
          start, i * segmentLength, distance.bearing(start, end));
      LatLng dashEnd =
      distance.offset(dashStart, dashLength, distance.bearing(start, end));

      kml+= '''
    <Placemark>
    <styleUrl>#roaddash</styleUrl>
      <LineString>
      <tessellate>1</tessellate>
        <coordinates>
          ${dashStart.longitude},${dashStart.latitude},100
          ${dashEnd.longitude},${dashEnd.latitude},100
        </coordinates>
      </LineString>
    </Placemark>
    ''';
    }

    return kml;

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

    return kml;
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

  static String generateBoundaries(Geometry geometry) {
    String kml ='';

    if (geometry.type?.toLowerCase().compareTo("polygon") == 0)
      {
        kml+=drawPolygons(geometry);
      }
    else
    if (geometry.type?.toLowerCase().compareTo("multipolygon") == 0)
    {
      kml+=drawMultiPolygons(geometry);
    }


    return kml;
  }

  static String drawPolygons(Geometry geometry) {
    String polygons = '';
    var masterList = geometry.polygonList!;
    List<Coordinates> coords = [];
    for(List<Coordinates> shape in masterList)
      {
        coords.addAll(shape);
        polygons+=getLinearRing(PolyGon(label: "label", description: "description", coordinates: shape, color: ''));
      }
    // polygons+= drawBoundingBoxes(GeoUtils.splitLatLngBounds(GeoUtils.getBoundingBox(coords), 300000));
    return polygons;
  }

  static String drawMultiPolygons(Geometry geometry) {
    String multipolygons = '';
    var masterList = geometry.multiPolygonList!;
    List<Coordinates> coords = [];
    for(List<List<Coordinates>> shape in masterList)
    {
      coords.addAll(shape[0]);
      multipolygons+=getLinearRing(PolyGon(label: "label", description: "description", coordinates: shape[0], color: ''));
    }
    // multipolygons+= drawBoundingBoxes(GeoUtils.splitLatLngBounds(GeoUtils.getBoundingBox(coords), 300000));
    return multipolygons;
  }

  static List<Coordinates> getAllCoordsList(Geometry geometry) {
    List<Coordinates> coords =[];

    if (geometry.type?.toLowerCase().compareTo("polygon") == 0)
    {
      coords.addAll(getPolygonList(geometry));
    }
    else
    if (geometry.type?.toLowerCase().compareTo("multipolygon") == 0)
    {
      coords.addAll(getMultiPolygonList(geometry));
    }


    return coords;
  }

  static List<Coordinates> getPolygonList(Geometry geometry) {
    var masterList = geometry.polygonList!;
    List<Coordinates> coords = [];
    for(List<Coordinates> shape in masterList)
    {
      coords.addAll(shape);
      //polygons+=getLinearRing(PolyGon(label: "label", description: "description", coordinates: shape, color: ''));
    }
    // polygons+= drawBoundingBoxes(GeoUtils.splitLatLngBounds(GeoUtils.getBoundingBox(coords), 300000));
    return coords;
  }

  static List<Coordinates> getMultiPolygonList(Geometry geometry) {
    var masterList = geometry.multiPolygonList!;
    List<Coordinates> coords = [];
    for(List<List<Coordinates>> shape in masterList)
    {
      coords.addAll(shape[0]);
      //multipolygons+=getLinearRing(PolyGon(label: "label", description: "description", coordinates: shape[0], color: ''));
    }
    // multipolygons+= drawBoundingBoxes(GeoUtils.splitLatLngBounds(GeoUtils.getBoundingBox(coords), 300000));
    return coords;
  }
  
  static String drawBoundingBoxes(List<mp.LatLngBounds> boundsList)
  {print('Bounds Length: ${boundsList.length}');
    String kml ='';
    for(final bound in boundsList)
      {List<Coordinates> coords=GeoUtils.getLatLngBoundsPolygon(bound);
        coords.add(coords[0]);
        kml+='''<Placemark>
  <styleUrl>#boundStyle</styleUrl>
  <Polygon>
  <extrude>1</extrude>
  <outerBoundaryIs>
  <LinearRing>
  ${getCoordinateList(coords)}
  </LinearRing>
  </outerBoundaryIs>
  </Polygon>
  </Placemark>''';
      }
    return kml;
  }

  static String addPlaces(List<PlaceInfo> points) {
    String kml = '';
    for( final point in points) {
      kml+=getPlacemark(Placemark(coordinate: point.coordinate, label: point.label, description: point.address));
    }
    return kml;

  }

  static String orbitLookAtLinear(MapPosition position) =>
      '<gx:duration>2</gx:duration><gx:flyToMode>smooth</gx:flyToMode><LookAt><longitude>${position.longitude}</longitude><latitude>${position.latitude}</latitude><range>${position.zoom}</range><tilt>${position.tilt}</tilt><heading>${position.bearing}</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';

  static String lookAtLinearInstant(MapPosition position) =>
      '<gx:duration>0.5</gx:duration><gx:flyToMode>smooth</gx:flyToMode><LookAt><longitude>${position.longitude}</longitude><latitude>${position.latitude}</latitude><range>${position.zoom}</range><tilt>${position.tilt}</tilt><heading>${position.bearing}</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';

  static String addTourPaths(PlaceInfo place1, PlaceInfo place2) {
    String kml ='';
    final distance = Distance();
    final length = distance.distance(place1.coordinate.toLatLng(place1.coordinate), place2.coordinate.toLatLng(place2.coordinate));
    print("${place1.name} - ${place2.name} : ${length}");
    if(length < 10000)
    {
      kml += generatefootPrintLine(
          place2.coordinate.toLatLng(place2.coordinate),
          place1.coordinate.toLatLng(place1.coordinate), length/10, length/20);
      return kml;
    }
    if(length > 2000000)
      {
        kml+= generateAirplaneTrack(place1.coordinate.toLatLng(place1.coordinate),
            place2.coordinate.toLatLng(place2.coordinate), 10000, 5000);
        return kml;
      }

    if(place1.state != null && place2.state != null)
      {


        if(place1.state!.compareTo(place2.state!)==0) {
          kml += generatefootPrintLine(
              place2.coordinate.toLatLng(place2.coordinate),
              place1.coordinate.toLatLng(place1.coordinate), 5000, 2500);
          return kml;
        }
      }
    if(place1.country != null && place2.country != null)
      {
        if(place1.country!.compareTo(place2.country!)==0)
          {
            kml += generateRoadTrack(place1.coordinate.toLatLng(place1.coordinate),
                place2.coordinate.toLatLng(place2.coordinate), 10000, 5000);
            return kml;
          }
      }

    kml+= generateAirplaneTrack(place1.coordinate.toLatLng(place1.coordinate),
        place2.coordinate.toLatLng(place2.coordinate), 10000, 5000);
    return kml;
  }

}
