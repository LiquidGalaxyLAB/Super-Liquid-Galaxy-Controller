import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';

import '../data_class/map_position.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  MapPosition position = MapPosition(
    latitude: 40.7128,
    longitude: -74.0060,
    // Example: New York City
    zoom: 5,
    bearing: 45,
    // 45 degrees east of north
    tilt: 45, // City level zoom
  );
  Set<Marker> markers = {};

  @override
  void initState() {
    markers.add(Marker(
        markerId: const MarkerId("marker1"),
        draggable: true,
        position: const LatLng(40.7128, -74.0060),
        onDragEnd: (point)
        {
          position.updateFromCoordinates(Coordinates(latitude: point.latitude, longitude: point.longitude));
        }
    ));
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
        mapType: MapType.hybrid,
        initialCameraPosition: position.toCameraPosition(),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialButton(
                onPressed: () {
                  Get.back(
                      result: Coordinates(
                          latitude: position.latitude,
                          longitude: position.longitude));
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
            ],
          ),
        ),
      ),
    ]);
  }
}
