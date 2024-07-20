class WikiImageData {
  String? batchcomplete;
  Warnings? warnings;
  Query? query;

  WikiImageData({this.batchcomplete, this.warnings, this.query});

  WikiImageData.fromJson(Map<String, dynamic> json) {
    if (json["batchcomplete"] is String)
      this.batchcomplete = json["batchcomplete"];
    if (json["warnings"] is Map)
      this.warnings =
      json["warnings"] == null ? null : Warnings.fromJson(json["warnings"]);
    if (json["query"] is Map)
      this.query = json["query"] == null ? null : Query.fromJson(json["query"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["batchcomplete"] = this.batchcomplete;
    if (this.warnings != null) data["warnings"] = this.warnings?.toJson();
    if (this.query != null) data["query"] = this.query?.toJson();
    return data;
  }

  @override
  String toString() {
    return 'WikiData(batchcomplete: $batchcomplete, warnings: $warnings, query: $query)';
  }
}

class Query {
  List<Normalized>? normalized;
  Pages? pages;

  Query({this.normalized, this.pages});

  Query.fromJson(Map<String, dynamic> json) {
    if (json["normalized"] is List)
      this.normalized = json["normalized"] == null
          ? null
          : (json["normalized"] as List)
          .map((e) => Normalized.fromJson(e))
          .toList();
    if (json["pages"] is Map)
      this.pages = json["pages"] == null ? null : Pages.fromJson(json["pages"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.normalized != null)
      data["normalized"] = this.normalized?.map((e) => e.toJson()).toList();
    /*if (this.pages != null)
      data["pages"] = this.pages?.toJson();*/
    return data;
  }

  @override
  String toString() {
    return 'Query(normalized: $normalized, pages: $pages)';
  }
}

class Pages {
  String? pageID;
  PageInfo? pageInfo;

  Pages({this.pageID, this.pageInfo});

  Pages.fromJson(Map<String, dynamic> json) {
    for (Map<String, dynamic> page in json.values) {

      if (page['pageid'] !=null) {
        pageID = page['pageid'].toString();
        pageInfo = PageInfo.fromJson(page);
      }
    }
  }

  @override
  String toString() {
    return 'Pages(pageID: $pageID, pageInfo: $pageInfo)';
  }
}

class PageInfo {
  int? pageid;
  int? ns;
  String? title;
  String? thumbnail;
  String? pageimage;

  PageInfo({this.pageid, this.ns, this.title, this.thumbnail});

  PageInfo.fromJson(Map<String, dynamic> json) {
    if (json["pageid"] is int) this.pageid = json["pageid"];
    if (json["ns"] is int) this.ns = json["ns"];
    if (json["title"] is String) this.title = json["title"];
    if (json["extract"] is String) this.thumbnail = json["extract"];
    if (json["pageimage"] is String) this.pageimage = json["pageimage"];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["pageid"] = this.pageid;
    data["ns"] = this.ns;
    data["title"] = this.title;
    data["extract"] = this.thumbnail;
    return data;
  }

  @override
  String toString() {
    return 'PageInfo(pageid: $pageid, ns: $ns, title: $title, extract: $thumbnail)';
  }
}

class Normalized {
  String? from;
  String? to;

  Normalized({this.from, this.to});

  Normalized.fromJson(Map<String, dynamic> json) {
    if (json["from"] is String) this.from = json["from"];
    if (json["to"] is String) this.to = json["to"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["from"] = this.from;
    data["to"] = this.to;
    return data;
  }

  @override
  String toString() {
    return 'Normalized(from: $from, to: $to)';
  }
}

class Warnings {
  Extracts? extracts;

  Warnings({this.extracts});

  Warnings.fromJson(Map<String, dynamic> json) {
    if (json["extracts"] is Map)
      this.extracts =
      json["extracts"] == null ? null : Extracts.fromJson(json["extracts"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.extracts != null) data["extracts"] = this.extracts?.toJson();
    return data;
  }

  @override
  String toString() {
    return 'Warnings(extracts: $extracts)';
  }
}

class Extracts {
  String? info;

  Extracts({this.info});

  Extracts.fromJson(Map<String, dynamic> json) {
    if (json["*"] is String) this.info = json["*"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["*"] = this.info;
    return data;
  }

  @override
  String toString() {
    return 'Extracts(info: $info)';
  }
}
