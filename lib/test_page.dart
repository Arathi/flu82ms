import 'package:flutter/material.dart';

import 'utils/screen_adapter.dart';

class ColorBlock extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const ColorBlock(this.width, this.height, {super.key, this.color = Colors.red});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(color: color),
    );
  }
}

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.update(context);

    double rpxSize = 200;
    var dpSize = rpx(rpxSize);

    return Scaffold(
      body: Flex(direction: Axis.vertical,
    children: [
      Text("100dp*100dp"),
      ColorBlock(100, 100),
      Text("${rpxSize}rpx*${rpxSize}rpx (${dpSize}dp*${dpSize}dp)"),
      ColorBlock(dpSize, dpSize),
    ],)
    );
  }
}
