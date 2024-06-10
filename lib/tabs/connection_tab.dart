import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/components/galaxytextfield.dart';
import 'package:super_liquid_galaxy_controller/generated/assets.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_liquid_galaxy_controller/utils/lg_connection.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals

class ConnectionTab extends StatefulWidget {
  const ConnectionTab({super.key});

  @override
  State<ConnectionTab> createState() => _ConnectionTabState();
}

class _ConnectionTabState extends State<ConnectionTab> {

  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController ipController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController rigController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.05,
            horizontal: MediaQuery.of(context).size.height * 0.25),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            GalaxyTextField(
              hintText: "eg. lg",
              labelText: "Username",
              iconData: Icons.person,
              textInputType: TextInputType.text,
              isPassword: false,
              controller: userController,
            ),
            GalaxyTextField(
              hintText: "eg. lg",
              labelText: "Password",
              iconData: Icons.lock_outline_rounded,
              textInputType: TextInputType.text,
              isPassword: true,
              controller: passController,
            ),
            GalaxyTextField(
              hintText: "eg. 192.158.1.38",
              labelText: "IP Address",
              iconData: Icons.router,
              textInputType: TextInputType.number,
              isPassword: false,
              controller: ipController,
            ),
            GalaxyTextField(
              hintText: "eg. 24",
              labelText: "Port",
              iconData: Icons.wifi,
              textInputType: TextInputType.number,
              isPassword: false,
              controller: portController,
            ),

            GalaxyTextField(
              hintText: "eg. 3",
              labelText: "Number of screens",
              iconData: Icons.tv_rounded,
              textInputType: TextInputType.number,
              isPassword: false,
              controller: rigController,
            ),

            SizedBox(height: 20.0 ,),
            MaterialButton(
              color: GalaxyColors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              onPressed: () async {
                await formSubmitted();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.wifi_tethering,size: 30,color: Colors.white,),
                    SizedBox(width: 10.0),
                    Text("CONNECT LG",style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Future<void> formSubmitted() async {
    print("before");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('ip', ipController.text);
    await preferences.setString('pass', passController.text);
    await preferences.setString('port', portController.text);
    await preferences.setString('username', userController.text);
    await preferences.setString('number_of_rigs', rigController.text);
    print("clicked");
    var lgConnection = LGConnection.instance;
    //await lgConnection.connectToLG();

        Dialog dialog = lgConnection.connectStatus()? (Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)), //this right here
          child: Container(
            height: 300.0,
            width: 300.0,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Lottie.asset(Assets.lottieConnected,decoder: customDecoder,repeat: false),

              ],
            ),
          ),
        )):(Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)), //this right here
          child: Container(
            height: 300.0,
            width: 300.0,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Lottie.asset(Assets.lottieFailedconnection,decoder: customDecoder,repeat: false),

              ],
            ),
          ),
        )
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return dialog;
          },
        );

  }

  Future<LottieComposition?> customDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(bytes, filePicker: (files) {
      return files.firstWhere(
              (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    });
  }
}
