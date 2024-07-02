import 'dart:ui';

import 'package:flutter/material.dart';

class GlassBox extends StatelessWidget {
  GlassBox(
      {super.key,
      required this.height,
      required this.width,
      this.child,
      this.onTap,
      this.backgroundGradient,
      this.cornerRadius});

  double height;
  double width;
  Widget? child;
  VoidCallback? onTap;
  LinearGradient? backgroundGradient;

  double? cornerRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(cornerRadius??20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(cornerRadius??20),
          child: Container(
            width: width,
            height: height,
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(cornerRadius??20),
                      gradient: backgroundGradient ??
                          LinearGradient(colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.0)
                          ])),
                ),
                Center(
                  child: child,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
