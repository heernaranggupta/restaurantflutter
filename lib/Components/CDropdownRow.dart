import 'package:flutter/material.dart';

import '../constants.dart';
import 'CIconData.dart';
import 'CText.dart';

class CDropdownRow extends StatelessWidget {
  final String title;
  final int codePoint;
  final Function onTap;
  final bool isExpanded;
  final double iconSize;
  final String fontFamily;

  CDropdownRow({
    this.title,
    this.onTap,
    this.isExpanded,
    this.iconSize = 20,
    @required this.codePoint,
    @required this.fontFamily,
  });
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CIconData(
              codePoint: codePoint, fontFamily: fontFamily, iconSize: iconSize),
          SizedBox(width: mediaQuery.width * 0.03),
          Expanded(child: CText(text: title)),
          Icon(
            isExpanded ? Icons.arrow_drop_down : Icons.arrow_drop_up,
            color: fontColor,
            size: 35,
          ),
        ],
      ),
    );
  }
}
