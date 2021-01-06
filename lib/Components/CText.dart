import 'package:flutter/material.dart';
import 'package:orderingsystem/constants.dart';

class CText extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final TextAlign textAlign;

  CText({
    @required this.text,
    this.fontSize,
    this.textColor = fontColor,
    this.textAlign,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? 'Text Is NULL',
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        fontSize: fontSize,
        color: textColor,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
