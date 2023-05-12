import 'package:flutter/material.dart';

class ScreenAdapter {
  static const rpxWidthMax = 750;

  static ScreenAdapter? _instance;

  MediaQueryData mediaQueryData;
  double get width => mediaQueryData.size.width;
  double get height => mediaQueryData.size.height;
  double get rpxRate => width / rpxWidthMax;
  double get vwRate => width / 100;
  double get vhRate => height / 100;

  static ScreenAdapter getInstance() {
    _instance ??= ScreenAdapter(MediaQueryData());
    return _instance!;
  }
  
  static void update(BuildContext context) {
    getInstance().updateByContext(context);
  }

  ScreenAdapter(this.mediaQueryData);

  void updateByContext(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
  }

  double rpxToDp(double size) => size * rpxRate;
  double vwToDp(double size) => size * vwRate;
  double vhToDp(double size) => size * vhRate;
}

double rpx(double size) => ScreenAdapter.getInstance().rpxToDp(size);
double vw(double size) => ScreenAdapter.getInstance().vwToDp(size);
double vh(double size) => ScreenAdapter.getInstance().vhToDp(size);
