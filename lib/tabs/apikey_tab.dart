import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/components/apimanager_block.dart';
import 'package:url_launcher/url_launcher.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class ApiKeyTab extends StatefulWidget {
  const ApiKeyTab({super.key});

  @override
  State<ApiKeyTab> createState() => _ApiKeyTabState();
}

class _ApiKeyTabState extends State<ApiKeyTab> with AutomaticKeepAliveClientMixin{
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
            ApiManagerBlock(
              description:
                  "This API is used by the App to dynamically fetch a huge list of recommended of POIs to explore.",
              title: "Geo-Apify Places API",
              urlDesc1: "GeoApify | Places API Playground ",
              urlDesc2: "GeoApify | Create API KEY ",
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              urlLauncher1:() {
                launchUrlFromLink(
                    Uri.parse(
                        "https://apidocs.geoapify.com/playground/places/"));
              },
              urlLauncher2:(){ launchUrlFromLink(
                  Uri.parse("https://myprojects.geoapify.com/projects"));},
              keyController: TextEditingController(),
            ),
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
    } catch (e) {
      print("$url:  $e");
    }
  }

  @override
  bool get wantKeepAlive => true;
}
