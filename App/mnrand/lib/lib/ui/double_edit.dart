import 'package:flutter/material.dart';
import 'package:number_editing_controller/number_editing_controller.dart';

import 'edit.dart';

class TDoubleEdit extends TEdit<double> {
  bool selectAllOnFocus;
  final FocusNode _fn = FocusNode();

  final int maximumFractionDigits;
  final bool allowNegative;
  late NumberEditingTextController controller =
      NumberEditingTextController.decimal(
          maximumFractionDigits: maximumFractionDigits,
          allowNegative: allowNegative);
  Function(String text)? onChange;

  late String _label;

  String get label => _label;

  set label(String value) {
    _label = value;
    notify();
  }

  late bool _readOnly;

  bool get readOnly => _readOnly;

  set readOnly(bool value) {
    _readOnly = value;
    notify();
  }

  TDoubleEdit({
    this.selectAllOnFocus = true,
    this.maximumFractionDigits = 2,
    this.allowNegative = false,
    this.onChange,
    double? value,
    String label = '',
    bool readOnly = false,
    super.field,
    super.contentPadding,
  }) {
    if (selectAllOnFocus) {
      _fn.addListener(() {
        if (_fn.hasFocus) {
          controller.selection = TextSelection(
              baseOffset: 0, extentOffset: controller.text.length);
        }
      });
    }
    _label = label;
    _readOnly = readOnly;
    setValue(value);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: _readOnly,
      textInputAction: TextInputAction.next,
      controller: controller,
      onChanged: onChange,
      focusNode: _fn,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFF97316), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        labelText: _label,
        labelStyle: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  double? getValue() {
    return controller.number?.toDouble() ?? 0;
  }

  @override
  setValue([double? v]) {
    controller.number = v;
    notify();
  }

  @override
  initValue() {
    if (field != null) {
      setValue(field!.defaultValue);
    } else {
      setValue(null);
    }
  }
}
