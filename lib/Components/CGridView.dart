import 'package:flutter/material.dart';
import 'package:orderingsystem/Components/CContainer.dart';

class CGridView extends StatelessWidget {
  final int itemCount;
  final double height;
  final EdgeInsetsGeometry padding;
  final bool isBoxShadow;
  final Widget Function(BuildContext, int) itemBuilder;
  final double width;
  final double childAspectRatio;

  CGridView({
    @required this.itemCount,
    this.padding,
    @required this.itemBuilder,
    this.height,
    this.isBoxShadow = true,
    this.width,
    this.childAspectRatio = 1 / 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      shrinkWrap: true,
      itemCount: itemCount,
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 95,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemBuilder: itemBuilder,
    );
  }
}
