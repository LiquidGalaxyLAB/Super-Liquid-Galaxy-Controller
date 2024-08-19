import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowcaseController extends GetxController {
  bool _isFirstLaunchDashboard = true;
  bool _isFirstLaunchSettings = true;
  bool _isFirstLaunchKmlBuilder = true;
  bool _isFirstLaunchGeoQuest = true;
  bool _isFirstLaunchMaps = true;
  bool _isFirstLaunchTours = true;
  bool _isFirstLaunchPOI = true;

  void fetchFirstLaunch() async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var isFirst = preferences.getString('first_time_dashboard');
    if(isFirst == null ||isFirst == 'true') {
      _isFirstLaunchDashboard = true;
    } else {
      _isFirstLaunchDashboard = false;
    }
    isFirst = preferences.getString('first_time_settings');
    if(isFirst == null || isFirst == 'true') {
      _isFirstLaunchSettings = true;
    } else {
      _isFirstLaunchSettings = false;
    }
    isFirst = preferences.getString('first_time_kml_builder');

    if(isFirst == null || isFirst == 'true') {
      _isFirstLaunchKmlBuilder = true;
    } else {
      _isFirstLaunchKmlBuilder = false;
    }

    isFirst = preferences.getString('first_time_geoquest');

    if(isFirst == null || isFirst == 'true') {
      _isFirstLaunchGeoQuest = true;
    } else {
      _isFirstLaunchGeoQuest = false;
    }

    isFirst = preferences.getString('first_time_maps');

    if(isFirst == null || isFirst == 'true') {
      _isFirstLaunchMaps = true;
    } else {
      _isFirstLaunchMaps = false;
    }

    isFirst = preferences.getString('first_time_tours');

    if(isFirst == null || isFirst == 'true') {
      _isFirstLaunchTours = true;
    } else {
      _isFirstLaunchTours = false;
    }

    isFirst = preferences.getString('first_time_poi');

    if(isFirst == null || isFirst == 'true') {
      _isFirstLaunchPOI = true;
    } else {
      _isFirstLaunchPOI = false;
    }

    print("$_isFirstLaunchDashboard,$_isFirstLaunchSettings");
  }

  bool isFirstLaunchDashboard()
  {
    return _isFirstLaunchDashboard;
  }

  bool isFirstLaunchSettings()
  {
    return _isFirstLaunchSettings;
  }
  bool isFirstLaunchKmlBuilder()
  {
    return _isFirstLaunchKmlBuilder;
  }
  bool isFirstLaunchGeoQuest()
  {
    return _isFirstLaunchGeoQuest;
  }
  bool isFirstLaunchMap()
  {
    return _isFirstLaunchMaps;
  }
  bool isFirstLaunchTours()
  {
    return _isFirstLaunchTours;
  }
  bool isFirstLaunchPOI()
  {
    return _isFirstLaunchPOI;
  }


  setDashboardCompleted() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('first_time_dashboard', "false");
    _isFirstLaunchDashboard = false;
    print("set-dashboard-done");
  }

  setSettingsCompleted() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('first_time_settings', "false");
    _isFirstLaunchSettings = false;
    print("set-settings-done");
  }

  setKmlBuilderCompleted() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('first_time_kml_builder', "false");
    _isFirstLaunchKmlBuilder = false;
    print("set-kml-builder-done");
  }

  setGeoQuestCompleted() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('first_time_geoquest', "false");
    _isFirstLaunchGeoQuest = false;
    print("set-poi-done");
  }

  setMapsCompleted() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('first_time_maps', "false");
    _isFirstLaunchMaps = false;
    print("set-maps-done");
  }

  setToursCompleted() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('first_time_tours', "false");
    _isFirstLaunchTours = false;
    print("set-tours-done");
  }

  setPOICompleted() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('first_time_poi', "false");
    _isFirstLaunchPOI = false;
    print("set-poi-done");
  }

  clearTutorialNeeds()
  {
    setPOICompleted();
    setToursCompleted();
    setMapsCompleted();
    setSettingsCompleted();
    setDashboardCompleted();
    setGeoQuestCompleted();
    setKmlBuilderCompleted();
  }


}