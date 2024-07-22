import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/data_class/kml_element.dart';
import 'package:super_liquid_galaxy_controller/data_class/map_position.dart';
import 'package:super_liquid_galaxy_controller/screens/map_kml_fullscreen.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';
import 'package:super_liquid_galaxy_controller/controllers/map_movement_controller.dart';

class Mapkmlelement extends StatefulWidget {
  Mapkmlelement(
      {super.key,
      required this.position,
      required this.mapMovementController,
      required this.elementIndex,
      required this.handlerCallback(CallbackHandler handler),
      required this.submitData,
      this.hideFullScreen});

  MapPosition position;
  MapMovementController mapMovementController;
  int elementIndex;
  final Function handlerCallback;
  Function(KmlElement) submitData;
  bool? hideFullScreen;

  @override
  State<Mapkmlelement> createState() => _MapkmlelementState();
}

class _MapkmlelementState extends State<Mapkmlelement> {
  List<LatLng> points = [];
  Set<Marker> markers = {};
  List<Polyline> polyline = [];
  List<Polygon> polygon = [];

  @override
  void initState() {
    CallbackHandler handler = CallbackHandler();
    handler.callBack = this.resetData;
    widget.handlerCallback(handler);
    resetData(widget.elementIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GoogleMap(
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          new Factory<OneSequenceGestureRecognizer>(
            () => new EagerGestureRecognizer(),
          ),
        },
        minMaxZoomPreference: MinMaxZoomPreference.unbounded,
        mapToolbarEnabled: true,
        tiltGesturesEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        compassEnabled: false,
        markers: markers,
        polylines: widget.elementIndex == 1 ? polyline.toSet() : {},
        polygons: widget.elementIndex == 2 ? polygon.toSet() : {},
        mapType: MapType.hybrid,
        initialCameraPosition: widget.position.toCameraPosition(),
        onMapCreated: widget.mapMovementController.onMapCreated,
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialButton(
                onPressed: () {
                  widget.submitData(KmlElement(
                      index: widget.elementIndex,
                      elementData: getElementData(widget.elementIndex)));
                },
                color: Colors.black.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(width: 1.0)),
                child: const Row(
                  children: [
                    Icon(
                      Icons.save_alt_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "SUBMIT DATA",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              Visibility(
                visible: widget.elementIndex != 0,
                child: MaterialButton(
                  onPressed: () {
                    addPoint();
                  },
                  color: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(width: 1.0)),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add_location_alt_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        "ADD POINT",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Visibility(
        visible: !(widget.hideFullScreen ?? false),
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () async {
                print("runs");
                var kmlElement = await Get.to(() => MapKmlFullscreen(
                    position: widget.position,
                    mapMovementController: widget.mapMovementController,
                    elementIndex: widget.elementIndex,
                    submitData: widget.submitData));
                widget.submitData(kmlElement);
              },
              icon: const Icon(
                Icons.fullscreen_rounded,
                color: Colors.white,
                size: 50.0,
              ),
            ),
          ),
        ),
      )
    ]);
  }

  void calculateMarkers() {
    markers.clear();
    for (final (index, coords) in points.indexed) {
      markers.add(Marker(
          markerId: MarkerId("marker${index}"),
          position: coords,
          draggable: true,
          onDragEnd: (LatLng location) {
            setState(() {
              points[index] = LatLng(location.latitude, location.longitude);
              calculateMarkers();
              polyline.clear();
              polygon.clear();
              reloadMap();
            });
          }));
    }
  }

  Polyline calculatePolyLine() {
    return Polyline(
      polylineId: PolylineId("polyline${Random.secure()}"),
      color: GalaxyColors.blue,
      points: points,
    );
  }

  Polygon calculatePolygon() {
    return Polygon(
      polygonId: PolygonId("polygon${Random.secure()}"),
      fillColor: GalaxyColors.blue,
      strokeColor: GalaxyColors.darkBlue,
      points: points,
    );
  }

  void reloadMap() {
    setState(() {
      points.add(LatLng(points[points.length - 1].latitude + 1,
          points[points.length - 1].longitude + 1));
      calculateMarkers();
      polyline.clear();
      polygon.clear();
      polyline.add(calculatePolyLine());
      polygon.add(calculatePolygon());
    });

    setState(() {
      points.removeLast();
      calculateMarkers();
      polyline.clear();
      polygon.clear();
      polyline.add(calculatePolyLine());
      polygon.add(calculatePolygon());
    });
  }

  void addPoint() {
    setState(() {
      points.add(LatLng(points[points.length - 1].latitude + 3,
          points[points.length - 1].longitude + 2));
      calculateMarkers();
      polyline.clear();
      polygon.clear();
      polyline.add(calculatePolyLine());
      polygon.add(calculatePolygon());
    });
    print(points);
  }

  resetData(int idx) {
    print("resetData");
    points.clear();
    points.add(widget.position.toLatLng());
    widget.elementIndex=idx;
    if (idx == 1) {
      var p1 = widget.position.toLatLng();
      p1 = LatLng(p1.latitude, p1.longitude + 2);
      points.add(p1);
    } else if (idx == 2) {
      var p1 = widget.position.toLatLng();
      p1 = LatLng(p1.latitude, p1.longitude + 2);
      points.add(p1);
      var p2 = widget.position.toLatLng();
      p2 = LatLng(p1.latitude + 1, p1.longitude);
      points.add(p2);
    }
    calculateMarkers();
    polyline.clear();
    polygon.clear();
    polyline.add(calculatePolyLine());
    polygon.add(calculatePolygon());
    setState(() {
      reloadMap();
      print(points);
    });
  }

  getElementData(int elementIndex) {
    switch (elementIndex) {
      case 0:
        {
          return Placemark(
              coordinate: Coordinates(
                  latitude: points[0].latitude, longitude: points[0].longitude),
              label: "marker",
              description: "from map");
        }
      case 1:
        {
          return LineString(
              label: "poly-line",
              description: "from map",
              coordinates: getCoordinateList(points));
        }
      case 2:
        {
          return PolyGon(
              label: "poly-gon",
              description: "from map",
              coordinates: getCoordinateList(points),
              color: 'ffffff');
        }
      default:
        {
          return Placemark(
              coordinate: Coordinates(
                  latitude: points[0].latitude, longitude: points[0].longitude),
              label: "marker",
              description: "from map");
        }
    }
  }

  List<Coordinates> getCoordinateList(List<LatLng> pointsList) {
    List<Coordinates> list = [];
    for (final coords in pointsList) {
      list.add(
          Coordinates(latitude: coords.latitude, longitude: coords.longitude));
    }
    return list;
  }
}

class CallbackHandler {
  Function? callBack;
}
