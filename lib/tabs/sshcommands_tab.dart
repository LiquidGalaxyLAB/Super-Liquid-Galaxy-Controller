import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/components/glassbox.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class SSHCommandsTab extends StatefulWidget {
  const SSHCommandsTab({super.key});

  @override
  State<SSHCommandsTab> createState() => _SSHCommandsTabState();
}

class _SSHCommandsTabState extends State<SSHCommandsTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.05,
            horizontal: MediaQuery.of(context).size.height * 0.25),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            GlassBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.4
            )
          ]),
        ),
      ),
    );
  }
}
