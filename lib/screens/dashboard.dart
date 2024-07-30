import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:super_liquid_galaxy_controller/components/galaxytextfield.dart';
import 'package:super_liquid_galaxy_controller/components/navisland.dart';
import 'package:super_liquid_galaxy_controller/components/planet_selector.dart';
import 'package:super_liquid_galaxy_controller/controllers/api_manager.dart';
import 'package:super_liquid_galaxy_controller/controllers/lg_connection.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';
import 'package:super_liquid_galaxy_controller/screens/settings.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';

import '../components/connection_flag.dart';
import '../components/glassbox.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late double screenHeight;
  late double screenWidth;
  late LGConnection connectionClient;
  late ApiManager apiClient;
  GlobalKey widgetKey = GlobalKey();
  int selectedIndex = 0;
  TextEditingController keyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    log("ui", "dashboard-built");
    initializeLGClient();
    initializeApiClient();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Assets.assetsBackgroundspace),
                    fit: BoxFit.cover),
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset("assets/earth.gif",
                          height: screenHeight,
                          width: screenWidth,
                          fit: BoxFit.cover),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 20.0),
                            child: Row(
                              children: [
                                Image(
                                  image: AssetImage(Assets.assetsLogo),
                                  height: screenHeight * 0.1,
                                ),
                                SizedBox(width: 20),
                                Container(
                                  width: screenWidth * 0.4,
                                  height: screenHeight * 0.1,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      "SUPER LIQUID GALAXY CONTROLLER",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 20.0),
                                child: GlassBox(
                                  height: screenHeight * 0.1,
                                  width: screenHeight * 0.3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Obx(() {
                                        return Container(
                                          height: screenHeight * 0.1,
                                          width: screenHeight * 0.3,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Icon(
                                                    Icons
                                                        .cleaning_services_sharp,
                                                    size: screenHeight * 0.07,
                                                    color: connectionClient
                                                            .isConnected.value
                                                        ? GalaxyColors.blue
                                                        : Colors.red,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12.0,
                                              ),
                                              Expanded(
                                                flex: 10,
                                                child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Text(
                                                    "CLEAR KML",
                                                    style: TextStyle(
                                                        color: connectionClient
                                                                .isConnected
                                                                .value
                                                            ? GalaxyColors.blue
                                                            : Colors.red,
                                                        fontSize:
                                                            screenHeight * 0.07,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  onTap: () async {
                                    /*log("gesture", "settings tapped");
                                    await Get.to(() => Settings());*/

                                    if (!connectionClient.isConnected.value) {
                                      retryConnectionOrShowError();
                                      return;
                                    }
                                    showAlertMessage(
                                        "Warning!",
                                        "This will clear all KMLs on the LG rig",
                                        connectionClient.clearKml);
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 20.0),
                                child: GlassBox(
                                  height: screenHeight * 0.1,
                                  width: screenHeight * 0.1,
                                  child: Icon(
                                    Icons.settings,
                                    size: screenHeight * 0.07,
                                    color: Colors.white,
                                  ),
                                  onTap: () async {
                                    log("gesture", "settings tapped");
                                    var out = await checkCredentials();
                                    if (!out.isPassWordGuarded) {
                                      await Get.to(() => Settings());
                                    } else {
                                      keyController.clear();
                                      String result = await Get.defaultDialog(
                                          title: "ENTER PASSWORD USED",
                                          content: Container(
                                            width: screenWidth * 0.5,
                                            child: GalaxyTextField(
                                              hintText: "",
                                              labelText: "Password",
                                              controller: keyController,
                                              iconData: Icons.password_rounded,
                                              textInputType: TextInputType.text,
                                              isPassword: true,
                                              labelColor: Colors.grey,
                                            ),
                                          ),
                                          buttonColor: Colors.white,
                                          textConfirm: "ENTER",
                                          confirmTextColor: Colors.green,
                                          textCancel: "CANCEL",
                                          cancelTextColor: Colors.red,
                                          onConfirm: () {
                                            Get.back(
                                                result: keyController.text);
                                          },
                                          onCancel: () {
                                            Get.back(result: '');
                                          });

                                      if (result.compareTo(out.password) == 0) {
                                        await Get.to(() => Settings());
                                      } else {
                                        if (!(result.compareTo('') == 0)) {
                                          showErrorSnackBar();
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 20),
                          GlassBox(
                              height: 50,
                              width: 200,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(() {
                                    return ConnectionFlag(
                                      status:
                                          connectionClient.isConnected.value,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.0),
                                      selectedText: 'LG CONNECTED',
                                      unSelectedText: 'LG NOT CONNECTED',
                                      fontSize: 15.0,
                                    );
                                  }),
                                ],
                              )),
                          SizedBox(width: 20),
                          GlassBox(
                              height: 50,
                              width: 210,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(() {
                                    return ConnectionFlag(
                                      status: apiClient.isConnected.value,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.0),
                                      selectedText: 'API CONNECTED',
                                      unSelectedText: 'API NOT CONNECTED',
                                      fontSize: 15.0,
                                    );
                                  }),
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenHeight * 0.15,
                            vertical: screenHeight * 0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            PlanetSelector(
                              key: widgetKey,
                              height: screenHeight * 0.2,
                              width: screenWidth * 0.4,
                              onPressed: () {
                                menu(widgetKey);
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: NavIsland(
                            height: screenHeight * 0.6,
                            width: screenWidth * 0.3),
                      )
                    ],
                  )
                ],
              ),
            )));
  }

  void log(String name, String message) {
    developer.log(message, name: name);
  }

  void initializeLGClient() async {
    connectionClient = Get.find();
    await connectionClient.connectToLG();
    await connectionClient.showLogos();
  }

  void initializeApiClient() async {
    apiClient = Get.find();
    await apiClient.testApiKey();
  }

  void _reload() {
    setState(() {});
  }

  //test

  /*Future<void> testDialog() async {
    var customDialog = CustomDialog(
      content: Text("SSH operations are now possible."),
      title: Text("Connection established",style: TextStyle(color: Colors.green.shade500,fontSize: 25.0,fontWeight: FontWeight.bold),),
      firstColor: Colors.green,
      secondColor: Colors.white,
      headerIcon: Lottie.asset(Assets.lottieConnected,
          decoder: customDecoder, repeat: false,width: 200.0,height: 200.0));

    var customDialog1 = CustomDialog(
        content: Text("SSH operations unavailable."),
        title: Text("Connection failed",style: TextStyle(color: Colors.red.shade500,fontSize: 25.0,fontWeight: FontWeight.bold),),
        firstColor: Colors.red.shade400,
        secondColor: Colors.white,
        headerIcon: Lottie.asset(Assets.lottieConnectionfailed,
            decoder: customDecoder, repeat: false,width: 200.0,height: 200.0));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return customDialog1;
      },
    );
  }*/

  Future<LottieComposition?> customDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(bytes, filePicker: (files) {
      return files.firstWhere(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    });
  }

  showAlertMessage(String title, String content, Function action) {
    Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: Colors.red),
        ),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text(
              "CANCEL",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text(
              "CONTINUE",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              await action();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void retryConnectionOrShowError() {
    //await connectionClient.reConnectToLG();
    if (!connectionClient.connectStatus()) {
      if (!Get.isSnackbarOpen) {
        Get.showSnackbar(GetSnackBar(
          backgroundColor: Colors.red.shade300,
          title: "Connection Error",
          message: "Unable to connect to Liquid Galaxy rig",
          isDismissible: true,
          duration: 3.seconds,
        ));
      }
    }
  }

  Future<({bool isPassWordGuarded, String password})> checkCredentials() async {
    var detailsMap = await connectionClient.getStoredDetails();
    if (detailsMap["username"].toString().compareTo('') == 0 &&
        detailsMap["pass"].toString().compareTo('') == 0) {
      return (isPassWordGuarded: false, password: '');
    } else {
      return (isPassWordGuarded: true, password: detailsMap["pass"].toString());
    }
  }

  void showErrorSnackBar() {
    if (!Get.isSnackbarOpen) {
      Get.showSnackbar(GetSnackBar(
        backgroundColor: Colors.red.shade300,
        title: "INCORRECT PASSWORD",
        message: "Use the password that was used for the Liquid Galaxy rig.",
        isDismissible: true,
        duration: 5.seconds,
      ));
    }
  }

  void menu(GlobalKey key) {
    PopupMenu menu = PopupMenu(
      context: context,
      config: MenuConfig(
        type: MenuType.list,
        itemWidth: screenWidth*0.3,
        itemHeight: screenHeight*0.1,
        backgroundColor: Colors.white.withOpacity(0.5),
        lineColor: Colors.grey,
        maxColumn: 1,
        highlightColor: Colors.black
      ),
      items: [
        MenuItem(
            title: '   Earth',
            image: Image.asset(
              Assets.iconsEarth,
              height: screenHeight*0.07,
              width: screenHeight*0.07,

            ),
        textStyle: TextStyle(fontSize: screenHeight*0.04, color: selectedIndex!=0? Colors.grey.shade800:Colors.black)
        ),
        MenuItem(
            title: '   Moon',
            image: Image.asset(
              Assets.iconsMoon,
              height: screenHeight*0.07,
              width: screenHeight*0.07,
            ),
            textStyle: TextStyle(fontSize: screenHeight*0.04,color: selectedIndex!=1? Colors.grey.shade800:Colors.black)
        ),
        MenuItem(
            title: '   Mars',
            image: Image.asset(
              Assets.iconsMars,
              height: screenHeight*0.07,
              width: screenHeight*0.07,
            ),
            textStyle: TextStyle(fontSize: screenHeight*0.04, color: selectedIndex!=2? Colors.grey.shade800:Colors.black)
        ),

       /* // MenuItem(
        //     title: 'Home',
        //     textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
        //     image: Icon(
        //       Icons.home,
        //       color: Colors.white,
        //     )),
        // MenuItem(
        //     title: 'Mail',
        //     image: Icon(
        //       Icons.mail,
        //       color: Colors.white,
        //     )),
        // MenuItem(
        //     title: 'Power',
        //     image: Icon(
        //       Icons.power,
        //       color: Colors.white,
        //     )),
        // MenuItem(
        //     title: 'Setting',
        //     image: Icon(
        //       Icons.settings,
        //       color: Colors.white,
        //     )),
        // MenuItem(
        //     title: 'PopupMenu',
        //     image: Icon(
        //       Icons.menu,
        //       color: Colors.white
        //     ))*/
      ],
      onClickMenu: (MenuItemProvider item){
        String label = item.menuTitle.toLowerCase().trim();
        print(label);
        switch(label)
            {
          case "earth":
            {
              print(" earth");
              selectedIndex = 0;
              if (!connectionClient.isConnected.value) {
                retryConnectionOrShowError();
                return;
              }
              else {
                runPlanetKml(selectedIndex);
              }
              break;
            }
          case "moon":
            {
              print(" moon");
              selectedIndex = 1;
              if (!connectionClient.isConnected.value) {
                retryConnectionOrShowError();
                return;
              }
              else {
                runPlanetKml(selectedIndex);
              }
              break;
            }
          case "mars":
            {
              print(" mars");
              selectedIndex = 2;
              if (!connectionClient.isConnected.value) {
                retryConnectionOrShowError();
                return;
              }
              else {
                runPlanetKml(selectedIndex);
              }
              break;
            }
        }
      }
    );
    menu.show(widgetKey: key);
  }

  void runPlanetKml(int index) async {
    var success = await connectionClient.changePlanet(index);
    print(success);
    if(!success)
      {
        if (!Get.isSnackbarOpen) {
          Get.showSnackbar(GetSnackBar(
            backgroundColor: Colors.red.shade300,
            title: "Command Failed",
            message: "Planet could not be changed due to an unknown error.",
            isDismissible: true,
            duration: 3.seconds,
          ));
        }
      }
  }
}
