import 'dart:ui';

import 'package:flutter/material.dart';
class GalaxyButton extends StatelessWidget {


  GalaxyButton({super.key,required this.height,required this.width,this.onTap,this.backgroundColor,required this.actionText,required this.icon});

  double height;
  double width;
  VoidCallback? onTap;
  Color? backgroundColor;
  String actionText;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 15.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: width,
              height: height,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(20),
                        color: (backgroundColor ?? Colors.white).withOpacity(0.29)
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 35.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(actionText,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 25),),
                          Icon(icon,size: 45,color: Colors.white,)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
