import 'package:flutter/material.dart';

import '../utils/screen_adapter.dart';

class Display extends StatelessWidget {
  final Color backgroundColor = const Color(0xFFD6DFE4);

  late double width;
  late double height;

  Display({this.width = 700, double? height, super.key}) {
    if (height == null) {
      this.height = width / 3;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: rpx(width),
      height: rpx(height),
      child: Container(
        color: backgroundColor,
      ),
    );
  }
}