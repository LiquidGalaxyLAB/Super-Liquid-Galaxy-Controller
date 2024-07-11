import 'coordinate.dart';

class PlaceDetailsResponse {
  String? type;
  List<Features>? features;

  PlaceDetailsResponse({this.type, this.features});

  PlaceDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json["type"] is String) this.type = json["type"];
    if (json["features"] is List)
      this.features = json["features"] == null
          ? null
          : (json["features"] as List)
              .map((e) => Features.fromJson(e))
              .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["type"] = this.type;
    if (this.features != null)
      data["features"] = this.features?.map((e) => e.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return 'PlaceDetailsResponse{type: $type, features: $features}';
  }
}

class Features {
  String? type;
  Properties? properties;
  Geometry? geometry;

  Features({this.type, this.properties, this.geometry});

  Features.fromJson(Map<String, dynamic> json) {
    if (json["type"] is String) this.type = json["type"];
    if (json["properties"] is Map)
      this.properties = json["properties"] == null
          ? null
          : Properties.fromJson(json["properties"]);
    if (json["geometry"] is Map)
      this.geometry =
          json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["type"] = this.type;
    if (this.properties != null) data["properties"] = this.properties?.toJson();
    if (this.geometry != null) data["geometry"] = this.geometry?.toJson();
    return data;
  }

  @override
  String toString() {
    return 'Features{type: $type, properties: $properties, geometry: $geometry}';
  }
}

class Geometry {
  String? type;
  List<dynamic>? coordinates;
  List<List<Coordinates>>? polygonList;
  List<List<List<Coordinates>>>? multiPolygonList;
  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    if (json["type"] is String) this.type = json["type"];
    print(type);
    if (json["coordinates"] is List) {
      this.coordinates = json["coordinates"] == null
          ? null
          : List<dynamic>.from(json["coordinates"]);

      if (coordinates != null && coordinates!.isNotEmpty) {


        if (type?.compareTo("Polygon")==0) {
          polygonList = [];
          for (List<dynamic> polygon in coordinates!) {
            List<Coordinates> coordinateList = [];
            for (List<dynamic> item in polygon) {
              //print(item);
              coordinateList
                  .add(Coordinates(latitude: double.parse(item[1].toString()),
                  longitude: double.parse(item[0].toString())));
            }
            polygonList?.add(coordinateList);
          }
        }
        else
          {
            if(type?.compareTo("MultiPolygon")==0)
              {
                multiPolygonList =[];
                for(List<dynamic> multipolygon in coordinates!) {
                  List<List<Coordinates>> list = [];
                  for (List<dynamic> polygon in multipolygon) {
                    List<Coordinates> coordinateList = [];
                    for (List<dynamic> item in polygon) {
                      //print(item);
                      coordinateList
                          .add(Coordinates(
                          latitude: double.parse(item[1].toString()),
                          longitude: double.parse(item[0].toString())));
                    }
                    list.add(coordinateList);
                  }
                  multiPolygonList?.add(list);
                }
              }
          }
      }
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["type"] = this.type;
    if (this.coordinates != null) data["coordinates"] = this.coordinates;
    return data;
  }

  @override
  String toString() {
    return 'Geometry{type: $type, coordinates: $coordinates}';
  }
}

class Properties {
  String? featureType;
  List<String>? categories;
  Datasource? datasource;
  String? state;
  String? country;
  String? countryCode;
  String? formatted;
  String? addressLine1;
  String? addressLine2;
  double? lat;
  double? lon;
  String? name;
  Timezone? timezone;
  String? placeId;

  Properties(
      {this.featureType,
      this.categories,
      this.datasource,
      this.state,
      this.country,
      this.countryCode,
      this.formatted,
      this.addressLine1,
      this.addressLine2,
      this.lat,
      this.lon,
      this.name,
      this.timezone,
      this.placeId});

