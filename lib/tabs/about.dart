import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/components/galaxy_button.dart';
import 'package:super_liquid_galaxy_controller/components/galaxytextfield.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';
import 'package:super_liquid_galaxy_controller/controllers/lg_connection.dart';
import 'package:get/get.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/custom_dialog.dart';
import '../utils/constants.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class AboutTab extends StatefulWidget {
  const AboutTab({super.key});

  @override
  State<AboutTab> createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> with AutomaticKeepAliveClientMixin {
  late double screenHeight;
  late double screenWidth;
  late LGConnection client;

  @override
  void initState() {
    super.initState();
    //initializeLGClient();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.05,
            horizontal: screenHeight * 0.05),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 30.0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 5, top: 50),
                  child: Text(
                    Constants.aboutPage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white,
                  ),
                ),
                ),*/

                Container(
                  height: screenWidth * 0.2,
                  width: screenWidth * 0.5,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(Assets.assetsAppLogo),
                  ),
                ),
               /* Builder(
                    builder: (context) => IconButton(
                        icon: ,
                        iconSize: 410,
                        onPressed: null)),*/
                SizedBox(height: screenHeight*0.02,),
                Divider(
                  thickness: 1.0,
                  color: Colors.white,
                ),
                SizedBox(height: screenHeight*0.02,),
                Container(
                  // color: Colors.white.withOpacity(0.1),
                  child: Linkify(
                    onOpen: _onOpen,
                    text: Constants.aboutAuth,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: Colors.white,
                    ),
                    linkStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  Constants.aboutLab,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: Colors.white),
                  textAlign: TextAlign.start,
                ),

                SizedBox(height: screenHeight*0.02,),

                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            launchUrlFromLink(Uri.parse(
                                'https://www.linkedin.com/in/aritra-biswas-398b95250'));
                          },
                          child: Text(
                            "LinkedIn   ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: Color.fromARGB(255, 97, 146, 245)),
                          )),
                      GestureDetector(
                          onTap: () {
                            launchUrlFromLink(Uri.parse(
                                'https://github.com/AritraBiswas9788'));
                          },
                          child: Text(
                            "|  Github  ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: Color.fromARGB(255, 97, 146, 245)),
                          )),
                      GestureDetector(
                          onTap: () {
                            launchUrlFromLink(Uri.parse(
                                'mailto:aritrabiswas9788@gmail.com'));
                          },
                          child: Text(
                            "|  E-mail",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: Color.fromARGB(255, 97, 146, 245)),
                          )),
                      /*GestureDetector(
                          onTap: () {
                            launchUrlFromLink(Uri.parse(
                                'https://yashrajbharti.github.io/portfolio/'));
                          },
                          child: Text(
                            ", Portfolio",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: Color.fromARGB(255, 97, 146, 245)),
                          )),*/
                    ]),

                SizedBox(height: screenHeight*0.02,),
                Divider(
                  thickness: 1.0,
                  color: Colors.white,
                ),
                SizedBox(height: screenHeight*0.02,),
                Container(
                  height: screenWidth * 0.5,
                  width: screenWidth * 0.8,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(Assets.assetsSlgcLogos),
                  ),
                ),
                SizedBox(height: screenHeight*0.02,),
                /*Transform.scale(
                    scale: 1.6,
                    child: Builder(
                        builder: (context) => IconButton(
                            icon: Image.asset(Assets.assetsSlgcLogos),
                            iconSize: 580,
                            onPressed: null))),*/
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05),                        child: Text(
                          Constants.aboutAll,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,

                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight*0.02,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05),
                  child: Linkify(
                    onOpen: _onOpen,
                    text: Constants.aboutPoints,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    linkStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: screenHeight*0.02,),
                Divider(
                  thickness: 1.0,
                  color: Colors.white,
                ),
                SizedBox(height: screenHeight*0.02,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              Constants.aboutLearn,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24, color:Colors.white),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                Constants.aboutCheck,
                                style: TextStyle(fontSize: 18, color:Colors.white),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                launchUrlFromLink(Uri.parse(
                                    'https://github.com/yashrajbharti/La-Palma-Volcano-Eruption-Tracking-Tool'));
                              },
                              child: Text(
                                Constants.aboutGit,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color:Colors.white),
                              ),
                            ),
                            Text(
                              '\n',
                              style: TextStyle(fontSize: 4),
                              textAlign: TextAlign.start,
                            ),
                            GestureDetector(
                              onTap: () {
                                launchUrlFromLink(Uri.parse(
                                    'https://github.com/Alexevers/Alejandro-Android-Application-Refurbishment/blob/GSOC-2022-Apps/La%20Palma%20Volcano%20Tracking%20Tool/PrivacyPolicy.md'));
                              },
                              child: Text(
                                Constants.aboutPrivacy,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color:Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),*/

                      Container(
                        //width: MediaQuery.of(context).size.width * 0.40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              Constants.aboutImg,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24, color:Colors.white),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                Constants.aboutAttr,
                                style: TextStyle(fontSize: 18, color:Colors.white),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                launchUrlFromLink(Uri.parse(
                                    'https://www.flaticon.com'));
                              },
                              child: Text(
                                "Flaticon",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color:GalaxyColors.blue),
                              ),
                            ),
                            Text(
                              '\n',
                              style: TextStyle(fontSize: 4),
                              textAlign: TextAlign.start,
                            ),
                            GestureDetector(
                              onTap: () {
                                launchUrlFromLink(Uri.parse(
                                    'https://www.geoapify.com/places-api/'));
                              },
                              child: Text(
                                "Geo-Apify",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color:GalaxyColors.blue),
                              ),
                            ),

                            Text(
                              '\n',
                              style: TextStyle(fontSize: 4),
                              textAlign: TextAlign.start,
                            ),
                            GestureDetector(
                              onTap: () {
                                launchUrlFromLink(Uri.parse(
                                    'https://en.wikipedia.org/wiki/Main_Page'));
                              },
                              child: Text(
                                "Wikipedia",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color:GalaxyColors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight*0.02,),
                Divider(
                  thickness: 1.0,
                  color: Colors.white,
                ),
                SizedBox(height: screenHeight*0.02,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            /*Text(
                              Constants.aboutLearn,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24, color:Colors.white),
                            ),*/
                            Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                Constants.aboutCheck,
                                style: TextStyle(fontSize: 18, color:Colors.white),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                launchUrlFromLink(Uri.parse(
                                    'https://github.com/LiquidGalaxyLAB/Super-Liquid-Galaxy-Controller'));
                              },
                              child: Text(
                                Constants.aboutGit,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color:GalaxyColors.blue),
                              ),
                            ),
                            Text(
                              '\n',
                              style: TextStyle(fontSize: 4),
                              textAlign: TextAlign.start,
                            ),
                            /*GestureDetector(
                              onTap: () {
                                launchUrlFromLink(Uri.parse(
                                    'https://github.com/Alexevers/Alejandro-Android-Application-Refurbishment/blob/GSOC-2022-Apps/La%20Palma%20Volcano%20Tracking%20Tool/PrivacyPolicy.md'));
                              },
                              *//*child: Text(
                                Constants.aboutPrivacy,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color:GalaxyColors.blue),
                              ),*//*
                            ),*/
                          ],
                        ),
                      ),
                      /*Container(
                        height: 160,
                        child: VerticalDivider(
                          color:Colors.white,
                          thickness: 1,
                        ),
                      ),*/
                      /*Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              Constants.aboutImg,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24, color:Colors.white),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                Constants.aboutAttr,
                                style: TextStyle(fontSize: 18, color:Colors.white),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                launchUrlFromLink(Uri.parse(
                                    'https://www.flaticon.com'));
                              },
                              child: Text(
                                "Flaticon",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color:Colors.white),
                              ),
                            ),
                            Text(
                              '\n',
                              style: TextStyle(fontSize: 4),
                              textAlign: TextAlign.start,
                            ),
                            GestureDetector(
                              onTap: () {
                                launchUrlFromLink(Uri.parse(
                                    'https://iconarchive.com/show/noto-emoji-travel-places-icons-by-google/42463-volcano-icon.html'));
                              },
                              child: Text(
                                "Icon Archive",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color:Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),*/
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void initializeLGClient() async {
    client = Get.find();
    await client.reConnectToLG();
    if (!client.connectStatus()) {
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

  showAlertMessage(String title, String content, Function action) {
    Get.dialog(
      AlertDialog(
        title: Text(title, style: TextStyle(color: Colors.red),),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text("CANCEL", style: TextStyle(color: Colors.white),),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text("CONTINUE", style: TextStyle(color: Colors.red),),
            onPressed: () async {
              await action();
              Get.back();
            },
          ),
        ],
      ),
    );
  }
  Future<void> _onOpen(LinkableElement link) async {
      await launchUrlFromLink(Uri.parse(link.url));
  }
    Future<void> launchUrlFromLink(Uri url) async {
      print("reached here $url");
      try {
        if (!await launchUrl(url)) {
          print("error + $url");
          //throw Exception('Could not launch $url');
        }
      } catch (e) {
        print("$url:  $e");
      }
    }
}
