import 'package:flutter/material.dart';

import 'test_page.dart';
import 'components/display.dart';
import 'components/keyboard.dart';
import 'utils/screen_adapter.dart';

class CalcPage extends StatelessWidget {
  final BackgroundColor = Color(0xFF54526A);

  @override
  Widget build(BuildContext context) {
    var body = Container(
        color: BackgroundColor,
        alignment: AlignmentDirectional.topCenter,
        child: Column(
          children: [
            SizedBox(height: 8),
            Display(),
            SizedBox(height: 8),
            Keyboard(),
          ],
        ));
    return Scaffold(body: body);
  }
}

class CalcApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.update(context);
    return MaterialApp(home: CalcPage());
  }
}
