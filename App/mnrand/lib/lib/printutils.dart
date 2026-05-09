// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart';

late Font billfont;
late Font billfontbold;

TextStyle st10 = TextStyle(font: billfont, fontSize: 10);
TextStyle st11 = TextStyle(font: billfont, fontSize: 11);
TextStyle st12 = TextStyle(font: billfont, fontSize: 12);
TextStyle st13 = TextStyle(font: billfont, fontSize: 13);
TextStyle st14 = TextStyle(font: billfont, fontSize: 14);
TextStyle st15 = TextStyle(font: billfont, fontSize: 15);
TextStyle st7b = TextStyle(font: billfontbold, fontSize: 7);
TextStyle st10b = TextStyle(font: billfontbold, fontSize: 10);
TextStyle st11b = TextStyle(font: billfontbold, fontSize: 11);
TextStyle st12b = TextStyle(font: billfontbold, fontSize: 12);
TextStyle st13b = TextStyle(font: billfontbold, fontSize: 13);
TextStyle st14b = TextStyle(font: billfontbold, fontSize: 14);
TextStyle st15b = TextStyle(font: billfontbold, fontSize: 15);

initPrinting() async {
  billfont = Font.ttf(await rootBundle.load("assets/billfont.ttf"));
  billfontbold = Font.ttf(await rootBundle.load("assets/billfontbold.ttf"));
}

extension TextCreator on TextStyle {
  Widget ar(
    String text, {
    TextAlign textAlign = TextAlign.right,
    Alignment alignment = Alignment.centerRight,
    EdgeInsets padding = EdgeInsets.zero,
    double? width,
    double? height,
  }) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        alignment: alignment,
        padding: padding,
        height: height,
        width: width,
        child: Text(text,
            style: this,
            textDirection: TextDirection.rtl,
            textAlign: textAlign));
  }

  Widget en(
    String text, {
    TextAlign textAlign = TextAlign.left,
    Alignment alignment = Alignment.centerLeft,
    EdgeInsets padding = EdgeInsets.zero,
    double? width,
    double? height,
  }) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        alignment: alignment,
        padding: padding,
        height: height,
        width: width,
        child: Text(text,
            style: this,
            textDirection: TextDirection.ltr,
            textAlign: textAlign));
  }
}
