import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CLoadingIndicator extends StatelessWidget {
  final Color backgroundColor;

  CLoadingIndicator({this.backgroundColor = appColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: CupertinoActivityIndicator(radius: 15),
      ),
    );
  }
}
