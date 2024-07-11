import 'coordinate.dart';

class PlaceResponse {
  String? type;
  List<Features>? features;

  PlaceResponse({this.type, this.features});

  PlaceResponse.fromJson(Map<String, dynamic> json) {
    if(json["type"] is String)
      this.type = json["type"];
    if(json["features"] is List)
      this.features = json["features"] == null ? null : (json["features"] as List).map((e)=>Features.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["type"] = this.type;
    if(this.features != null)
      data["features"] = this.features?.map((e)=>e.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return 'PlaceResponse{type: $type, features: $features}';
  }
}

class Features {
  String? type;
  Properties? properties;
  Geometry? geometry;

  Features({this.type, this.properties, this.geometry});

  Features.fromJson(Map<String, dynamic> json) {
    if(json["type"] is String)
      this.type = json["type"];
    if(json["properties"] is Map)
      this.properties = json["properties"] == null ? null : Properties.fromJson(json["properties"]);
    if(json["geometry"] is Map)
      this.geometry = json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["type"] = this.type;
    if(this.properties != null)
      data["properties"] = this.properties?.toJson();
    if(this.geometry != null)
      data["geometry"] = this.geometry?.toJson();
    return data;
  }

  @override
  String toString() {
    return 'Features{type: $type, properties: $properties, geometry: $geometry}';
  }
}

class Geometry {
  String? type;
  List<double>? coordinates;
  Coordinates? point;


  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    if(json["type"] is String)
      this.type = json["type"];
    if(json["coordinates"] is List)
      this.coordinates = json["coordinates"] == null ? null : List<double>.from(json["coordinates"]);
    if(coordinates!= null && coordinates!.isNotEmpty)
      {
        point = Coordinates(latitude: double.parse(coordinates![1].toString()) , longitude:double.parse(coordinates![0].toString()) );
      }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["type"] = this.type;
    if(this.coordinates != null)
      data["coordinates"] = this.coordinates;
    return data;
  }

  @override
  String toString() {
    return 'Geometry{type: $type, coordinates: $coordinates}';
  }
}

class Properties {
  String? name;
  String? country;
  String? countryCode;
  String? state;
  String? county;
  String? city;
  double? lon;
  double? lat;
  String? stateCode;
  String? formatted;
  String? addressLine1;
  String? addressLine2;
  List<String>? categories;
  List<String>? details;
  Datasource? datasource;
  String? website;
  String? operator;
  RefOther? refOther;
  Contact? contact;
  WikiAndMedia? wikiAndMedia;
  Historic? historic;
  Heritage? heritage;
  String? placeId;

  Properties({this.name, this.country, this.countryCode, this.state, this.county, this.city, this.lon, this.lat, this.stateCode, this.formatted, this.addressLine1, this.addressLine2, this.categories, this.details, this.datasource, this.website, this.operator, this.refOther, this.contact, this.wikiAndMedia, this.historic, this.heritage, this.placeId});

  Properties.fromJson(Map<String, dynamic> json) {
    if(json["name"] is String)
      this.name = json["name"];
    if(json["country"] is String)
      this.country = json["country"];
    if(json["country_code"] is String)
      this.countryCode = json["country_code"];
    if(json["state"] is String)
      this.state = json["state"];
    if(json["county"] is String)
      this.county = json["county"];
    if(json["city"] is String)
      this.city = json["city"];
    if(json["lon"] is double)
      this.lon = json["lon"];
    if(json["lat"] is double)
      this.lat = json["lat"];
    if(json["state_code"] is String)
      this.stateCode = json["state_code"];
    if(json["formatted"] is String)
      this.formatted = json["formatted"];
    if(json["address_line1"] is String)
      this.addressLine1 = json["address_line1"];
    if(json["address_line2"] is String)
      this.addressLine2 = json["address_line2"];
    if(json["categories"] is List)
      this.categories = json["categories"] == null ? null : List<String>.from(json["categories"]);
    if(json["details"] is List)
      this.details = json["details"] == null ? null : List<String>.from(json["details"]);
    if(json["datasource"] is Map)
      this.datasource = json["datasource"] == null ? null : Datasource.fromJson(json["datasource"]);
    if(json["website"] is String)
      this.website = json["website"];
    if(json["operator"] is String)
      this.operator = json["operator"];
    if(json["ref_other"] is Map)
      this.refOther = json["ref_other"] == null ? null : RefOther.fromJson(json["ref_other"]);
    if(json["contact"] is Map)
      this.contact = json["contact"] == null ? null : Contact.fromJson(json["contact"]);
    if(json["wiki_and_media"] is Map)
      this.wikiAndMedia = json["wiki_and_media"] == null ? null : WikiAndMedia.fromJson(json["wiki_and_media"]);
    if(json["historic"] is Map)
      this.historic = json["historic"] == null ? null : Historic.fromJson(json["historic"]);
    if(json["heritage"] is Map)
      this.heritage = json["heritage"] == null ? null : Heritage.fromJson(json["heritage"]);
    if(json["place_id"] is String)
      this.placeId = json["place_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name"] = this.name;
    data["country"] = this.country;
    data["country_code"] = this.countryCode;
    data["state"] = this.state;
    data["county"] = this.county;
    data["city"] = this.city;
    data["lon"] = this.lon;
    data["lat"] = this.lat;
    data["state_code"] = this.stateCode;
    data["formatted"] = this.formatted;
    data["address_line1"] = this.addressLine1;
    data["address_line2"] = this.addressLine2;
    if(this.categories != null)
      data["categories"] = this.categories;
    if(this.details != null)
      data["details"] = this.details;
    if(this.datasource != null)
      data["datasource"] = this.datasource?.toJson();
    data["website"] = this.website;
    data["operator"] = this.operator;
    if(this.refOther != null)
      data["ref_other"] = this.refOther?.toJson();
    if(this.contact != null)
      data["contact"] = this.contact?.toJson();
    if(this.wikiAndMedia != null)
      data["wiki_and_media"] = this.wikiAndMedia?.toJson();
    if(this.historic != null)
      data["historic"] = this.historic?.toJson();
    if(this.heritage != null)
      data["heritage"] = this.heritage?.toJson();
    data["place_id"] = this.placeId;
    return data;
  }

