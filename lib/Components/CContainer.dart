import 'package:flutter/material.dart';

import 'package:orderingsystem/constants.dart';

class CContainer extends StatelessWidget {
  final double width;
  final Widget child;
  final double height;
  final BoxBorder border;
  final bool isBoxShadow;
  final Alignment alignment;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry borderRadius;

  CContainer({
    this.width,
    this.border,
    this.borderRadius,
    this.height = 55.0,
    @required this.child,
    this.isBoxShadow = true,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.backgroundColor = appColor,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        border: border,
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: isBoxShadow ? boxShadow : null,
      ),
      child: child,
      alignment: alignment,
    );
  }
}
