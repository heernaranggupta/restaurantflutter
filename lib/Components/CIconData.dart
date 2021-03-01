import 'package:flutter/material.dart';

class CIconData extends StatelessWidget {
  final int codePoint;
  final String fontFamily;
  final double iconSize;
  final Color color;

  CIconData({
    @required this.codePoint,
    @required this.fontFamily,
    this.iconSize = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      IconData(codePoint, fontFamily: fontFamily),
      size: iconSize,
      color: color,
    );
  }
}
