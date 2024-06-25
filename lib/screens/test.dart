import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_liquid_galaxy_controller/utils/speech_controller.dart';

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
    speechController = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          controller.text = speechController.wordsString.value;
          return TextField(
            controller: controller,
          );
        }),
      ),
      floatingActionButton: Material(
        color: Colors.transparent,
        child: InkWell(
          onTapUp: (TapUpDetails tapdetails) {
            print('up: ${tapdetails.kind}');
            speechController.stopListening();
          },
          onTapDown: (TapDownDetails details) {
            print('down: ${details.kind}');
            speechController.startListening();
          },
          onTapCancel: () {
            print('cancel');
            speechController.stopListening();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.mic,
                size: 45,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
