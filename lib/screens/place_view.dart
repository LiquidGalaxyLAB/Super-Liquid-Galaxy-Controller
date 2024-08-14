import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_info.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';
import 'package:super_liquid_galaxy_controller/controllers/poi_controller.dart';
import '../generated/assets.dart';
import '../utils/constants.dart';

class PlaceView extends StatefulWidget {
  PlaceView({super.key, required this.place});

  PlaceInfo place;

  @override
  State<PlaceView> createState() => _PlaceViewState();
}

class _PlaceViewState extends State<PlaceView> with TickerProviderStateMixin {
  late double screenHeight;
  late double screenWidth;
  late PoiController poiController;
  late AnimationController lottieController;
  late AnimationController voiceController;
  late PlaceInfo currentPlace;


  @override
  void initState() {
    super.initState();
    poiController = Get.find();
    poiController.isOrbit.value = false;
    poiController.isVoicing.value = false;
    currentPlace = widget.place;
    poiController.setInfo(widget.place);
    poiController.fetchAllInfo();
    lottieController = AnimationController(vsync: this,duration: const Duration(seconds: 2));
    voiceController =  AnimationController(vsync: this,duration: const Duration(seconds: 2));

  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    //print(MediaQuery.of(context).size);
    return SafeArea(
        child: Stack(children: [
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Assets.assetsBackgroundspace),
              fit: BoxFit.cover),
        ),
      ),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.75, sigmaY: 0.75),
        child: Container(
          height: double.infinity,
          width: double.infinity,
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(screenHeight * 0.05,
                    screenHeight * 0.05, 0.0, screenHeight * 0.05),
                child: Container(
                  width: screenWidth * 0.675,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 15.0, 20.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      alignment: Alignment.centerLeft,
                                      child: Obx((){
                                        return Text(
                                          poiController.place.value.name,
                                          style: const TextStyle(
                                            shadows: [
                                              Shadow(
                                                  color: Colors.white,
                                                  offset: Offset(0, -8))
                                            ],
                                            color: Colors.transparent,
                                            fontSize: 40,
                                            fontWeight: FontWeight.w400,
                                            decoration: TextDecoration.underline,
                                            decorationColor: Colors.white,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                                Expanded(flex: 2, child: Container())
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.contain,
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                    child: Obx((){
                                      return Text(
                                        "ADDRESS: ${poiController.place.value.address} \nLOCATION- Lat: ${poiController.place.value.coordinate.latitude.toStringAsFixed(5)}, Long: ${poiController.place.value.coordinate.longitude.toStringAsFixed(5)}",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.w300,
                                          decorationColor: Colors.white,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 12,
                        child: Container(
                          child: Stack(children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: ShaderMask(
                                      shaderCallback: (rect) {
                                        return LinearGradient(
                                          begin: Alignment.center,
                                          end: Alignment.topCenter,
                                          stops: const [
                                            0.1,
                                            0.2,
                                            0.3,
                                            0.4,
                                            0.6,
                                            0.9
                                          ],
                                          colors: [
                                            Colors.black,
                                            Colors.black.withOpacity(0.8),
                                            Colors.black.withOpacity(0.5),
                                            Colors.black.withOpacity(0.3),
                                            Colors.black.withOpacity(0.1),
                                            Colors.transparent
                                          ],
                                        ).createShader(Rect.fromLTRB(
                                            0, 0, rect.width, rect.height));
                                      },
                                      blendMode: BlendMode.dstIn,
                                      child: Obx(() {
                                        return Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(50.0),
                                                  bottomRight:
                                                      Radius.circular(50.0)),
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: ((poiController
                                                    .imageIsLoading.value || poiController.imageLink.compareTo('')==0 )&& !poiController.imageIsError.value
                                                ? Lottie.asset(
                                                    Assets.lottieImageloading,
                                                    decoder: customDecoder,
                                                    repeat: true,
                                                    fit: BoxFit.fill)
                                                : (poiController
                                                        .imageIsError.value
                                                    ? Image.asset(
                                                        Assets.iconsImageError,
                                                        height: 400,
                                                        fit: BoxFit.contain,
                                                      )
                                                    : (Image.network(
                                                        poiController
                                                            .imageLink.value,
                                                        height: 400,
                                                        fit: BoxFit.fill,
                                                      )))));
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                    child: Container(
                                  height: screenHeight * 0.25,
                                  child: Scrollbar(
                                    thickness: 5,
                                    thumbVisibility: true,
                                    radius: const Radius.circular(20.0),
                                    child: SingleChildScrollView(child: Obx(() {
                                      print(poiController.descriptionIsLoading.value);
                                      return poiController
                                              .descriptionIsLoading.value
                                          ? const Text(
                                        "Loading....",
                                        style: TextStyle(
                                            fontSize: 35.0,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 10.0,
                                                // shadow blur
                                                color: Colors.black,
                                                // shadow color
                                                offset: Offset(2.0,
                                                    2.0), // how much shadow will be shown
                                              ),
                                            ],
                                            color: Colors.white,
                                            fontWeight:
                                            FontWeight.w300),
                                      )
                                          : (poiController
                                                  .descriptionIsError.value
                                              ? const Text(
                                                  "NO LOCATION DESCRIPTION FOUND",
                                                  style: TextStyle(
                                                      fontSize: 35.0,
                                                      shadows: [
                                                        Shadow(
                                                          blurRadius: 10.0,
                                                          // shadow blur
                                                          color: Colors.black,
                                                          // shadow color
                                                          offset: Offset(2.0,
                                                              2.0), // how much shadow will be shown
                                                        ),
                                                      ],
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                )
                                              : Text(
                                                  poiController
                                                      .description.value,
                                                  style: const TextStyle(
                                                      fontSize: 25.0,
                                                      shadows: [
                                                        Shadow(
                                                          blurRadius: 10.0,
                                                          // shadow blur
                                                          color: Colors.black,
                                                          // shadow color
                                                          offset: Offset(2.0,
                                                              2.0), // how much shadow will be shown
                                                        ),
                                                      ],
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ));
                                    })),
                                  ),
                                ))
                              ],
                            )
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: screenHeight * 0.15),
                child: const VerticalDivider(
                  color: Colors.white,
                  thickness: 3.0,
                ),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, screenHeight * 0.05,
                    screenHeight * 0.05, screenHeight * 0.05),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 30.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(20.0),
                                backgroundBlendMode: BlendMode.screen,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 25.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              image: const DecorationImage(
                                                  image: AssetImage(Assets
                                                      .assetsBackgroundspace),
                                                  fit: BoxFit.cover)),
                                          child: const FittedBox(
                                            fit: BoxFit.contain,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.0,
                                                  horizontal: 12.0),
                                              child: Text(
                                                "NEARBY POIs",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12.0, 0.0, 12.0, 20.0),
                                        child: Obx(
                                            (){
                                              print(poiController.poiList.length);
                                              return Container(
                                                child:(poiController.poiList.isNotEmpty)? ListView.builder(itemBuilder: (context,index){
                                                  return Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        Expanded(child: Material(
                                                          color: Colors.transparent,
                                                          child: InkWell(
                                                            radius: 20.0,
                                                            onTap: () async {
                                                              poiController.isOrbit.value = false;
                                                              poiController.isVoicing.value = false;
                                                              currentPlace = poiController.poiList[index];
                                                              await poiController.connectionClient.cleanBalloon();
                                                              poiController.setInfo(poiController.poiList[index]);
                                                              await poiController.fetchAllInfo();
                                                            },
                                                            child: Container(
                                                              height: screenHeight*0.07,
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.max,
                                                                children: [
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child: Container(
                                                                          child: FittedBox(
                                                                              fit: BoxFit
                                                                                  .contain,
                                                                              child:
                                                                              Padding(
                                                                                padding:
                                                                                const EdgeInsets
                                                                                    .all(
                                                                                    5.0),
                                                                                child:
                                                                                ImageIcon(
                                                                                  AssetImage(
                                                                                    Constants.tourismCategories.contains(poiController.poiList[index].category)?(Constants.assetPaths[Constants.tourismCategories.indexOf(poiController.poiList[index].category)]):Constants.assetPaths[Constants.assetPaths.length-1],                                                                              ),
                                                                                  color: Colors
                                                                                      .white,
                                                                                ),
                                                                              )))),
                                                                  Expanded(

                                                                      flex: 6,
                                                                      child: Container(
                                                                          child: FittedBox(
                                                                              fit: BoxFit
                                                                                  .contain,
                                                                              child:
                                                                              Padding(
                                                                                padding: const EdgeInsets
                                                                                    .symmetric(
                                                                                    horizontal:
                                                                                    8.0,
                                                                                    vertical:
                                                                                    5.0),
                                                                                child: Text(
                                                                                  poiController.poiList[index].name.length>12? "${poiController.poiList[index].name.substring(0,12)}...":poiController.poiList[index].name,
                                                                                  style:
                                                                                  const TextStyle(
                                                                                    color: Colors
                                                                                        .white,
                                                                                  ),
                                                                                ),
                                                                              ))))
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ))
                                                      ],
                                                    ),
                                                  );
                                                },
                                                  itemCount: poiController.poiList.length,):Center(
                                                    child: (
                                                      Lottie.asset(
                                                          Assets.lottieLoadingspinner,
                                                          decoder: customDecoder,
                                                          repeat: true,
                                                          fit: BoxFit.fill,

                                                      )
                                                                                                    ),
                                                  )
                                              );
                                            }
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: () {

                                      poiController.orbitButtonPressed();
                                    },
                                    color:
                                        GalaxyColors.darkBlue.withOpacity(0.5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Obx((){
                                                lottieController?.dispose();
                                                lottieController = AnimationController(vsync: this, duration: const Duration(seconds: 2));

                                                return (poiController.isOrbit.value?(
                                                    Lottie.asset(
                                                        Assets.lottieOrbit,
                                                        decoder: customDecoder,
                                                        repeat: true,
                                                        controller: lottieController,
                                                        fit: BoxFit.fill,
                                                        width: 25.0,
                                                        height: 25.0,
                                                      onLoaded: (c){
                                                       //lottieController.forward(from: 0.0);
                                                       lottieController.repeat();
                                                      }
                                                    )
                                                ):(const ImageIcon(
                                                  AssetImage(Assets.iconsOrbit),
                                                  size: 25.0,
                                                  color: Colors.white,
                                                )));
                                              }),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 8,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Obx((){
                                                  return Text(
                                                    poiController.isOrbit.value?"IN ORBIT":"ORBIT",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w300),
                                                  );
                                                }),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: () {
                                      poiController.voiceButtonPressed();
                                      //poiController.isVoicing.value = !poiController.isVoicing.value;
                                    },
                                    color: GalaxyColors.green.withOpacity(0.5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Obx((){
                                                  voiceController?.dispose();
                                                  voiceController = AnimationController(vsync: this,duration: const Duration(seconds: 2));
                                                  return (poiController.isVoicing.value?(
                                                      Lottie.asset(
                                                          Assets.lottieVoice,
                                                          decoder: customDecoder,
                                                          repeat: true,
                                                          controller: voiceController,
                                                          fit: BoxFit.fill,
                                                          width: 25.0,
                                                          height: 25.0,
                                                          onLoaded: (c){
                                                            //lottieController.forward(from: 0.0);
                                                            voiceController.repeat();
                                                          }
                                                      )
                                                  ):(const ImageIcon(
                                                    AssetImage(Assets.iconsVoices),
                                                    color: Colors.white,
                                                    size: 25.0,
                                                  )));
                                                }),
                                          )
                                          ),
                                          const SizedBox(
                                            width: 8.0,
                                          ),
                                          const Expanded(
                                              flex: 8,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  "VOICE EXCERPT",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: () {

                                      Get.back(result: poiController.place.value);
                                    },
                                    color: GalaxyColors.yellow.withOpacity(0.5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Icon(
                                                Icons.add_location_alt_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 8,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  "  SUBMIT DATA ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      )
    ]));
  }

  @override
  void dispose() {
    voiceController?.dispose();
    lottieController?.dispose();
    poiController.stopTTS();
    poiController.killAllProcesses();
    super.dispose();
  }

  Future<LottieComposition?> customDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(bytes, filePicker: (files) {
      return files.firstWhere(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    });
  }

}
