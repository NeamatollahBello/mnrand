import 'package:flutter/material.dart';
import 'edit.dart';

class TCombobox extends TEdit<dynamic> {
  Function(int itemIndex, dynamic value)? onChange;
  late String _label;
  List<List> items;
  int _itemIndex = 0;
  dynamic _value;

  int get itemIndex => _itemIndex;

  set itemIndex(int itemIndex) {
    if (itemIndex < 0 || itemIndex >= items.length) {
      _value = null;
      _itemIndex = -1;
    } else {
      _itemIndex = itemIndex;
      _value = items[itemIndex][0];
    }
  }

  String get label => _label;

  set label(String value) {
    _label = value;
    notify();
  }

  TCombobox({
    required this.items,
    dynamic value,
    String label = "",
    this.onChange,
    super.field,
    super.contentPadding,
  }) {
    _label = label;
    setValue(value);
  }

  @override
  Widget build(BuildContext context) {
    return FormField(builder: (state) {
      return DropdownButtonFormField<int>(
        style: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 14,
          color: Color(0xFF1E293B),
          fontWeight: FontWeight.bold,
        ),
        value: _itemIndex,
        items: List.generate(
            items.length,
            (index) => DropdownMenuItem<int>(
                  value: index,
                  child: Text(items[index][1]),
                )),
        onChanged: (value) {
          itemIndex = value ?? 0;
          state.didChange(value);
          if (onChange != null) {
            onChange!(_itemIndex, _value);
          }
        },
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
    });
  }

  @override
  dynamic getValue() {
    return _value;
  }

  @override
  setValue(dynamic v) {
    _itemIndex = items.indexWhere((element) => element[0] == v);
    if (_itemIndex < 0) {
      _itemIndex = items.indexWhere((element) => element[0] == null);
      _value = null;
    } else {
      _value = v;
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
