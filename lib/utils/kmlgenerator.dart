import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/data_class/kml_element.dart';

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
  <coordinates>${placeMark.coordinate.latitude},${placeMark.coordinate.longitude}</coordinates>
  </Point>
  </Placemark>''';


  static getCoordinateList(List<Coordinates> list)
  {
    var coordinates = '';
    for(final coordinate in list)
      {
        coordinates += '${coordinate.latitude},${coordinate.longitude},0 ';
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
  <altitudeMode>absolute</altitudeMode>
  ${getCoordinateList(placeMark.coordinates)}
  </LineString>
  </Placemark>''';

  static getLinearRing(Polygon placeMark) => '''<Placemark>
  <name>${placeMark.label}</name>
  <description>
  ${placeMark.description}
  </description>
  <styleUrl>#polyStyle</styleUrl>
  <Polygon>
  <extrude>1</extrude>
  <altitudeMode>relativeToGround</altitudeMode>
  <outerBoundaryIs>
  <LinearRing>
  ${getCoordinateList(placeMark.coordinates)}
  </LinearRing>
  </outerBoundaryIs>
  </Polygon>
  </Placemark>''';

  static String generateKml(String id, List<KmlElement> list) {
    var visList = '';
    for (final item in list) {
      switch (item.index) {
        case 0:
          {
           Placemark element = item.elementData;
           visList+=getPlacemark(element);
          }
        case 1:
          {
            LineString element = item.elementData;
            visList+=getLineString(element);
          }
        case 2:
          {
            Polygon element = item.elementData;
            visList+=getLinearRing(element);
          }
        default:
          {
            Placemark element = item.elementData;
            visList+=getPlacemark(element);
          }
      }
    }

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
}
