import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key, required this.kml});

  final String kml;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.kml;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextField(
          controller: controller,
        ),
      ),
    );
  }
}
