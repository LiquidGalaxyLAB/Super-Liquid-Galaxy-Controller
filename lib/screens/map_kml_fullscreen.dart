import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_liquid_galaxy_controller/components/MapKmlElement.dart';
import 'package:super_liquid_galaxy_controller/data_class/kml_element.dart';

import '../data_class/map_position.dart';
import '../utils/map_movement_controller.dart';

class MapKmlFullscreen extends StatefulWidget {
  MapKmlFullscreen(
      {super.key,
      required this.position,
      required this.mapMovementController,
      required this.elementIndex,
      required this.submitData});

  MapPosition position;
  MapMovementController mapMovementController;
  int elementIndex;
  Function(KmlElement) submitData;

  @override
  State<MapKmlFullscreen> createState() => _MapKmlFullscreenState();
}

class _MapKmlFullscreenState extends State<MapKmlFullscreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.4),
        leading: BackButton(
          onPressed: () {
            Get.back(result: KmlElement(index: -1));
          },
          color: Colors.white,
        ),
      ),
      body: Mapkmlelement(
          position: widget.position,
          mapMovementController: widget.mapMovementController,
          elementIndex: widget.elementIndex,
          handlerCallback: ((handler) {
          }),
          submitData: (KmlElement element){
            Get.back(result: element);
          }),
    ));
  }
}
