import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/components/galaxytextfield.dart';
import 'package:url_launcher/url_launcher.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class ApiKeyTab extends StatefulWidget {
  const ApiKeyTab({super.key});

  @override
  State<ApiKeyTab> createState() => _ApiKeyTabState();
}

class _ApiKeyTabState extends State<ApiKeyTab> {
  late double screenHeight;
  late double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.05, horizontal: screenHeight * 0.15),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        height: screenHeight * 0.54,
                        width: screenWidth * 0.9,
                        child: Stack(children: [
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.1)),
                                borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.white.withOpacity(0.1)
                                ])),
                          ),
                          Center(
                              child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Geo-Apify Places API",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 35,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.2),
                                        child: Divider(
                                          color: Colors.white.withOpacity(0.8),
                                          thickness: 1.2,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        "This API is used by the App to dynamically fetch a huge list of recommended of POIs to explore.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.4),
                                          border: Border.all(
                                              color: Colors.white
                                                  .withOpacity(0.1)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius: BorderRadius.circular(10),
                                                  splashColor: Colors.blue.withOpacity(0.3),
                                                  onTap: (){
                                                    launchUrlFromLink(Uri.parse("https://apidocs.geoapify.com/playground/places/"));
                                                  },
                                                  child: Text(
                                                    "GeoApify | Places API Playground ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
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
                                                  borderRadius: BorderRadius.circular(10),
                                                  splashColor: Colors.blue.withOpacity(0.3),
                                                  onTap: (){
                                                    launchUrlFromLink(Uri.parse("https://myprojects.geoapify.com/projects"));
                                                  },
                                                  child: Text(
                                                    "GeoApify | Create API KEY ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
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
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      GalaxyTextField(
                                          hintText:
                                              "eg, ZaCELgL.0imfnc8mVLWwsAawjYr4Rx",
                                          labelText: "PLACES API-KEY",
                                          iconData: Icons.code,
                                          textInputType: TextInputType.text,
                                          isPassword: true)
                                    ],
                                  )))
                        ])))),
          ]),
        ),
      ),
    );
  }

  Future<void> launchUrlFromLink(Uri url) async {
    print("reached here $url");
    try {
      if (!await launchUrl(url)) {
        print("error + $url");
        throw Exception('Could not launch $url');
      }
    }
    catch(e){
      print("$url:  $e");
    }

  }
}
