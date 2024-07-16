import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:super_liquid_galaxy_controller/components/galaxytextfield.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/data_class/country_data.dart';
import 'package:super_liquid_galaxy_controller/screens/location_picker.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';
import 'package:geocoding/geocoding.dart';
import 'package:super_liquid_galaxy_controller/utils/tour_controller.dart';
import '../generated/assets.dart';

class LocationSelector extends StatefulWidget {
  LocationSelector(
      {super.key, this.height, this.width, this.iconSize, this.searchSize, required this.submitData,required this.tourController});

  double? height;
  double? width;
  double? iconSize;
  double? searchSize;
  TourController tourController;
  Function(Coordinates,String) submitData;

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  late List<CountryData> jsonList;
  late List<dynamic> dataList;
  late String label;
  late String selectedCountry;
  late String selectedState;

  var isLoading = false;


  @override
  void initState() {
    selectedCountry = "India";
    selectedState = "West Bengal";
    label = "$selectedCountry \n$selectedState";
    widget.tourController.setSearchAround(Coordinates(latitude: 22.9867569, longitude: 87.854975), label);
    initializeJsonList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: widget.key,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: () async {
            await initializeJsonList();
            CountryData? country = await showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                      builder: (BuildContext context,
                          StateSetter setModalState){
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery
                                    .of(context)
                                    .viewInsets
                                    .bottom),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GalaxyTextField(
                                      hintText: "Country...",
                                      labelText: "SELECT COUNTRY",
                                      iconData: Icons.search_rounded,
                                      textInputType: TextInputType.text,
                                      isPassword: false,
                                      focusColor: Colors.black,
                                      labelColor: Colors.grey.shade900,
                                      onTextChanged: (text) {
                                        print(text);
                                        setModalState(() {
                                          {
                                            dataList.clear();
                                            dataList.addAll(
                                                jsonList.where((
                                                    CountryData country) {
                                                  return country.name!
                                                      .toLowerCase()
                                                      .contains(
                                                      text.toLowerCase());
                                                }));
                                            print(dataList.length);
                                          }
                                        });
                                      }),
                                  Container(
                                    height: widget.searchSize! * 0.5,
                                    child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        var country = dataList[index];
                                        return InkWell(
                                            onTap: () {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              Get.back(result: country);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 20.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    country.emoji!,
                                                    style: const TextStyle(
                                                        fontSize: 24.0),
                                                  ),
                                                  const SizedBox(
                                                    width: 16.0,
                                                  ),
                                                  Text(
                                                    country.name!,
                                                    style: const TextStyle(
                                                        fontSize: 24.0),
                                                  )
                                                ],
                                              ),
                                            ));
                                      },
                                      itemCount: dataList.length,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                isDismissible: true,
                isScrollControlled: true);

            if (country == null) {
              return;
            }
            dataList.clear();
            var stateList = jsonList[jsonList.indexOf(country)].state;
            selectedCountry = country.name!;
            if (stateList == null || stateList.isEmpty) {
              selectedState = "";
              setLabelFromName();
              return;
            }
            dataList.addAll(stateList.where((state) {
              return (state.name != null);
            }));
            stateList.clear();
            for (StateData data in dataList) {
              stateList.add(data);
            }
            StateData? stateData = await showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (BuildContext context,
                      StateSetter setModalState) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery
                                .of(context)
                                .viewInsets
                                .bottom),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GalaxyTextField(
                                  hintText: "State...",
                                  labelText: "SELECT STATE",
                                  iconData: Icons.search_rounded,
                                  textInputType: TextInputType.text,
                                  isPassword: false,
                                  focusColor: Colors.black,
                                  labelColor: Colors.grey.shade900,
                                  onTextChanged: (text) {
                                    print(text);
                                    setModalState(() {
                                      {
                                        dataList.clear();
                                        dataList.addAll(
                                            stateList.where((StateData sta) {
                                              return sta.name!
                                                  .toLowerCase()
                                                  .contains(text.toLowerCase());
                                            }));
                                        print(dataList.length);
                                      }
                                    });
                                  }),
                              Container(
                                height: widget.searchSize! * 0.5,
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    StateData sta = dataList[index];
                                    return InkWell(
                                        onTap: () {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          Get.back(result: sta);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 20.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                sta.name!,
                                                style: const TextStyle(
                                                    fontSize: 24.0),
                                              ),
                                              const SizedBox(
                                                width: 16.0,
                                              ),
                                              Text(
                                                sta.id.toString(),
                                                style: const TextStyle(
                                                    fontSize: 24.0),
                                              )
                                            ],
                                          ),
                                        ));
                                  },
                                  itemCount: dataList.length,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
                },
                isDismissible: true,
                isScrollControlled: true);
            if (stateData == null) {
              selectedState = "";
              setState(() {
                isLoading = true;
              });
              setLabelFromName();
              return;
            }
            setState(() {
              isLoading = true;
            });
            selectedState = stateData.name!;
            setLabelFromName();
            /*List<CountryData> dataList = await getResponse();
            print(dataList);*/
          },
          child: Container(
            decoration: BoxDecoration(
                color: GalaxyColors.yellow.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20.0)),
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20.0),
                      onTap: () async {
                        Coordinates coordinate = await Get.to(()=> LocationPicker());
                        setLabelFromPoint(coordinate);
                      },
                      child: Stack(
                        children:[ Visibility(
                          visible: !isLoading,
                          child: ImageIcon(
                            const AssetImage(Assets.iconsPlaceMarker),
                            color: Colors.white,
                            size: widget.iconSize ?? 65.0,
                          ),
                        ),

                          Visibility(
                            visible: isLoading,
                            child: Lottie.asset(
                              Assets.lottieLoadingspinner,
                              decoder: customDecoder,
                              repeat: true,
                              width: widget.iconSize ?? 65.0,
                              height: widget.iconSize ?? 65.0
                            ),
                          ),

                        ]
                      ),
                    ),
                    Container(
                      height: widget.iconSize ?? 75.0,
                      child: VerticalDivider(
                        thickness: 1.5,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Obx((){
                      return Text(
                        widget.tourController.label.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    })
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Future<List<CountryData>> getResponse() async {
    var res = await rootBundle.loadString('assets/data/country.json');
    var list = jsonDecode(res);
    List<CountryData> output = [];
    for (Map<String, dynamic> item in list) {
      CountryData data = CountryData.fromJson(item);
      output.add(data);
    }
    return output;
  }

  Future<void> initializeJsonList() async {
    jsonList = await getResponse();
    dataList = [];
    dataList.addAll(jsonList);
  }

  void setLabelFromPoint(Coordinates point) async {
    setState(() {
      isLoading = true;
    });
    widget.tourController.isLoading.value = true;
    widget.tourController.isError.value = false;
    var out = await placemarkFromCoordinates(point.latitude, point.longitude);
    print(out);

    if (out.isNotEmpty) {
      var likelyPoint = out[0];
      if(likelyPoint.country==null)
        {
          for(final item in out)
            {
              likelyPoint = (item.country==null)?likelyPoint:item;
            }
        }
      selectedCountry = likelyPoint.country!;
      if(likelyPoint.administrativeArea==null)
      {
        for(final item in out)
        {
          likelyPoint = (item.administrativeArea==null)?likelyPoint:item;
        }
      }
      selectedState = likelyPoint.administrativeArea!;
      setState(() {
        label = "$selectedCountry \n$selectedState";
        isLoading = false;
        print("point3");

      });
    }
    else {
      widget.tourController.isError.value = true;
      widget.tourController.isLoading.value = false;
      if (!Get.isSnackbarOpen) {
        Get.showSnackbar(GetSnackBar(
          backgroundColor: Colors.red.shade300,
          title: "Location Error",
          message: "Could not geocode area",
          isDismissible: true,
          duration: 3.seconds,
        ));
      }
    }
    setState(() {
      isLoading = false;
      print("point2");

    });
    widget.submitData(point,label);
  }


  void setLabelFromName() async {
    setState(() {
      label = "$selectedCountry \n$selectedState";
      widget.tourController.label.value = "$selectedCountry \n$selectedState";
      isLoading=false;
      print("point1");
    });
    try {
      widget.tourController.isLoading.value = true;
      widget.tourController.isError.value = false;
      var out = await locationFromAddress("$selectedState,$selectedCountry").timeout(Duration(seconds: 10), onTimeout: (){
        throw Exception("Location fetch timeout...");
      });
      print(out);
      if (out.isNotEmpty) {
        print(out);
        widget.submitData(
            Coordinates(latitude: out[0].latitude, longitude: out[0].longitude), label);
      }
      else {
        print("object");
        widget.tourController.isError.value = true;
        widget.tourController.isLoading.value = false;
        if (!Get.isSnackbarOpen) {
          Get.showSnackbar(GetSnackBar(
            backgroundColor: Colors.red.shade300,
            title: "Location Error",
            message: "Could not Geocode area",
            isDismissible: true,
            duration: 3.seconds,
          ));
        }
      }
    }
    catch(e)
    {
      print("here");
      widget.tourController.isError.value = true;
      widget.tourController.isLoading.value = false;
      if (!Get.isSnackbarOpen) {
        Get.showSnackbar(GetSnackBar(
          backgroundColor: Colors.red.shade300,
          title: "Location Error",
          message: "Could not Geocode area. Error: $e",
          isDismissible: true,
          duration: 3.seconds,
        ));
      }
    }


  }

  Future<LottieComposition?> customDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(bytes, filePicker: (files) {
      return files.firstWhere(
            (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    });
  }
}
