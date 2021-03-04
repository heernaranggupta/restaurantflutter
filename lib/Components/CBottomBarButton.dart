import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'CText.dart';
import '../constants.dart';

class CBottomBarButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  CBottomBarButton({@required this.title, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: CupertinoButton(
          color: fontColor,
          child: CText(text: title ?? 'No Title', textColor: Colors.white),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
