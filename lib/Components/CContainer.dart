import 'package:flutter/material.dart';

import 'package:orderingsystem/constants.dart';

class CContainer extends StatelessWidget {
  final double width;
  final Widget child;
  final double height;
  final Alignment alignment;
  final bool isBoxShadow;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;

  CContainer({
    this.width,
    this.borderRadius,
    this.height = 55.0,
    @required this.child,
    this.isBoxShadow = true,
    this.padding = EdgeInsets.zero,
    this.backgroundColor = appColor,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: isBoxShadow ? boxShadow : null,
      ),
      child: child,
      alignment: alignment,
    );
  }
}
