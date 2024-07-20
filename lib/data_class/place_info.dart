import 'coordinate.dart';

class PlaceInfo {
  Coordinates coordinate;
  String label;
  String address;
  String category;
  String name;

  String? imageLink;
  String? description;
  String? wikiMediaTag;
  String? wikipediaLang;
  String? wikipediaTitle;

  PlaceInfo({
    required this.coordinate,
    required this.label,
    required this.address,
    required this.category,
    required this.name,
    this.description,
    this.imageLink
  });
  @override
  String toString() {
    return 'coordinate: ${coordinate} , name: $label, name: $name, desc : $address ';
  }
}