  Properties.fromJson(Map<String, dynamic> json) {
    if (json["feature_type"] is String) this.featureType = json["feature_type"];
    if (json["categories"] is List)
      this.categories = json["categories"] == null
          ? null
          : List<String>.from(json["categories"]);
    if (json["datasource"] is Map)
      this.datasource = json["datasource"] == null
          ? null
          : Datasource.fromJson(json["datasource"]);
    if (json["state"] is String) this.state = json["state"];
    if (json["country"] is String) this.country = json["country"];
    if (json["country_code"] is String) this.countryCode = json["country_code"];
    if (json["formatted"] is String) this.formatted = json["formatted"];
    if (json["address_line1"] is String)
      this.addressLine1 = json["address_line1"];
    if (json["address_line2"] is String)
      this.addressLine2 = json["address_line2"];
    if (json["lat"] is double) this.lat = json["lat"];
    if (json["lon"] is double) this.lon = json["lon"];
    if (json["name"] is String) this.name = json["name"];
    if (json["timezone"] is Map)
      this.timezone =
          json["timezone"] == null ? null : Timezone.fromJson(json["timezone"]);
    if (json["place_id"] is String) this.placeId = json["place_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["feature_type"] = this.featureType;
    if (this.categories != null) data["categories"] = this.categories;
    if (this.datasource != null) data["datasource"] = this.datasource?.toJson();
    data["state"] = this.state;
    data["country"] = this.country;
    data["country_code"] = this.countryCode;
    data["formatted"] = this.formatted;
    data["address_line1"] = this.addressLine1;
    data["address_line2"] = this.addressLine2;
    data["lat"] = this.lat;
    data["lon"] = this.lon;
    data["name"] = this.name;
    if (this.timezone != null) data["timezone"] = this.timezone?.toJson();
    data["place_id"] = this.placeId;
    return data;
  }

  @override
  String toString() {
    return 'Properties{featureType: $featureType, categories: $categories, datasource: $datasource, state: $state, country: $country, countryCode: $countryCode, formatted: $formatted, addressLine1: $addressLine1, addressLine2: $addressLine2, lat: $lat, lon: $lon, name: $name, timezone: $timezone, placeId: $placeId}';
  }
}

class Timezone {
  String? name;
  String? offsetStd;
  int? offsetStdSeconds;
  String? offsetDst;
  int? offsetDstSeconds;

  Timezone(
      {this.name,
      this.offsetStd,
      this.offsetStdSeconds,
      this.offsetDst,
      this.offsetDstSeconds});

  Timezone.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) this.name = json["name"];
    if (json["offset_STD"] is String) this.offsetStd = json["offset_STD"];
    if (json["offset_STD_seconds"] is int)
      this.offsetStdSeconds = json["offset_STD_seconds"];
    if (json["offset_DST"] is String) this.offsetDst = json["offset_DST"];
    if (json["offset_DST_seconds"] is int)
      this.offsetDstSeconds = json["offset_DST_seconds"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name"] = this.name;
    data["offset_STD"] = this.offsetStd;
    data["offset_STD_seconds"] = this.offsetStdSeconds;
    data["offset_DST"] = this.offsetDst;
    data["offset_DST_seconds"] = this.offsetDstSeconds;
    return data;
  }

  @override
  String toString() {
    return 'Timezone{name: $name, offsetStd: $offsetStd, offsetStdSeconds: $offsetStdSeconds, offsetDst: $offsetDst, offsetDstSeconds: $offsetDstSeconds}';
  }
}

class Datasource {
  String? sourcename;
  String? attribution;
  String? license;
  String? url;
  Raw? raw;

  Datasource(
      {this.sourcename, this.attribution, this.license, this.url, this.raw});

