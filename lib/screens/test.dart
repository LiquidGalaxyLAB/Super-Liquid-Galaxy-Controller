import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_liquid_galaxy_controller/controllers/speech_controller.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key, required this.kml});

  final String kml;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  TextEditingController controller = TextEditingController();
  late SpeechController speechController;

  @override
  void initState() {
    //controller.text = widget.kml;
    super.initState();
    print(widget.kml);
    //speechController = Get.find();
    controller.text = widget.kml;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextField(
          controller: controller,
        ),

    ));
  }
}
