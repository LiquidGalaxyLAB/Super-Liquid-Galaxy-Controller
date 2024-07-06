import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:super_liquid_galaxy_controller/data_class/geocode_response.dart';
import 'package:super_liquid_galaxy_controller/utils/api_manager.dart';
import 'package:super_liquid_galaxy_controller/utils/lg_connection.dart';

import '../data_class/coordinate.dart';

class TourController extends getx.GetxController {
  late ApiManager apiClient;
  late LGConnection connectionClient;
  var _searchAroundCoords = Coordinates(latitude: 12.0, longitude: 12.0).obs;
  String _label = '';

  @override
  void onInit() {
    apiClient = getx.Get.find();
    connectionClient = getx.Get.find();
    super.onInit();
  }

  void setSearchAround(Coordinates point, String label) {
    _searchAroundCoords.value = point;
    _label = label;
    getPlaceBounds();
  }

  Coordinates getSearchAround() {
    return _searchAroundCoords.value;
  }

  void getPlaceBounds() async {

      var queryText = _label.split('\n').reversed.join(", ");
      bool isCountry = _label.split('\n').where((String str) {
            return str.isNotEmpty;
          }).length == 1;
      if(isCountry)
        {
          queryText = _label.split('\n')[0];
        }
      print(queryText);
      String placeID = await apiClient.tryResponseFromPoint(
          _searchAroundCoords.value, isCountry);
      print("id: $placeID");

  }
}
