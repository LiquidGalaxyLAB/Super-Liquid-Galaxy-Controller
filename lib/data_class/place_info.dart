import 'coordinate.dart';

class PlaceInfo {
  Coordinates coordinate;
  String label;
  String address;
  String category;
  String name;

  String? wikiMediaTag;
  String? wikipediaLang;
  String? wikipediaTitle;

  PlaceInfo({
    required this.coordinate,
    required this.label,
    required this.address,
    required this.category,
    required this.name
  });
  @override
  String toString() {
    return 'coordinate: ${coordinate} , name: $label, name: $name, desc : $address ';
  }
}