  @override
  String toString() {
    return 'Properties{name: $name, country: $country, countryCode: $countryCode, state: $state, county: $county, city: $city, lon: $lon, lat: $lat, stateCode: $stateCode, formatted: $formatted, addressLine1: $addressLine1, addressLine2: $addressLine2, categories: $categories, details: $details, datasource: $datasource, website: $website, operator: $operator, refOther: $refOther, contact: $contact, wikiAndMedia: $wikiAndMedia, historic: $historic, heritage: $heritage, placeId: $placeId}';
  }
}

class Heritage {
  int? level;
  String? operator;
  int? ref;

  Heritage({this.level, this.operator, this.ref});

  Heritage.fromJson(Map<String, dynamic> json) {
    if(json["level"] is int)
      this.level = json["level"];
    if(json["operator"] is String)
      this.operator = json["operator"];
    if(json["ref"] is int)
      this.ref = json["ref"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["level"] = this.level;
    data["operator"] = this.operator;
    data["ref"] = this.ref;
    return data;
  }

  @override
  String toString() {
    return 'Heritage{level: $level, operator: $operator, ref: $ref}';
  }
}

class Historic {
  int? wikidata;
  String? operator;
  int? ref;

  Historic({this.wikidata, this.operator, this.ref});

  Historic.fromJson(Map<String, dynamic> json) {
    if(json["wikidata"] is int)
      this.wikidata = json["wikidata"];
    if(json["operator"] is String)
      this.operator = json["operator"];
    if(json["ref"] is int)
      this.ref = json["ref"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["wikidata"] = this.wikidata;
    data["operator"] = this.operator;
    data["ref"] = this.ref;
    return data;
  }

  @override
  String toString() {
    return 'Historic{wikidata: $wikidata, operator: $operator, ref: $ref}';
  }
}

class WikiAndMedia {
  String? image;

  WikiAndMedia({this.image});

  WikiAndMedia.fromJson(Map<String, dynamic> json) {
    if(json["image"] is String)
      this.image = json["image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["image"] = this.image;
    return data;
  }

  @override
  String toString() {
    return 'WikiAndMedia{image: $image}';
  }
}

class Contact {
  String? phone;
  String? website;

  Contact({this.phone, this.website});

  Contact.fromJson(Map<String, dynamic> json) {
    if(json["phone"] is String)
      this.phone = json["phone"];
    if(json["website"] is String)
      this.website = json["website"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["phone"] = this.phone;
    data["website"] = this.website;
    return data;
  }

  @override
  String toString() {
    return 'Contact{phone: $phone, website: $website}';
  }
}

class RefOther {
  String? ref;
  String? operator;

  RefOther({this.ref, this.operator});

  RefOther.fromJson(Map<String, dynamic> json) {
    if(json["ref"] is String)
      this.ref = json["ref"];
    if(json["operator"] is String)
      this.operator = json["operator"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ref"] = this.ref;
    data["operator"] = this.operator;
    return data;
  }

  @override
  String toString() {
    return 'RefOther{ref: $ref, operator: $operator}';
  }
}

class Datasource {
  String? sourcename;
  String? attribution;
  String? license;
  String? url;

  Datasource({this.sourcename, this.attribution, this.license, this.url});

  Datasource.fromJson(Map<String, dynamic> json) {
    if(json["sourcename"] is String)
      this.sourcename = json["sourcename"];
    if(json["attribution"] is String)
      this.attribution = json["attribution"];
    if(json["license"] is String)
      this.license = json["license"];
    if(json["url"] is String)
      this.url = json["url"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["sourcename"] = this.sourcename;
    data["attribution"] = this.attribution;
    data["license"] = this.license;
    data["url"] = this.url;
    return data;
  }

  @override
  String toString() {
    return 'Datasource{sourcename: $sourcename, attribution: $attribution, license: $license, url: $url}';
  }
}
