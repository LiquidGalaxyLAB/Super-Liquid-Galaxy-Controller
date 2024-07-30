import 'dart:math';

import '../utils/constants.dart';
import 'coordinate.dart';

class PlaceInfo {
  Coordinates coordinate;
  String label;
  String address;
  String category;
  String name;

  String? state;
  String? country;
  String? imageLink;
  String? description;

  List<PlaceInfo>? nearbyPlaces;

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
    this.imageLink,
    this.state,
    this.country,
    this.nearbyPlaces
  });
  @override
  String toString() {
    return 'coordinate: ${coordinate} , name: $label, name: $name, desc : $address ';
  }

  Iterable<PlaceInfo> getPois() {
    if(nearbyPlaces == null)
      {
        return [];
      }
    else
      {
        return nearbyPlaces!;
      }
  }

  String getAddress() {
    return address;
  }

  String getTitle() {
    return name;
  }
  String getImageLink()
  {
    if(imageLink == null || imageLink == "")
      {
        return Constants.tourismCategories.contains(category)?(Constants.driveLinks[Constants.tourismCategories.indexOf(category)]):Constants.driveLinks[Constants.assetPaths.length-1];
        //return "https://drive.google.com/file/d/1CnSI-YpMgT8G746csKExfvXlVbnDfJYs/view?usp=drive_link";
      }
    else {
      return imageLink!;
    }
  }
  String getDescription()
  {
    if(description == null)
      {
        return "No location description could be found";
      }
    else
      {
        return "${description!.substring(0,min(1000,description!.length-1))}...";
      }
  }
}