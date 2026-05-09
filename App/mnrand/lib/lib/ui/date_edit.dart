// ignore_for_file: depend_on_referenced_packages
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'edit.dart';

class TDateEdit extends TEdit<DateTime> {
  DateTime? _value;
  static DateFormat dtf = DateFormat("dd / MM / yyyy hh:mm", "ar-SA");
  static DateFormat df = DateFormat("dd / MM / yyyy", "ar-SA");

  late String _label;

  String get label => _label;

  set label(String value) {
    _label = value;
    notify();
  }

  late bool _showTime;
  late bool _canClear;

  bool get showTime => _showTime;

  set showTime(bool value) {
    _showTime = value;
    notify();
  }

  set canClear(bool value) {
    _canClear = value;
    notify();
  }

  bool get canClear => _canClear;

  TDateEdit({
    DateTime? value,
    String label = "",
    bool showTime = false,
    bool canClear = true,
    super.field,
    super.contentPadding,
  }) {
    _label = label;
    _showTime = showTime;
    _canClear = canClear;
    setValue(value);
  }
  final GlobalKey<FormFieldState<DateTime>> _key =
      GlobalKey<FormFieldState<DateTime>>();
  @override
  Widget build(BuildContext context) {
    return DateTimeFormField(
      key: _key,
      onChanged: (value) {
        _value = value;
        notify();
      },
      mode: showTime
          ? DateTimeFieldPickerMode.dateAndTime
          : DateTimeFieldPickerMode.date,
      initialValue: _value,
      dateFormat: showTime ? dtf : df,
      canClear: _canClear,
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
        labelText: _label,
        labelStyle: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  DateTime? getValue() {
    return _value;
  }

  @override
  setValue([DateTime? v]) {
    _value = v;
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
