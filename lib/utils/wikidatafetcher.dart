import 'package:dio/dio.dart';
import 'package:super_liquid_galaxy_controller/data_class/image_info.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_info.dart';
import 'package:super_liquid_galaxy_controller/data_class/wiki_imagedata.dart';
import 'package:super_liquid_galaxy_controller/data_class/wikidata.dart';

class WikiDataFetcher {
  late PlaceInfo? placeData;
  late String? wikiTag;
  late String? wikiTitle;
  late String? wikiLang;
  late Dio _apiClient;
  bool isConnected = false;

  static const baseWikiUrl = 'https://en.wikipedia.org';
  static const endpoint = '/w/api.php';

  void setData(PlaceInfo place) {
    wikiTag = place.wikiMediaTag;
    wikiLang = place.wikipediaLang;
    wikiTitle = place.wikipediaTitle;
    placeData = place;
  }

  bool _connectToApi() {
    final options = BaseOptions(
        baseUrl: baseWikiUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 7),
        validateStatus: (status) {
          if (status != null) {
            return status < 500;
          } else {
            return false;
          }
        });
    _apiClient = Dio(options);
    // await _testApiKey();
    return isConnected;
  }

  bool _connectToApiWithLang(String lang) {
    final options = BaseOptions(
        baseUrl: 'https://$lang.wikipedia.org',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 7),
        validateStatus: (status) {
          if (status != null) {
            return status < 500;
          } else {
            return false;
          }
        });
    _apiClient = Dio(options);
    // await _testApiKey();
    return isConnected;
  }

  testApiKey() async {
    _connectToApi();
    try {
      var response = await _apiClient.get(endpoint, queryParameters: {
        'action': 'query',
        'format': 'json',
        'titles': 'Purana_Qila',
        'prop': 'extracts',
      });

      if (response.statusCode == 200) {
        isConnected = true;
      } else {
        //var error = ApiErrorResponse.fromJson(response.data);
        isConnected = false;
        //print('${error.error} - ${error.message}');
      }
    } catch (e) {
      print(e);
      isConnected = false;
    }
  }

  Future<String?> fetchImageUrl(String fileName) async
  {
    try {
      var response = await _apiClient.get(endpoint, queryParameters: {
        'action': 'query',
        'format': 'json',
        'titles': 'File:$fileName',
        'prop': 'imageinfo',
        'redirects':'',
        'iiprop':'url',
        'iiurlheight':'1024',
        'iiurlwidth':'1024'
      });

      if (response.statusCode == 200) {
        isConnected = true;
        print(response.data);
        ImageInfo info = ImageInfo.fromJson(response.data);
        print("URL ${info.query?.pages?.pageInfo?.imageLink}");
        return info.query?.pages?.pageInfo?.imageLink;
      } else {
        //var error = ApiErrorResponse.fromJson(response.data);
        isConnected = false;
        //print('${error.error} - ${error.message}');
      }
    } catch (e) {
      print(e);
      isConnected = false;
    }
    return null;
  }

  Future<({String? fileName, String? url})> fetchImage(String label) async {
    //_connectToApi();
    String decodeTitle = Uri.decodeFull(label);
    try {
      var response = await _apiClient.get(endpoint, queryParameters: {
        'action': 'query',
        'format': 'json',
        'titles': decodeTitle,
        'prop': 'pageimages',
        'redirects': ''
      });

      if (response.statusCode == 200) {
        isConnected = true;
        WikiImageData data = WikiImageData.fromJson(response.data);
        print(response.data);
        print("image data response :${data.query?.pages?.pageInfo?.pageimage}");
        if (data.query?.pages?.pageInfo?.pageimage != null) {
          String? url = await fetchImageUrl(data.query!.pages!.pageInfo!.pageimage!);
          if(url != null) {
            return (fileName: data.query!.pages!.pageInfo!.pageimage!, url: url);
          }
        }
      } else {
        isConnected = false;
      }
    } catch (e) {
      print(e);
      isConnected = false;
    }
    return (fileName: null, url: null);
  }

  Future<String?> getImages() async {
    if (wikiLang != null) {
      _connectToApiWithLang(wikiLang!.trim());
    } else {
      _connectToApi();
    }
    //_connectToApi();
    List<String> titles = [];
    List<String> links = [];
    if (wikiTitle != null) {
      links.add(wikiTitle!);
      titles.add(wikiTitle!.replaceAll('_', ' '));
    }
    String label = placeData!.name.trim();
    var out = await wikiQuery(label);

    if (out.t != null && out.l != null) {
      titles.addAll(out.t!);
      links.addAll(out.l!);
    }

    print('image $titles');
    print('image $links');

    if (titles.isNotEmpty) {
      print("t1 $titles");
      int matchIndex = mostMatchingString(label, titles);
      var out = await fetchImage(links[matchIndex]);
      print(out);
      return out.url;
    }
    else {
      List<String> labelParts = getLinearCombinations(label);
      print(labelParts);

      titles = [];
      for (final labelPart in labelParts) {
        var out = await wikiQuery(labelPart);
        var t = out.t;
        var l = out.l;
        if (t != null && l != null) {
          titles.addAll(t);
          links.addAll(l);
        }
      }
      if (titles.isNotEmpty) {
        print("t2 $titles");
        int matchIndex = mostMatchingString(label, titles);
        var out = await fetchImage(links[matchIndex]);
        print(out);
        return out.url;
      }

    }
    return null;
  }

  Future<String?> getInfo() async {
    if (wikiLang != null) {
      _connectToApiWithLang(wikiLang!.trim());
    } else {
      _connectToApi();
    }

    try {
      print("Searching Title: $wikiTitle, $wikiLang");
      wikiTitle?.replaceAll(' ', '_');
      if (wikiTitle != null) {
        var response = await _apiClient.get(endpoint, queryParameters: {
          'action': 'query',
          'format': 'json',
          'titles': wikiTitle,
          'prop': 'extracts',
          'explaintext': '1',
          'redirects': ''
        });
        print(response);
        if (response.statusCode != 200) {
          print("statusCode: ${response.statusCode}");
          //throw Exception("Could not find Information");
        }
        WikiData data = WikiData.fromJson(response.data);
        return data.query?.pages?.pageInfo?.extract;
      } else {
        String? title = await tryForDataFromTitle(placeData!.name.trim());
        print("tryFordataFromTitle: $title");
        if (title != null) {
          print("2nd try from list Searching Title: $title");
          String decodeTitle = Uri.decodeFull(title);
          print("Decoded $decodeTitle");
          var response = await _apiClient.get(endpoint, queryParameters: {
            'action': 'query',
            'format': 'json',
            'titles': decodeTitle.trim(),
            'prop': 'extracts',
            'explaintext': '1',
            'redirects': ''
          });
          print(response);
          if (response.statusCode != 200) {
            print("statusCode: ${response.statusCode}");
            //throw Exception("Could not find Information");
          }
          WikiData data = WikiData.fromJson(response.data);
          return data.query?.pages?.pageInfo?.extract;
        } else {
          throw Exception("Could not find Information");
          return null;
        }
        print(title);
      }
    } catch (e) {
      print(e);
      isConnected = false;
      return null;
    }
  }

  Future<({List<String>? t, List<String>? l})> wikiQuery(String query) async {
    _connectToApi();
    try {
      var response = await _apiClient.get(endpoint, queryParameters: {
        'action': 'opensearch',
        'format': 'json',
        'search': query,
        'rvprop': 'content',
      });

      if (response.statusCode != 200) {
        print("statusCode: ${response.statusCode}");
        return (t: null, l: null);
      }
      //print(response.data);
      List<dynamic> responseList = response.data;
      List<String> titles = [];
      List<String> links = [];

      for (dynamic link1 in responseList[1]) {
        String title = link1.toString();
        titles.add(title);
      }
      for (dynamic link1 in responseList[3]) {
        String link = link1.toString();
        links.add(link.substring(link.lastIndexOf("/") + 1));
      }

      return (t: titles, l: links);
    } catch (e) {
      print(e);
      return (t: null, l: null);
    }
  }

  /*String getMostLikelyTitle(String title, List<String> titles)
  {
    int compareVal = title.compareTo(titles[0]).abs();
    String output = titles[0];
    for(String name in titles)
      {
        name = name.replaceAll('_', ' ');
        if(title.compareTo(name).abs()<compareVal)
          {
            compareVal= title.compareTo(name).abs();
            output = name;
          }
      }
    return output;
  }*/

  int levenshteinDistance(String s1, String s2) {
    int m = s1.length;
    int n = s2.length;
    List<List<int>> dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

    for (int i = 0; i <= m; i++) {
      for (int j = 0; j <= n; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 +
              [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]]
                  .reduce((a, b) => a < b ? a : b);
        }
      }
    }
    return dp[m][n];
  }

  int mostMatchingString(String input, List<String> candidates) {
    String bestMatch = candidates[0];
    int minIndex = 0;
    int minDistance = levenshteinDistance(input, candidates[0]);
    for (var item in candidates.indexed) {
      int index = item.$1;
      String candidate = item.$2;
      int distance = levenshteinDistance(input, candidate);
      if (distance < minDistance) {
        minDistance = distance;
        bestMatch = candidate;
        minIndex = index;
      }
    }

    return minIndex;
  }

  List<String> getLinearCombinations(String label) {
    List<String> words = label.split(' ');
    List<String> combinations = [];

    for (int i = 0; i < words.length; i++) {
      for (int j = i; j < words.length; j++) {
        combinations.add(words.sublist(i, j + 1).join(' '));
      }
    }

    return combinations;
  }

  Future<String?> tryForDataFromTitle(String label) async {
    var out = await wikiQuery(label);

    List<String>? titles = [];
    List<String>? links = [];

    if (out.t != null && out.l != null) {
      titles.addAll(out.t!);
      links.addAll(out.l!);
    }
    if (titles != null && titles.isNotEmpty) {
      // List<String>? titles = [];    print(titles);
      print(titles);
      int matchIndex = mostMatchingString(label, titles);
      return links[matchIndex];
    }
    List<String> labelParts = getLinearCombinations(label);
    print(labelParts);

    titles = [];
    for (final labelPart in labelParts) {
      var out = await wikiQuery(labelPart);
      var t = out.t;
      var l = out.l;
      if (t != null && l != null) {
        titles.addAll(t);
        links.addAll(l);
      }
    }
    if (titles.isNotEmpty) {
      print(titles);
      print(links);
      int matchIndex = mostMatchingString(label, titles);
      return links[matchIndex];
    }
    return null;
  }
}