  Datasource.fromJson(Map<String, dynamic> json) {
    if (json["sourcename"] is String) this.sourcename = json["sourcename"];
    if (json["attribution"] is String) this.attribution = json["attribution"];
    if (json["license"] is String) this.license = json["license"];
    if (json["url"] is String) this.url = json["url"];
    if (json["raw"] is Map)
      this.raw = json["raw"] == null ? null : Raw.fromJson(json["raw"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["sourcename"] = this.sourcename;
    data["attribution"] = this.attribution;
    data["license"] = this.license;
    data["url"] = this.url;
    if (this.raw != null) data["raw"] = this.raw?.toJson();
    return data;
  }

  @override
  String toString() {
    return 'Datasource{sourcename: $sourcename, attribution: $attribution, license: $license, url: $url, raw: $raw}';
  }
}

class Raw {
  String? ref;
  String? name;
  String? type;
  int? osmId;
  String? nameel;
  String? namees;
  String? namehe;
  String? nameja;
  String? nameru;
  String? nameuk;
  String? namezh;
  String? boundary;
  String? osmType;
  String? timezone;
  String? wikidata;
  String? iso31662;
  String? wikipedia;
  String? placeRef;
  String? shortName;
  int? adminLevel;
  String? countryCode;
  String? linkedPlace;
  String? isIncountry;
  String? officialName;
  String? placeNameeo;
  String? placeNameabbreviation;

  Raw(
      {this.ref,
      this.name,
      this.type,
      this.osmId,
      this.nameel,
      this.namees,
      this.namehe,
      this.nameja,
      this.nameru,
      this.nameuk,
      this.namezh,
      this.boundary,
      this.osmType,
      this.timezone,
      this.wikidata,
      this.iso31662,
      this.wikipedia,
      this.placeRef,
      this.shortName,
      this.adminLevel,
      this.countryCode,
      this.linkedPlace,
      this.isIncountry,
      this.officialName,
      this.placeNameeo,
      this.placeNameabbreviation});

  Raw.fromJson(Map<String, dynamic> json) {
    if (json["ref"] is String) this.ref = json["ref"];
    if (json["name"] is String) this.name = json["name"];
    if (json["type"] is String) this.type = json["type"];
    if (json["osm_id"] is int) this.osmId = json["osm_id"];
    if (json["name:el"] is String) this.nameel = json["name:el"];
    if (json["name:es"] is String) this.namees = json["name:es"];
    if (json["name:he"] is String) this.namehe = json["name:he"];
    if (json["name:ja"] is String) this.nameja = json["name:ja"];
    if (json["name:ru"] is String) this.nameru = json["name:ru"];
    if (json["name:uk"] is String) this.nameuk = json["name:uk"];
    if (json["name:zh"] is String) this.namezh = json["name:zh"];
    if (json["boundary"] is String) this.boundary = json["boundary"];
    if (json["osm_type"] is String) this.osmType = json["osm_type"];
    if (json["timezone"] is String) this.timezone = json["timezone"];
    if (json["wikidata"] is String) this.wikidata = json["wikidata"];
    if (json["ISO3166-2"] is String) this.iso31662 = json["ISO3166-2"];
    if (json["wikipedia"] is String) this.wikipedia = json["wikipedia"];
    if (json["_place_ref"] is String) this.placeRef = json["_place_ref"];
    if (json["short_name"] is String) this.shortName = json["short_name"];
    if (json["admin_level"] is int) this.adminLevel = json["admin_level"];
    if (json["country_code"] is String) this.countryCode = json["country_code"];
    if (json["linked_place"] is String) this.linkedPlace = json["linked_place"];
    if (json["is_in:country"] is String)
      this.isIncountry = json["is_in:country"];
    if (json["official_name"] is String)
      this.officialName = json["official_name"];
    if (json["_place_name:eo"] is String)
      this.placeNameeo = json["_place_name:eo"];
    if (json["_place_name:abbreviation"] is String)
      this.placeNameabbreviation = json["_place_name:abbreviation"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ref"] = this.ref;
    data["name"] = this.name;
    data["type"] = this.type;
    data["osm_id"] = this.osmId;
    data["name:el"] = this.nameel;
    data["name:es"] = this.namees;
    data["name:he"] = this.namehe;
    data["name:ja"] = this.nameja;
    data["name:ru"] = this.nameru;
    data["name:uk"] = this.nameuk;
    data["name:zh"] = this.namezh;
    data["boundary"] = this.boundary;
    data["osm_type"] = this.osmType;
    data["timezone"] = this.timezone;
    data["wikidata"] = this.wikidata;
    data["ISO3166-2"] = this.iso31662;
    data["wikipedia"] = this.wikipedia;
    data["_place_ref"] = this.placeRef;
    data["short_name"] = this.shortName;
    data["admin_level"] = this.adminLevel;
    data["country_code"] = this.countryCode;
    data["linked_place"] = this.linkedPlace;
    data["is_in:country"] = this.isIncountry;
    data["official_name"] = this.officialName;
    data["_place_name:eo"] = this.placeNameeo;
    data["_place_name:abbreviation"] = this.placeNameabbreviation;
    return data;
  }

  @override
  String toString() {
    return 'Raw{ref: $ref, name: $name, type: $type, osmId: $osmId, nameel: $nameel, namees: $namees, namehe: $namehe, nameja: $nameja, nameru: $nameru, nameuk: $nameuk, namezh: $namezh, boundary: $boundary, osmType: $osmType, timezone: $timezone, wikidata: $wikidata, iso31662: $iso31662, wikipedia: $wikipedia, placeRef: $placeRef, shortName: $shortName, adminLevel: $adminLevel, countryCode: $countryCode, linkedPlace: $linkedPlace, isIncountry: $isIncountry, officialName: $officialName, placeNameeo: $placeNameeo, placeNameabbreviation: $placeNameabbreviation}';
  }
}
