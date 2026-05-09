import 'package:flutter/material.dart';
import 'ui.dart';

class TTextButton extends TUI {
  TEvent? onClick;
  late String _caption;

  TTextButton(String caption, this.onClick) : super() {
    _caption = caption;
  }

  String get caption => _caption;

  set caption(String value) {
    _caption = value;
    notify();
  }

  TextAlign? _align;

  TextAlign? get align => _align;

  set align(TextAlign? value) {
    _align = value;
    notify();
  }

  TextDirection? _direction;

  TextDirection? get direction => _direction;

  set direction(TextDirection? value) {
    _direction = value;
    notify();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onClick == null
          ? null
          : () {
              onClick!(this);
            },
      child: Text(
        caption,
        textAlign: align,
        textDirection: direction,
      ),
    );
  }
}
