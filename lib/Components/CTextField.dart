import 'package:flutter/material.dart';

import '../constants.dart';

class CTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget leading;
  final int maxLines;

  CTextField({
    @required this.controller,
    this.hintText,
    this.leading,
    this.maxLines = 1,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      cursorColor: fontColor,
      decoration: InputDecoration(
        icon: leading ?? null,
        border: InputBorder.none,
        hintText: hintText ?? '',
        hintStyle: TextStyle(color: fontColor.withOpacity(0.5)),
      ),
      textCapitalization: TextCapitalization.words,
    );
  }
}
