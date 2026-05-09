import 'package:flutter/material.dart';
import 'edit.dart';

class TTextEdit extends TEdit<String> {
  Function(String text)? onChange;
  TextEditingController controller = TextEditingController();
  late String _label;

  String get label => _label;

  set label(String value) {
    _label = value;
    notify();
  }

  TTextEdit({
    String text = "",
    String label = "",
    this.onChange,
    super.field,
    super.contentPadding,
  }) {
    _label = label;
    setValue(text);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      onChanged: onChange,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: contentPadding,
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
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  String getValue() {
    return controller.text;
  }

  @override
  setValue(String? v) {
    controller.text = v ?? '';
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
