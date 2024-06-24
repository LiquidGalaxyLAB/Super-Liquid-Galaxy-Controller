import 'coordinate.dart';

class Placemark {
  Coordinates coordinate;
  String label;
  String description;

  Placemark({
    required this.coordinate,
    required this.label,
    required this.description,
  });
  @override
  String toString() {
    return 'coordinate: ${coordinate} , name: $label, desc : $description ';
  }
}

class LineString {
  String label;
  String description;
  List<Coordinates> coordinates;

  LineString({
    required this.label,
    required this.description,
    required this.coordinates,
  });
  @override
  String toString() {
    return 'coordinates: ${coordinates} , name: $label, desc : $description ';
  }

}

class Polygon {
  String label;
  String description;
  List<Coordinates> coordinates;
  String color;

  Polygon({
    required this.label,
    required this.description,
    required this.coordinates,
    required this.color,
  });
  @override
  String toString() {
    return 'coordinate: ${coordinates} , name: $label, desc : $description ';
  }
}

class KmlElement {
  int index;
  dynamic elementData;

  KmlElement(
      {required this.index, this.elementData});

  @override
  String toString() {
    return 'index: $index , placemark: ${elementData.toString()}';
  }
}
