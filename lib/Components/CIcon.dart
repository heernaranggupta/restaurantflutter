import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CIcon extends StatelessWidget {
  final double iconSize;
  final IconData icon;

  CIcon({this.iconSize, this.icon = CupertinoIcons.add_circled_solid});
  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: iconSize ?? 24,
      color: fontColor,
    );
  }
}
