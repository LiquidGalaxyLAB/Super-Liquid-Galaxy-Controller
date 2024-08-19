import 'dart:developer' as developer;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:super_liquid_galaxy_controller/components/navisland.dart';
import 'package:super_liquid_galaxy_controller/components/planet_selector.dart';
import 'package:super_liquid_galaxy_controller/controllers/api_manager.dart';
import 'package:super_liquid_galaxy_controller/controllers/lg_connection.dart';
import 'package:super_liquid_galaxy_controller/controllers/showcase_controller.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';
import 'package:super_liquid_galaxy_controller/screens/settings.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';

import '../components/connection_flag.dart';
import '../components/custom_dialog.dart';
import '../components/glassbox.dart';
import '../utils/constants.dart';

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
  late ShowcaseController showcaseController;
  GlobalKey widgetKey = GlobalKey();
  int selectedIndex = 0;
  TextEditingController keyController = TextEditingController();

  // late TutorialCoachMark tutorialCoachMark;
  final _key1 = GlobalKey();
  final _key2 = GlobalKey();
  final _key3 = GlobalKey();

  @override
  void initState() {
    super.initState();
    log("ui", "dashboard-built");
    initializeLGClient();
    initializeApiClient();
    showcaseController = Get.find();
    /*createTutorial();
    Future.delayed(Duration.zero, showTutorial);*/
    //askForTutorial();
    if (showcaseController.isFirstLaunchDashboard()) {
      Future.delayed(Duration.zero, askForTutorial);
    }
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
                      /*Image.network(getPlanetLink(selectedIndex),
                        height: screenHeight,
                        width: screenWidth,
                        fit: BoxFit.cover,
                      loadingBuilder: (context,Widget widget,ImageChunkEvent? loadingProgress){
                        if (loadingProgress == null) return widget;
                        print(loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null);
                      //print((loader!.cumulativeBytesLoaded /loader.expectedTotalBytes!));
                      return Image.asset(getPlanetAssetLink(selectedIndex),
                          height: screenHeight,
                          width: screenWidth,
                          fit: BoxFit.cover);
                      },

                    ),*/
                      CachedNetworkImage(
                        imageUrl: getPlanetLink(selectedIndex),
                        placeholder: (context, str) {
                          //print("blah");
                          return Image.asset(getPlanetAssetLink(selectedIndex),
                              height: screenHeight,
                              width: screenWidth,
                              fit: BoxFit.cover);
                        },
                        height: screenHeight,
                        width: screenWidth,
                        fit: BoxFit.cover,
                        /*progressIndicatorBuilder:
                          (context, widget, DownloadProgress? progress) {
                        return Image.asset(getPlanetAssetLink(selectedIndex),
                            height: screenHeight,
                            width: screenWidth,
                            fit: BoxFit.cover);
                      },*/
                      )
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
                                      vertical: 12.0, horizontal: 8.0),
                                  child: GlassBox(
                                      height: screenHeight * 0.05,
                                      width: screenHeight * 0.05,
                                      child: Icon(
                                        Icons.info_outline,
                                        size: screenHeight * 0.045,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        WidgetsBinding.instance.addPostFrameCallback(
                                              (_) => ShowCaseWidget.of(context).startShowCase(
                                            [_key1, _key2, _key3],
                                          ),
                                        );
                                      })),
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
                                              ),
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
                                child: Showcase(
                                  key: _key2,
                                  description:
                                      'This takes you to Settings where you can provide all necessary credentials.',
                                  descTextStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  child: GlassBox(
                                    height: screenHeight * 0.1,
                                    width: screenHeight * 0.1,
                                    child: Icon(
                                      Icons.settings,
                                      size: screenHeight * 0.07,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      log("gesture", "settings tapped");
                                      //var out = await checkCredentials();
                                      /*if (!out.isPassWordGuarded) {
                                        await Get.to(() => Settings());
                                      } else {*/
                                      /*keyController.clear();
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

                                      if (result.compareTo(out.password) == 0) {*/
                                      Get.to(() => Settings());

                                      /*} else {
                                        if (!(result.compareTo('') == 0)) {
                                          showErrorSnackBar();
                                        }
                                      }*/
                                      //}
                                    },
                                  ),
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
                            Showcase(
                                key: _key1,
                                description:
                                    'You can use this to change the primary Planet to: Earth, Mars, Moon',
                                descTextStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                child: PlanetSelector(
                                  key: widgetKey,
                                  height: screenHeight * 0.2,
                                  width: screenWidth * 0.4,
                                  planetName: getPlanetName(selectedIndex),
                                  onPressed: () {
                                    menu(widgetKey);
                                  },
                                ))
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
                        child: Showcase(
                          key: _key3,
                          description:
                              'This is the Navigation Island to access all the various features.',
                          descTextStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          child: NavIsland(
                            height: screenHeight * 0.6,
                            width: screenWidth * 0.3,
                            changePlanet: () async {
                              print(" earth");
                              //selectedIndex = 0;
                              if (!connectionClient.isConnected.value) {
                                retryConnectionOrShowError();
                                return;
                              } else {
                                runPlanetKml(0);
                              }
                            },
                            getPlanet: () {
                              return selectedIndex;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  /*Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: screenHeight * 0.4,
                      width: screenWidth * 0.1,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: InkWell(
                                      onTap: () {
                                        testRun(Constants.noneKML);
                                      },
                                      child: Text(
                                        "1",
                                        style: TextStyle(color: Colors.white),
                                      )))),
                          Divider(color: Colors.white),
                          Expanded(
                              child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: InkWell(
                                      onTap: () {
                                        testRun(Constants.clampKML);
                                      },
                                      child: Text(
                                        "2",
                                        style: TextStyle(color: Colors.white),
                                      )))),
                          Divider(color: Colors.white),
                          Expanded(
                              child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: InkWell(
                                      onTap: () {
                                        testRun(Constants.relativeKML);
                                      },
                                      child: Text(
                                        "3",
                                        style: TextStyle(color: Colors.white),
                                      )))),
                          Divider(color: Colors.white),
                          Expanded(
                              child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: InkWell(
                                      onTap: () async {
                                        testRun(TestKML.laveFlow);
                                        MapPosition position = MapPosition(
                                            latitude: 28.65665656297236,
                                            longitude: -17.885454520583153,
                                            bearing: 61.403038024902344,
                                            tilt: 41.82725143432617,
                                            zoom: 591657550.500000 /
                                                pow(2, 13.15393352508545));
                                        await connectionClient.moveTo(
                                            position);
                                      },
                                      child: Text(
                                        "4",
                                        style: TextStyle(color: Colors.white),
                                      )))),
                        ],
                      ),
                    ),
                  ),
                )*/
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
            itemWidth: screenWidth * 0.3,
            itemHeight: screenHeight * 0.1,
            backgroundColor: Colors.white.withOpacity(0.5),
            lineColor: Colors.grey,
            maxColumn: 1,
            highlightColor: Colors.black),
        items: [
          MenuItem(
              title: '   Earth',
              image: Image.asset(
                Assets.iconsEarth,
                height: screenHeight * 0.07,
                width: screenHeight * 0.07,
              ),
              textStyle: TextStyle(
                  fontSize: screenHeight * 0.04,
                  color: selectedIndex != 0
                      ? Colors.grey.shade800
                      : Colors.black)),
          MenuItem(
              title: '   Moon',
              image: Image.asset(
                Assets.iconsMoon,
                height: screenHeight * 0.07,
                width: screenHeight * 0.07,
              ),
              textStyle: TextStyle(
                  fontSize: screenHeight * 0.04,
                  color: selectedIndex != 1
                      ? Colors.grey.shade800
                      : Colors.black)),
          MenuItem(
              title: '   Mars',
              image: Image.asset(
                Assets.iconsMars,
                height: screenHeight * 0.07,
                width: screenHeight * 0.07,
              ),
              textStyle: TextStyle(
                  fontSize: screenHeight * 0.04,
                  color: selectedIndex != 2
                      ? Colors.grey.shade800
                      : Colors.black)),

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
        onClickMenu: (MenuItemProvider item) {
          String label = item.menuTitle.toLowerCase().trim();
          print(label);
          switch (label) {
            case "earth":
              {
                print(" earth");
                //selectedIndex = 0;
                if (!connectionClient.isConnected.value) {
                  retryConnectionOrShowError();
                  return;
                } else {
                  runPlanetKml(0);
                }
                break;
              }
            case "moon":
              {
                print(" moon");
                //selectedIndex = 1;
                if (!connectionClient.isConnected.value) {
                  retryConnectionOrShowError();
                  return;
                } else {
                  runPlanetKml(1);
                }
                break;
              }
            case "mars":
              {
                print(" mars");
                //selectedIndex = 2;
                if (!connectionClient.isConnected.value) {
                  retryConnectionOrShowError();
                  return;
                } else {
                  runPlanetKml(2);
                }
                break;
              }
          }
        });
    menu.show(widgetKey: key);
  }

  void runPlanetKml(int index) async {
    await connectionClient.clearKml();
    var success = await connectionClient.changePlanet(index);
    print(success);
    if (!success) {
      if (!Get.isSnackbarOpen) {
        Get.showSnackbar(GetSnackBar(
          backgroundColor: Colors.red.shade300,
          title: "Command Failed",
          message: "Planet could not be changed due to an unknown error.",
          isDismissible: true,
          duration: 3.seconds,
        ));
      }
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  String getPlanetName(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        {
          return "EARTH";
        }
      case 1:
        {
          return "MOON";
        }
      case 2:
        {
          return "MARS";
        }
      default:
        {
          return "EARTH";
        }
    }
  }

  String getPlanetLink(int selectedIndex) {
    if (selectedIndex == 0) {
      return Constants.earthGif;
    } else if (selectedIndex == 1) {
      return Constants.moonGif;
    } else {
      return Constants.marsGif;
    }
  }

  String getPlanetAssetLink(int selectedIndex) {
    if (selectedIndex == 0) {
      return Assets.iconsEarthImg;
    } else if (selectedIndex == 1) {
      return Assets.iconsMoonImg;
    } else {
      return Assets.iconsMarsImg;
    }
  }

  void askForTutorial() async {
    print("here");
    var dialog = CustomDialog(
        content: FittedBox(
          fit: BoxFit.contain,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  showcaseController.clearTutorialNeeds();
                  Get.back();
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        " No ",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    )),
              ),
              SizedBox(width: 25.0),
              InkWell(
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => ShowCaseWidget.of(context).startShowCase(
                      [_key1, _key2, _key3],
                    ),
                  );
                  Get.back();
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Sure",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    )),
              ),
            ],
          ),
        ),
        title: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
              padding: EdgeInsets.all(25.0),
              child: Text(
                "Would you Like to be shown \na tutorial of the app?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                ),
              )),
        ),
        firstColor: Colors.grey,
        secondColor: Colors.white,
        headerIcon: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(Assets.iconsTutorial, width: 150.0, height: 150.0),
        ));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print("here2");
        return dialog;
      },
    );
  }
}

/*Future<void> testRun(String kml) async {
    await connectionClient.connectToLG();
    File? file = await connectionClient.makeFile("TEST", kml);
    print("made successfully");
    await connectionClient.kmlFileUpload(file!, "TEST");
    print("uploaded successfully");
    await connectionClient.runKml("TEST");
    print("ran kml successfully");


    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.green.shade300,
      title: "Done.",
      message: "KML was uploaded.",
      isDismissible: true,
      duration: 5.seconds,
    ));
  }*/

/*void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation2",
        keyTarget: _key1,
        alignSkip: Alignment.bottomRight,
        contents: [
          TargetContent(
            align: ContentAlignz,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation2",
        keyTarget: _key2,
        alignSkip: Alignment.bottomRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation2",
        keyTarget: _key3,
        alignSkip: Alignment.bottomRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }*/
