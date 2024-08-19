import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_liquid_galaxy_controller/controllers/api_manager.dart';

import '../generated/assets.dart';
import '../utils/galaxy_colors.dart';
import 'custom_dialog.dart';
import 'galaxytextfield.dart';

class ApiManagerBlock extends StatefulWidget {
  ApiManagerBlock(
      {super.key,
      required this.description,
      required this.title,
      required this.urlDesc1,
      required this.urlDesc2,
      this.urlLauncher1,
      this.urlLauncher2,
      required this.keyController,
      required this.width});

  String title;
  String description;
  String urlDesc1;
  VoidCallback? urlLauncher1;
  String urlDesc2;
  VoidCallback? urlLauncher2;
  TextEditingController keyController;
  double width;

  @override
  State<ApiManagerBlock> createState() => _ApiManagerBlockState();
}

class _ApiManagerBlockState extends State<ApiManagerBlock> {
  @override
  void initState() {
    loadSetValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
                width: widget.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.1)
                    ])),
                child: Stack(children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(),
                  ),
                  Center(
                      child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: widget.width * 0.2),
                                child: Divider(
                                  color: Colors.white.withOpacity(0.8),
                                  thickness: 1.2,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                widget.description,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.1)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            splashColor:
                                                Colors.blue.withOpacity(0.3),
                                            onTap: widget.urlLauncher1,
                                            child: Container(
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  widget.urlDesc1,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20.0,
                                      ),
                                      Expanded(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            splashColor:
                                                Colors.blue.withOpacity(0.3),
                                            onTap: widget.urlLauncher2,
                                            child: Container(
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  widget.urlDesc2,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              GalaxyTextField(
                                hintText: "eg, ZaCELgL.0imfnc8mVLWwsAawjYr4Rx",
                                labelText: "PLACES API-KEY",
                                iconData: Icons.code,
                                textInputType: TextInputType.text,
                                controller: widget.keyController,
                                isPassword: true,
                                /*buttonAction: () {
                                  if (widget.keyController.text.isNotEmpty) {
                                    saveApiKey('places_apikey');
                                  } else {
                                    if (!Get.isSnackbarOpen) {
                                      Get.showSnackbar(GetSnackBar(
                                        backgroundColor: Colors.red.shade300,
                                        title: "EMPTY FIELD",
                                        message: "API Key Field is Empty!",
                                        isDismissible: true,
                                        duration: 3.seconds,
                                      ));
                                    }
                                  }
                                },
                                endIcon: Icons.save_alt_outlined,*/
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              MaterialButton(
                                color: GalaxyColors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                onPressed: () async {
                                  //await formSubmitted();
                                  if (widget.keyController.text.isNotEmpty) {
                                    saveApiKey('places_apikey');
                                  } else {
                                    if (!Get.isSnackbarOpen) {
                                      Get.showSnackbar(GetSnackBar(
                                        backgroundColor: Colors.red.shade300,
                                        title: "EMPTY FIELD",
                                        message: "API Key Field is Empty!",
                                        isDismissible: true,
                                        duration: 3.seconds,
                                      ));
                                    }
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 20.0
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.key,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(
                                        "CONNECT TO API",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                            ],
                          )))
                ]))));
  }

  void loadSetValues() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var key = preferences.getString("places_apikey") ?? "";
      key = key.trim();
      widget.keyController.text = key;
    } catch (e) {
      print(e);
    }
  }

  void saveApiKey(String prefKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(prefKey, widget.keyController.text);
    ApiManager apiClient = Get.find();
    await apiClient.testApiKey();
    var dialog = apiClient.isConnected.value
        ? CustomDialog(
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text("All Api Services now available!"),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "API KEY VALIDATED",
                style: TextStyle(
                    color: Colors.green.shade500,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            firstColor: Colors.green,
            secondColor: Colors.white,
            headerIcon: Lottie.asset(Assets.lottieConnected,
                decoder: customDecoder,
                repeat: false,
                width: 200.0,
                height: 200.0))
        : CustomDialog(
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text("Api services unavailable"),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "API KEY INVALID",
                style: TextStyle(
                    color: Colors.red.shade500,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            firstColor: Colors.red.shade400,
            secondColor: Colors.white,
            headerIcon: Lottie.asset(Assets.lottieConnectionfailed,
                decoder: customDecoder,
                repeat: false,
                width: 200.0,
                height: 200.0));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  Future<LottieComposition?> customDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(bytes, filePicker: (files) {
      return files.firstWhere(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    });
  }
}
