import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_info.dart';
import 'package:super_liquid_galaxy_controller/data_class/wikidata.dart';

class WikiDataFetcher extends GetxController {
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

  void getInfo() async {
    _connectToApi();
    try {
      if (wikiTitle != null) {
        var response = await _apiClient.get(endpoint, queryParameters: {
          'action': 'query',
          'format': 'json',
          'titles': wikiTitle,
          'prop': 'extracts',
          'explaintext': '1'
        });

        if (response.statusCode != 200) {
          print("statusCode: ${response.statusCode}");
          return;
        }
        WikiData data = WikiData.fromJson(response.data);
        //print(data.query!.pages!.pageInfo!.extract);
      } else {
        String? title = await tryForDataFromTitle(placeData!.name.trim());
        print(title);
      }
    } catch (e) {
      print(e);
      isConnected = false;
    }
  }

  Future<List<String>?> wikiQuery(String query) async {
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
        return null;
      }
      //print(response.data);
      List<dynamic> responseList = response.data;
      List<String> titles = [];

      for (dynamic link1 in responseList[3]) {
        String link = link1.toString();
        titles.add(link.substring(link.lastIndexOf("/") + 1));
      }

      return titles;
    } catch (e) {
      print(e);
      return null;
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
          dp[i][j] = 1 + [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]].reduce((a, b) => a < b ? a : b);
        }
      }
    }
    return dp[m][n];
  }

  String mostMatchingString(String input, List<String> candidates) {
    String bestMatch =candidates[0];
    int minDistance = levenshteinDistance(input, candidates[0]);
    for (String candidate in candidates) {
      int distance = levenshteinDistance(input, candidate);
      if (distance < minDistance) {
        minDistance = distance;
        bestMatch = candidate;
      }
    }

    return bestMatch;
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
    List<String>? titles = await wikiQuery(label);
    if(titles != null && titles.isNotEmpty){
      print(titles);
      return mostMatchingString(label, titles);
    }
    List<String> labelParts = getLinearCombinations(label);
    print(labelParts);

    titles = [];
    for(final labelPart in labelParts)
      {
        List<String>? out = await wikiQuery(labelPart);
        if(out != null) {
          titles.addAll(out);
        }
      }
    if(titles.isNotEmpty) {
      print(titles);
      return mostMatchingString(label, titles);
    }
    return null;
  }
}
