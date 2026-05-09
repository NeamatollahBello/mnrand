import 'package:flutter/material.dart';

import 'edit.dart';

class TCheckBox extends TEdit<int> {
  String label;
  bool? _boolValue;
  bool triState;
  int? checkedValue;
  int? uncheckedValue;
  int? grayedValue;
  Function()? onClick;

  _clicked() async {
    bool? oldv = _boolValue;
    _boolValue = null;
    if (oldv == false) {
      _boolValue = true;
    } else if (oldv == null) {
      _boolValue = false;
    } else if (!triState) {
      _boolValue = false;
    }

    try {
      if (onClick != null) {
        await onClick!();
      }
      notify();
    } catch (e) {
      _boolValue = oldv;
      rethrow;
    }
  }

  bool get checked => _boolValue == true;

  set checked(bool value) {
    _boolValue = value;
    notify();
  }

  bool? get checkState => _boolValue;

  set checkState(bool? value) {
    _boolValue = value;
    notify();
  }

  TCheckBox({
    super.field,
    this.onClick,
    this.label = '',
    bool? checked = false,
    this.triState = false,
    this.checkedValue = 1,
    this.uncheckedValue = 0,
    this.grayedValue,
    super.contentPadding,
  }) {
    if (checked == null && !triState) {
      _boolValue = false;
    } else {
      _boolValue = checked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _clicked,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: _boolValue,
              tristate: triState,
              onChanged: (value) {
                _clicked();
              },
              activeColor: const Color(0xFFF97316),
              checkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  int? getValue() {
    if (_boolValue == null) {
      if (triState) {
        return grayedValue;
      } else {
        return uncheckedValue;
      }
    } else {
      return _boolValue! ? checkedValue : uncheckedValue;
    }
  }

  @override
  loadFromField() {
    if (field == null) return;
    setValue(field!.value);
  }

  @override
  saveToField() {
    if (field == null) return;
    field!.value = getValue();
  }

  @override
  setValue([int? v]) {
    if (v == checkedValue) {
      _boolValue = true;
    } else if (v == uncheckedValue) {
      _boolValue = false;
    } else {
      _boolValue = triState ? null : false;
    }
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
