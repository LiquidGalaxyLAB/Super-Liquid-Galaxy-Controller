import 'package:flutter/material.dart';
class NavElement extends StatelessWidget {
  NavElement({super.key, required this.path, required this.text, required this.hasDivider,this.onTap});

  final String path;
  final String text;
  final bool hasDivider;
  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(width: 15.0,),
                  ImageIcon(AssetImage(path),size: 40.0,color: Colors.white),
                  const SizedBox(width: 15.0,),
                  Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w200),
                  ),
                ],
              ),
              Visibility(
                visible: hasDivider,
                  child: const Divider(thickness: 2.0,color: Colors.white,)
              )
            ],
          ),
        ),
      ),
    );
  }
}
