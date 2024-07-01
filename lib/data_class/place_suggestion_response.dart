
class PlaceSuggestionResponse {
  String? type;
  List<Features>? features;
  Query? query;

  PlaceSuggestionResponse({this.type, this.features, this.query});

  PlaceSuggestionResponse.fromJson(Map<String, dynamic> json) {
    this.type = json["type"];
    this.features = json["features"]==null ? null : (json["features"] as List).map((e)=>Features.fromJson(e)).toList();
    this.query = json["query"] == null ? null : Query.fromJson(json["query"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["type"] = this.type;
    if(this.features != null) {
      data["features"] = this.features?.map((e)=>e.toJson()).toList();
    }
    if(this.query != null) {
      data["query"] = this.query?.toJson();
    }
    return data;
  }
}

class Query {
  String? text;
  Parsed? parsed;

  Query({this.text, this.parsed});

  Query.fromJson(Map<String, dynamic> json) {
    this.text = json["text"];
    this.parsed = json["parsed"] == null ? null : Parsed.fromJson(json["parsed"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["text"] = this.text;
    if(this.parsed != null)
      data["parsed"] = this.parsed?.toJson();
    return data;
  }
}

class Parsed {
  String? city;
  String? expectedType;

  Parsed({this.city, this.expectedType});

  Parsed.fromJson(Map<String, dynamic> json) {
    this.city = json["city"];
    this.expectedType = json["expected_type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["city"] = this.city;
    data["expected_type"] = this.expectedType;
    return data;
  }
}

class Features {
  String? type;
  Properties? properties;
  Geometry? geometry;
  List<double>? bbox;

  Features({this.type, this.properties, this.geometry, this.bbox});

  Features.fromJson(Map<String, dynamic> json) {
    this.type = json["type"];
    this.properties = json["properties"] == null ? null : Properties.fromJson(json["properties"]);
    this.geometry = json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]);
    this.bbox = json["bbox"]==null ? null : List<double>.from(json["bbox"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["type"] = this.type;
    if(this.properties != null) {
      data["properties"] = this.properties?.toJson();
    }
    if(this.geometry != null) {
      data["geometry"] = this.geometry?.toJson();
    }
    if(this.bbox != null) {
      data["bbox"] = this.bbox;
    }
    return data;
  }

  @override
  String toString() {
    return "${properties?.name} - ${properties?.city}";
  }
}

class Geometry {
  String? type;
  List<double>? coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    this.type = json["type"];
    this.coordinates = json["coordinates"]==null ? null : List<double>.from(json["coordinates"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["type"] = this.type;
    if(this.coordinates != null) {
      data["coordinates"] = this.coordinates;
    }
    return data;
  }
}

class Properties {
  Datasource? datasource;
  String? name;
  String? country;
  String? countryCode;
  String? region;
  String? state;
  String? city;
  double? lon;
  double? lat;
  String? resultType;
  String? formatted;
  String? addressLine1;
  String? addressLine2;
  String? category;
  Timezone? timezone;
  String? plusCode;
  String? plusCodeShort;
  Rank? rank;
  String? placeId;

  Properties({this.datasource, this.name, this.country, this.countryCode, this.region, this.state, this.city, this.lon, this.lat, this.resultType, this.formatted, this.addressLine1, this.addressLine2, this.category, this.timezone, this.plusCode, this.plusCodeShort, this.rank, this.placeId});

  Properties.fromJson(Map<String, dynamic> json) {
    this.datasource = json["datasource"] == null ? null : Datasource.fromJson(json["datasource"]);
    this.name = json["name"];
    this.country = json["country"];
    this.countryCode = json["country_code"];
    this.region = json["region"];
    this.state = json["state"];
    this.city = json["city"];
    this.lon = json["lon"];
    this.lat = json["lat"];
    this.resultType = json["result_type"];
    this.formatted = json["formatted"];
    this.addressLine1 = json["address_line1"];
    this.addressLine2 = json["address_line2"];
    this.category = json["category"];
    this.timezone = json["timezone"] == null ? null : Timezone.fromJson(json["timezone"]);
    this.plusCode = json["plus_code"];
    this.plusCodeShort = json["plus_code_short"];
    this.rank = json["rank"] == null ? null : Rank.fromJson(json["rank"]);
    this.placeId = json["place_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.datasource != null) {
      data["datasource"] = this.datasource?.toJson();
    }
    data["name"] = this.name;
    data["country"] = this.country;
    data["country_code"] = this.countryCode;
    data["region"] = this.region;
    data["state"] = this.state;
    data["city"] = this.city;
    data["lon"] = this.lon;
    data["lat"] = this.lat;
    data["result_type"] = this.resultType;
    data["formatted"] = this.formatted;
    data["address_line1"] = this.addressLine1;
    data["address_line2"] = this.addressLine2;
    data["category"] = this.category;
    if(this.timezone != null) {
      data["timezone"] = this.timezone?.toJson();
    }
    data["plus_code"] = this.plusCode;
    data["plus_code_short"] = this.plusCodeShort;
    if(this.rank != null) {
      data["rank"] = this.rank?.toJson();
    }
    data["place_id"] = this.placeId;
    return data;
  }
}

class Rank {
  double? importance;
  int? confidence;
  int? confidenceCityLevel;
  String? matchType;

  Rank({this.importance, this.confidence, this.confidenceCityLevel, this.matchType});

  Rank.fromJson(Map<String, dynamic> json) {
    this.importance = json["importance"];
    this.confidence = (json["confidence"])?.toInt();
    this.confidenceCityLevel = json["confidence_city_level"]?.toInt();
    this.matchType = json["match_type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["importance"] = this.importance;
    data["confidence"] = this.confidence;
    data["confidence_city_level"] = this.confidenceCityLevel;
    data["match_type"] = this.matchType;
    return data;
  }
}

class Timezone {
  String? name;
  String? offsetStd;
  int? offsetStdSeconds;
  String? offsetDst;
  int? offsetDstSeconds;
  String? abbreviationStd;
  String? abbreviationDst;

  Timezone({this.name, this.offsetStd, this.offsetStdSeconds, this.offsetDst, this.offsetDstSeconds, this.abbreviationStd, this.abbreviationDst});

  Timezone.fromJson(Map<String, dynamic> json) {
    this.name = json["name"];
    this.offsetStd = json["offset_STD"];
    this.offsetStdSeconds = json["offset_STD_seconds"];
    this.offsetDst = json["offset_DST"];
    this.offsetDstSeconds = json["offset_DST_seconds"];
    this.abbreviationStd = json["abbreviation_STD"];
    this.abbreviationDst = json["abbreviation_DST"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name"] = this.name;
    data["offset_STD"] = this.offsetStd;
    data["offset_STD_seconds"] = this.offsetStdSeconds;
    data["offset_DST"] = this.offsetDst;
    data["offset_DST_seconds"] = this.offsetDstSeconds;
    data["abbreviation_STD"] = this.abbreviationStd;
    data["abbreviation_DST"] = this.abbreviationDst;
    return data;
  }
}

class Datasource {
  String? sourcename;
  String? attribution;
  String? license;
  String? url;

  Datasource({this.sourcename, this.attribution, this.license, this.url});

  Datasource.fromJson(Map<String, dynamic> json) {
    this.sourcename = json["sourcename"];
    this.attribution = json["attribution"];
    this.license = json["license"];
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
}