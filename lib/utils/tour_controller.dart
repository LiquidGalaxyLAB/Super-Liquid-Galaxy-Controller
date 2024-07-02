import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_liquid_galaxy_controller/utils/api_manager.dart';
import 'package:super_liquid_galaxy_controller/utils/lg_connection.dart';

import '../data_class/coordinate.dart';

class TourController extends GetxController
{
  late ApiManager apiClient;
  late LGConnection connectionClient;
  var _searchAroundCoords = Coordinates(latitude: 12.0, longitude: 12.0).obs;


  @override
  void onInit() {
    apiClient = Get.find();
    connectionClient = Get.find();
    super.onInit();
  }

  void setSearchAround(Coordinates point)
  {
    _searchAroundCoords.value = point;
  }
  Coordinates getSearchAround()
  {
    return _searchAroundCoords.value;
  }
}