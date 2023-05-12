import 'package:flutter/material.dart';
import '../utils/screen_adapter.dart';

enum KeyType {
  // 第一行按钮，圆角
  firstLine,

  // 方向按钮，圆形
  aspect,

  // 功能按钮
  functions,

  // 常规按钮
  normals,
}

class Key extends StatelessWidget {
  static const Color colorShift = Color(0xFF9B8C6F);
  static const Color colorAlpha = Color(0xFFAA6D7F);
  static const Color colorFirstLine = Color(0xFFACA8C3);

  final KeyType type;
  final String primary;
  final String? shift;
  final String? alpha;
  final double? width;

  // DEL和AC键是普通按钮，但有特殊的红色背景
  final Color? color;

  // 比如加减乘除等按钮，按钮主功能文本有放大倍数
  final double primarySizeScale;

  Color get buttonColor {
    if (type == KeyType.firstLine) {
      return const Color(0xFFC1BFCD);
    }
    if (type == KeyType.functions) {
      return const Color(0xFF322D41);
    }
    if (type == KeyType.normals && color != null) {
      return color!;
    }
    return const Color(0xFF9592A5);
  }

  double get widthDp {
    double widthRpx = 0;
    if (width != null) {
      widthRpx = width!;
    } else if (type == KeyType.normals) {
      widthRpx = 125;
    } else if (type == KeyType.functions) {
      widthRpx = 105;
    }
    return rpx(widthRpx);
  }

  double get buttonHeightDp {
    var radio = 0.55;
    if (type == KeyType.normals) {
      radio = 0.66;
    }
    return widthDp * radio;
  }

  double get heightDp {
    // var radio = 0.5;
    // if (type == KeyType.normals) {
    //   radio += 0.66;
    // }
    // else {
    //   radio += 0.5;
    // }
    return widthDp * 1;
  }

  const Key(this.primary,
      {super.key,
      this.type = KeyType.normals,
      this.shift,
      this.alpha,
      this.color,
      this.primarySizeScale = 1,
      this.width});

  Widget buildUpper() {
    double upperFontSizeRadio = 1;
    if (type == KeyType.firstLine) {
      upperFontSizeRadio = 0.2;
    } else if (type == KeyType.functions) {
      upperFontSizeRadio = 0.275;
    } else if (type == KeyType.normals) {
      upperFontSizeRadio = 0.225;
    }

    var upperAmount = 0;
    if (primary != "" && type == KeyType.firstLine) upperAmount++;
    if (shift != null) upperAmount++;
    if (alpha != null) upperAmount++;

    var upperTexts = <Widget>[];

    if (primary != "" && type == KeyType.firstLine) {
      var width = widthDp;
      var align = TextAlign.center;
      if (upperAmount > 1) {
        width = widthDp * 0.6;
        align = TextAlign.left;
      }
      var text = Text(
        primary,
        textAlign: align,
        style: TextStyle(
            color: Key.colorFirstLine,
            decoration: TextDecoration.none,
            fontSize: widthDp * upperFontSizeRadio),
      );
      // 蓝字
      upperTexts.add(SizedBox(width: width, child: text));
    }

    if (shift != null) {
      var width = widthDp;
      var align = TextAlign.center;
      if (upperAmount > 1) {
        if (type == KeyType.firstLine && primary != "") {
          width = widthDp * 0.4;
          align = TextAlign.right;
        } else {
          width = widthDp * 0.75;
          align = TextAlign.left;
        }
      }
      var text = Text(
        shift!,
        textAlign: align,
        style: TextStyle(
            color: Key.colorShift,
            decoration: TextDecoration.none,
            fontSize: widthDp * upperFontSizeRadio),
      );
      // 黄字
      upperTexts.add(SizedBox(width: width, child: text));
    }

    if (alpha != null) {
      var width = upperAmount == 1 ? widthDp : widthDp * 0.25;
      var align = (type == KeyType.firstLine && primary == "")
          ? TextAlign.center
          : TextAlign.right;
      var text = Text(
        alpha!,
        textAlign: align,
        style: TextStyle(
            color: Key.colorAlpha,
            decoration: TextDecoration.none,
            fontSize: widthDp * upperFontSizeRadio),
      );
      // 红字
      upperTexts.add(SizedBox(width: width, child: text));
    }
    return Container(
        alignment: AlignmentDirectional.center,
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: upperTexts,
        ));
  }

  Widget buildButton() {
    double borderRadius = (type == KeyType.firstLine) ? heightDp / 2 : 5;
    var text = Text(
      (type == KeyType.firstLine) ? "" : primary,
      style: TextStyle(
          color: Colors.white,
          decoration: TextDecoration.none,
          fontSize: buttonHeightDp * 0.65),
    );

    var box = DecoratedBox(
      decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            const BoxShadow(
                color: Colors.black, offset: Offset(1, 4), blurRadius: 4)
          ]),
      child: SizedBox(
        width: widthDp,
        height: buttonHeightDp,
        child: Container(alignment: AlignmentDirectional.center, child: text),
      ),
    );

    return Container(
      width: widthDp,
      height: buttonHeightDp,
      alignment: AlignmentDirectional.center,
      child: box,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
            height: heightDp,
            // alignment: AlignmentDirectional.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildUpper(),
                buildButton(),
              ],
            )));
  }
}

