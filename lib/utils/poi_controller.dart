import 'package:get/get.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_info.dart';
import 'package:super_liquid_galaxy_controller/utils/wikidatafetcher.dart';

import 'api_manager.dart';
import 'lg_connection.dart';

class PoiController extends GetxController{
  late ApiManager apiClient;
  late LGConnection connectionClient;
  late WikiDataFetcher dataFetcher;
  late PlaceInfo place;


  var descriptionIsLoading = false.obs;
  var descriptionIsError = false.obs;
  var imageIsLoading = false.obs;
  var imageIsError = false.obs;
  var isOrbit = false.obs;
  var isVoicing = false.obs;

  var description = ''.obs;
  var imageLink = ''.obs;
  @override
  void onInit() {
    apiClient = Get.find();
    connectionClient = Get.find();
    dataFetcher = WikiDataFetcher();
    super.onInit();
  }

  void setInfo(PlaceInfo pl)
  {
    place = pl;
    description.value = place.description ?? '';
    imageLink.value = place.imageLink ?? '';
  }
  void fetchAllInfo() async {
    fetchDescription();
    loadImage();
  }




  void fetchDescription() async
  {
    descriptionIsLoading.value = true;
    descriptionIsError.value = false;
    dataFetcher.setData(place);
    try{
      description.value = await dataFetcher.getInfo() ?? "Loading....";
      if(description.value == "Loading....") {
        throw Exception("No Data Found");
      }
      place.description = description.value;
      descriptionIsLoading.value = false;
      descriptionIsError.value = false;
    }
    catch(e)
    {
      descriptionIsLoading.value = false;
      descriptionIsError.value = true;
    }
  }

  void loadImage() async{
    imageIsLoading.value = true;
    imageIsError.value = false;
    try{
      imageLink.value = await dataFetcher.getImages() ?? '';
      place.imageLink = imageLink.value;
      if(imageLink.value == "") {
        throw Exception("No Data Found");
      }
      imageIsLoading.value = false;
      imageIsError.value = false;
    }
    catch(e)
    {
      imageIsLoading.value = false;
      imageIsError.value = true;
    }
    print("masterLink: ${imageLink.value}");
  }
}