import 'package:flutter/material.dart';

import '../generated/assets.dart';
class TrayButton extends StatelessWidget {
  TrayButton({super.key,required this.text,required this.icon,required this.color,required this.iconSize,this.action});


  String text;
  String icon;
  Color color;
  double iconSize;
  VoidCallback? action;


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: action,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageIcon(
                AssetImage(
                  icon,
                ),
                size: iconSize,
                color: color,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