class Keyboard extends StatelessWidget {
  double width;
  double buttonGutter;

  double get normalKeyWidth => (width - 4 * buttonGutter) / 5;
  double get functionKeyWidth => (width - 5 * buttonGutter) / 6;

  Keyboard({this.width = 700, this.buttonGutter = 25}) {
    print("键盘宽度：${width}rpx, 按键间隔：${buttonGutter}rpx");
    print("普通按键宽度：${normalKeyWidth}rpx, 功能按键宽度：${functionKeyWidth}rpx");
  }

  Widget buildKeys(List<Key> keys) {
    var children = <Widget>[];
    for (var index = 0; index < keys.length; index++) {
      var key = keys[index];
      children.add(key);
      if (index < keys.length - 1) {
        children.add(SizedBox(
          width: rpx(buttonGutter),
          height: 1,
        ));
      }

      // 前两行只有4个按钮，中间空两格
      if (index == 1 && keys.length == 4) {
        children.add(SizedBox(
          width: 2 * rpx(functionKeyWidth) + 2 * rpx(buttonGutter),
          height: 1,
        ));
      }
    }
    return Flex(
      direction: Axis.horizontal,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    // var firstLine = Flex(direction: Axis.vertical, children: [
    //   buildKeys(<Key>[
    //     Key(
    //       "",
    //       shift: "SHIFT",
    //       type: KeyType.firstLine,
    //       width: functionKeyWidth,
    //     ),
    //     Key(
    //       "",
    //       alpha: "ALPHA",
    //       type: KeyType.firstLine,
    //       width: functionKeyWidth,
    //     ),
    //     Key(
    //       "MODE",
    //       shift: "CLR",
    //       type: KeyType.firstLine,
    //       width: functionKeyWidth,
    //     ),
    //     Key(
    //       "ON",
    //       type: KeyType.firstLine,
    //       width: functionKeyWidth,
    //     ),
    //   ])
    // ]);

    var ttlLeftUpper = Flex(
      direction: Axis.horizontal,
      children: [
        Key(
          "",
          shift: "SHIFT",
          type: KeyType.firstLine,
          width: functionKeyWidth,
        ),
        SizedBox(
          width: rpx(buttonGutter),
          height: 1,
        ),
        Key(
          "",
          alpha: "ALPHA",
          type: KeyType.firstLine,
          width: functionKeyWidth,
        ),
      ],
    );

    var ttlRightUpper = Flex(
      direction: Axis.horizontal,
      children: [
        Key(
          "MODE",
          shift: "CLR",
          type: KeyType.firstLine,
          width: functionKeyWidth,
        ),
        SizedBox(
          width: rpx(buttonGutter),
          height: 1,
        ),
        Key(
          "ON",
          type: KeyType.firstLine,
          width: functionKeyWidth,
        ),
      ],
    );

    var ttlLeftLower = Flex(direction: Axis.horizontal, children: [
      Key(
        "x^-1",
        type: KeyType.functions,
        shift: "n!",
        width: functionKeyWidth,
      ),
      SizedBox(
        width: rpx(buttonGutter),
        height: 1,
      ),
      Key(
        "nCr",
        type: KeyType.functions,
        shift: "nPr",
        width: functionKeyWidth,
      ),
    ]);

    var ttlRightLower = Flex(direction: Axis.horizontal, children: [
      Key(
        "Pol(",
        type: KeyType.functions,
        shift: "Rec(",
        width: functionKeyWidth,
      ),
      SizedBox(
        width: rpx(buttonGutter),
        height: 1,
      ),
      Key(
        "x^3",
        type: KeyType.functions,
        shift: "x^-3",
        width: functionKeyWidth,
      ),
    ]);

    var ttlLeft = Flex(
      direction: Axis.vertical,
      children: [
        ttlLeftUpper,
        ttlLeftLower,
      ],
    );

    var ttlRight = Flex(
      direction: Axis.vertical,
      children: [
        ttlRightUpper,
        ttlRightLower,
      ],
    );

    // var ttlMiddle = Flex(
    //   direction: Axis.vertical,
    //   children: [
    //     Flex(
    //       direction: Axis.horizontal,
    //       children: [],
    //     ),
    //     Flex(
    //       direction: Axis.horizontal,
    //       children: [],
    //     ),
    //     Flex(
    //       direction: Axis.horizontal,
    //       children: [],
    //     ),
    //   ],
    // );

    // var topTwoLines = Flex(
    //   direction: Axis.horizontal,
    //   children: [
    //     ttlLeft,
    //     SizedBox(
    //       width: rpx(buttonGutter),
    //       height: 1,
    //     ),
    //     SizedBox(
    //       width: rpx(functionKeyWidth * 2 + buttonGutter),
    //       height: 1,
    //     ),
    //     SizedBox(
    //       width: rpx(buttonGutter),
    //       height: 1,
    //     ),
    //     ttlRight,
    //   ],
    // );

    var topTwoLines = Flex(
      direction: Axis.horizontal,
      children: [
        SizedBox(
          width: rpx(functionKeyWidth * 2 + buttonGutter),
          child: ttlLeft,
        ),
        SizedBox(
          width: rpx(buttonGutter),
          height: 1,
        ),
        SizedBox(
          width: rpx(functionKeyWidth * 2 + buttonGutter),
        ),
        SizedBox(
          width: rpx(buttonGutter),
          height: 1,
        ),
        SizedBox(
          width: rpx(functionKeyWidth * 2 + buttonGutter),
          child: ttlRight,
        ),
      ],
    );

    var functions = Flex(
      direction: Axis.vertical,
      children: [
        // buildKeys(<Key>[
        //   Key(
        //     "x^-1",
        //     type: KeyType.functions,
        //     shift: "n!",
        //     width: functionKeyWidth,
        //   ),
        //   Key(
        //     "nCr",
        //     type: KeyType.functions,
        //     shift: "nPr",
        //     width: functionKeyWidth,
        //   ),
        //   Key(
        //     "Pol(",
        //     type: KeyType.functions,
        //     shift: "Rec(",
        //     width: functionKeyWidth,
        //   ),
        //   Key(
        //     "x^3",
        //     type: KeyType.functions,
        //     shift: "x^-3",
        //     width: functionKeyWidth,
        //   ),
        // ]),
        buildKeys(<Key>[
          Key(
            "a b/c",
            type: KeyType.functions,
            shift: "d/c",
            width: functionKeyWidth,
          ),
          Key("sqrt", type: KeyType.functions, width: functionKeyWidth),
          Key("x^2", type: KeyType.functions, width: functionKeyWidth),
          Key("^",
              type: KeyType.functions, shift: "x^-y", width: functionKeyWidth),
          Key("log",
              type: KeyType.functions, shift: "10^x", width: functionKeyWidth),
          Key("ln",
              type: KeyType.functions,
              shift: "e^x",
              alpha: "e",
              width: functionKeyWidth),
        ]),
        buildKeys(<Key>[
          Key("(-)",
              type: KeyType.functions,
              shift: "d/c",
              alpha: "A",
              width: functionKeyWidth),
          Key(".,",
              type: KeyType.functions,
              shift: "<-",
              alpha: "B",
              width: functionKeyWidth),
          Key("hyp",
              type: KeyType.functions, alpha: "C", width: functionKeyWidth),
          Key("sin",
              type: KeyType.functions,
              shift: "sin⁻¹",
              alpha: "D",
              width: functionKeyWidth),
          Key("cos",
              type: KeyType.functions,
              shift: "cos⁻¹",
              alpha: "E",
              width: functionKeyWidth),
          Key("tan",
              type: KeyType.functions,
              shift: "tan⁻¹",
              alpha: "F",
              width: functionKeyWidth),
        ]),
        buildKeys(<Key>[
          Key("RCL",
              type: KeyType.functions, shift: "STO", width: functionKeyWidth),
          Key("ENG",
              type: KeyType.functions, shift: "<-", width: functionKeyWidth),
          Key("(", type: KeyType.functions, width: functionKeyWidth),
          Key(")",
              type: KeyType.functions, alpha: "X", width: functionKeyWidth),
          Key(",",
              type: KeyType.functions,
              shift: ";",
              alpha: "Y",
              width: functionKeyWidth),
          Key("M+",
              type: KeyType.functions,
              shift: "M-",
              alpha: "M",
              width: functionKeyWidth),
        ]),
      ],
    );

    var normals = Flex(
      direction: Axis.vertical,
      children: [
        buildKeys(<Key>[
          Key(
            "7",
            width: normalKeyWidth,
          ),
          Key(
            "8",
            width: normalKeyWidth,
          ),
          Key(
            "9",
            width: normalKeyWidth,
          ),
          Key(
            "DEL",
            shift: "INS",
            color: Key.colorAlpha,
            width: normalKeyWidth,
          ),
          Key(
            "AC",
            shift: "OFF",
            color: Key.colorAlpha,
            width: normalKeyWidth,
          ),
        ]),
        buildKeys(<Key>[
          Key(
            "4",
            width: normalKeyWidth,
          ),
          Key(
            "5",
            width: normalKeyWidth,
          ),
          Key(
            "6",
            width: normalKeyWidth,
          ),
          Key(
            "*",
            width: normalKeyWidth,
          ),
          Key(
            "/",
            width: normalKeyWidth,
          ),
        ]),
        buildKeys(<Key>[
          Key("1", shift: "S-SUM", width: normalKeyWidth),
          Key(
            "2",
            shift: "S-VAR",
            width: normalKeyWidth,
          ),
          Key("3", width: normalKeyWidth),
          Key("+", width: normalKeyWidth),
          Key("-", width: normalKeyWidth),
        ]),
        buildKeys(<Key>[
          Key(
            "0",
            shift: "Rnd",
            width: normalKeyWidth,
          ),
          Key(
            ".",
            shift: "Ran#",
            width: normalKeyWidth,
          ),
          Key(
            "EXP",
            shift: "pi",
            width: normalKeyWidth,
          ),
          Key("Ans", shift: "DEG>", width: normalKeyWidth),
          Key(
            "=",
            shift: "%",
            width: normalKeyWidth,
          ),
        ]),
      ],
    );

    return SizedBox(
        width: rpx(width),
        child: Container(
          child: Flex(
            direction: Axis.vertical,
            children: [topTwoLines, functions, SizedBox(height: 16), normals],
          ),
        ));
  }
}
