import 'package:flutter/material.dart';
import 'package:orderingsystem/constants.dart';

class CText extends StatelessWidget {
  final String text;
  final int maxLines;
  final Color textColor;
  final double fontSize;
  final TextAlign textAlign;

  CText({
    this.fontSize,
    this.textAlign,
    this.maxLines = 1,
    @required this.text,
    this.textColor = fontColor,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? 'Text Is NULL',
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        color: textColor,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
