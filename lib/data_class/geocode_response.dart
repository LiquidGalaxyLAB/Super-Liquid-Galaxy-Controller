class GeoCodeResponse {
  List<Results>? results;
  Query? query;

  GeoCodeResponse({this.results, this.query});

  GeoCodeResponse.fromJson(Map<String, dynamic> json) {
    this.results = json["results"] == null ? null : (json["results"] as List).map((e) => Results.fromJson(e)).toList();
    this.query = json["query"] == null ? null : Query.fromJson(json["query"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null)
      data["results"] = this.results?.map((e) => e.toJson()).toList();
    if (this.query != null)
      data["query"] = this.query?.toJson();
    return data;
  }

  @override
  String toString() {
    return 'GeoCodeResponse{results: $results, query: $query}';
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
    if (this.parsed != null)
      data["parsed"] = this.parsed?.toJson();
    return data;
  }

  @override
  String toString() {
    return 'Query{text: $text, parsed: $parsed}';
  }
}

class Parsed {
  String? state;
  String? country;
  String? expectedType;

  Parsed({this.state, this.country, this.expectedType});

  Parsed.fromJson(Map<String, dynamic> json) {
    this.state = json["state"];
    this.country = json["country"];
    this.expectedType = json["expected_type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["state"] = this.state;
    data["country"] = this.country;
    data["expected_type"] = this.expectedType;
    return data;
  }

  @override
  String toString() {
    return 'Parsed{state: $state, country: $country, expectedType: $expectedType}';
  }
}

class Results {
  Datasource? datasource;
  String? ref;
  String? country;
  String? countryCode;
  String? state;
  double? lon;
  double? lat;
  String? stateCode;
  String? resultType;
  String? formatted;
  String? addressLine1;
  String? addressLine2;
  String? category;
  Timezone? timezone;
  String? plusCode;
  Rank? rank;
  String? placeId;
  Bbox? bbox;

  Results(
      {this.datasource,
        this.ref,
        this.country,
        this.countryCode,
        this.state,
        this.lon,
        this.lat,
        this.stateCode,
        this.resultType,
        this.formatted,
        this.addressLine1,
        this.addressLine2,
        this.category,
        this.timezone,
        this.plusCode,
        this.rank,
        this.placeId,
        this.bbox});

  Results.fromJson(Map<String, dynamic> json) {
    this.datasource = json["datasource"] == null ? null : Datasource.fromJson(json["datasource"]);
    this.ref = json["ref"];
    this.country = json["country"];
    this.countryCode = json["country_code"];
    this.state = json["state"];
    this.lon = json["lon"];
    this.lat = json["lat"];
    this.stateCode = json["state_code"];
    this.resultType = json["result_type"];
    this.formatted = json["formatted"];
    this.addressLine1 = json["address_line1"];
    this.addressLine2 = json["address_line2"];
    this.category = json["category"];
    this.timezone = json["timezone"] == null ? null : Timezone.fromJson(json["timezone"]);
    this.plusCode = json["plus_code"];
    this.rank = json["rank"] == null ? null : Rank.fromJson(json["rank"]);
    this.placeId = json["place_id"];
    this.bbox = json["bbox"] == null ? null : Bbox.fromJson(json["bbox"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.datasource != null)
      data["datasource"] = this.datasource?.toJson();
    data["ref"] = this.ref;
    data["country"] = this.country;
    data["country_code"] = this.countryCode;
    data["state"] = this.state;
    data["lon"] = this.lon;
    data["lat"] = this.lat;
    data["state_code"] = this.stateCode;
    data["result_type"] = this.resultType;
    data["formatted"] = this.formatted;
    data["address_line1"] = this.addressLine1;
    data["address_line2"] = this.addressLine2;
    data["category"] = this.category;
    if (this.timezone != null)
      data["timezone"] = this.timezone?.toJson();
    data["plus_code"] = this.plusCode;
    if (this.rank != null)
      data["rank"] = this.rank?.toJson();
    data["place_id"] = this.placeId;
    if (this.bbox != null)
      data["bbox"] = this.bbox?.toJson();
    return data;
  }

  @override
  String toString() {
    return 'Results{datasource: $datasource, ref: $ref, country: $country, countryCode: $countryCode, state: $state, lon: $lon, lat: $lat, stateCode: $stateCode, resultType: $resultType, formatted: $formatted, addressLine1: $addressLine1, addressLine2: $addressLine2, category: $category, timezone: $timezone, plusCode: $plusCode, rank: $rank, placeId: $placeId, bbox: $bbox}';
  }
}

class Bbox {
  double? lon1;
  double? lat1;
  double? lon2;
  double? lat2;

  Bbox({this.lon1, this.lat1, this.lon2, this.lat2});

  Bbox.fromJson(Map<String, dynamic> json) {
    this.lon1 = json["lon1"];
    this.lat1 = json["lat1"];
    this.lon2 = json["lon2"];
    this.lat2 = json["lat2"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["lon1"] = this.lon1;
    data["lat1"] = this.lat1;
    data["lon2"] = this.lon2;
    data["lat2"] = this.lat2;
    return data;
  }

  @override
  String toString() {
    return 'Bbox{lon1: $lon1, lat1: $lat1, lon2: $lon2, lat2: $lat2}';
  }
}

class Rank {
  double? importance;
  double? popularity;
  int? confidence;
  String? matchType;

  Rank({this.importance, this.popularity, this.confidence, this.matchType});

  Rank.fromJson(Map<String, dynamic> json) {
    this.importance = json["importance"];
    this.popularity = json["popularity"];
    this.confidence = json["confidence"];
    this.matchType = json["match_type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["importance"] = this.importance;
    data["popularity"] = this.popularity;
    data["confidence"] = this.confidence;
    data["match_type"] = this.matchType;
    return data;
  }

  @override
  String toString() {
    return 'Rank{importance: $importance, popularity: $popularity, confidence: $confidence, matchType: $matchType}';
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

  Timezone(
      {this.name,
        this.offsetStd,
        this.offsetStdSeconds,
        this.offsetDst,
        this.offsetDstSeconds,
        this.abbreviationStd,
        this.abbreviationDst});

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

  @override
  String toString() {
    return 'Timezone{name: $name, offsetStd: $offsetStd, offsetStdSeconds: $offsetStdSeconds, offsetDst: $offsetDst, offsetDstSeconds: $offsetDstSeconds, abbreviationStd: $abbreviationStd, abbreviationDst: $abbreviationDst}';
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

  @override
  String toString() {
    return 'Datasource{sourcename: $sourcename, attribution: $attribution, license: $license, url: $url}';
  }
}
