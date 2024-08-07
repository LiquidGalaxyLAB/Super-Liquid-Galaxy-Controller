import 'package:hive/hive.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_info.dart';

part 'hive_info.g.dart';

@HiveType(typeId: 12)
class HiveInfo extends HiveObject {
  @HiveField(0)
  double lat;

  @HiveField(1)
  double long;

  @HiveField(2)
  String label;

  @HiveField(3)
  String address;

  @HiveField(4)
  String category;

  @HiveField(5)
  String name;

  @HiveField(6)
  String? state;

  @HiveField(7)
  String? country;

  @HiveField(8)
  String? imageLink;

  @HiveField(9)
  String? description;

  @HiveField(10)
  List<HiveInfo>? nearbyPlaces;

  @HiveField(11)
  String? wikiMediaTag;

  @HiveField(12)
  String? wikipediaLang;

  @HiveField(13)
  String? wikipediaTitle;

  HiveInfo({
    required this.lat,
    required this.long,
    required this.label,
    required this.address,
    required this.category,
    required this.name,
    this.description,
    this.imageLink,
    this.state,
    this.country,
    this.nearbyPlaces,
  });

  HiveInfo.fromPlaceInfo(PlaceInfo place)
      : lat = place.coordinate.latitude,
        long = place.coordinate.longitude,
        label = place.label,
        address = place.address,
        category = place.category,
        name = place.name,
        description = place.description,
        imageLink = place.imageLink,
        state = place.state,
        country = place.country,
        nearbyPlaces = place.nearbyPlaces?.map((p) => HiveInfo.fromPlaceInfo(p)).toList() ?? [];

  PlaceInfo toPlaceInfo()
  {
    return PlaceInfo(coordinate: Coordinates(latitude: lat, longitude: long), label: label, address: address, category: category, name: name, description: description, imageLink: imageLink, state: state, country: country, nearbyPlaces: nearbyPlaces?.map((p)=> p.toPlaceInfo()).toList());
  }



  @override
  String toString() {
    return 'coordinate: $lat, $long , label: $label, name: $name, desc: $address';
  }
}
