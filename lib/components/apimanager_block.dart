import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/utils/api_manager.dart';
import 'galaxytextfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      required this.screenHeight,
      required this.screenWidth});

  String title;
  String description;
  String urlDesc1;
  VoidCallback? urlLauncher1;
  String urlDesc2;
  VoidCallback? urlLauncher2;
  TextEditingController keyController;
  double screenHeight;
  double screenWidth;

  @override
  State<ApiManagerBlock> createState() => _ApiManagerBlockState();
}

class _ApiManagerBlockState extends State<ApiManagerBlock> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
                height: widget.screenHeight * 0.54,
                width: widget.screenWidth * 0.9,
                child: Stack(children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.white.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.1)
                        ])),
                  ),
                  Center(
                      child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
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
                                    horizontal: widget.screenWidth * 0.2),
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
                                height: 10.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
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
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          splashColor:
                                              Colors.blue.withOpacity(0.3),
                                          onTap: widget.urlLauncher1,
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
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          splashColor:
                                              Colors.blue.withOpacity(0.3),
                                          onTap: widget.urlLauncher2,
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
                                isPassword: false,
                                buttonAction: () {
                                  if (widget.keyController.text.isNotEmpty) {
                                    saveApiKey('places_apikey');
                                  }
                                  else
                                    {
                                      var snackbar = const SnackBar(content: Text("API-Key Field is empty!"));
                                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                    }
                                },
                                endIcon: Icons.save_alt_outlined,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                            ],
                          )))
                ]))));
  }

  void saveApiKey(String prefKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(prefKey, widget.keyController.text);
    var manager = ApiManager.instance;
  }
}
