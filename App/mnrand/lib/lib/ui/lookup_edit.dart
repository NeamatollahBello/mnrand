import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../db/db.dart';
import 'edit.dart';

class TLookupEdit<ReturnType> extends TEdit<ReturnType> {
  late String _label;

  String get label => _label;

  set label(String value) {
    _label = value;
    notify();
  }

  final TField<ReturnType>? returnField;
  final TField<String>? listField;
  final List<TField<String>>? searchFields;
  final TTable? table;
  final List<List>? choices;
  final bool enableSearch;
  IconData? buttonIcon;
  // final int Function(int index1, int index2)? onCompare;
  final bool Function(int index, Pattern search)? onFilter;
  final String Function(int index)? onGetItemText;
  final Function(ReturnType? val, int? index)? onSelected;
  Function()? onButtonPressed;
  final int returnIndex;
  final int listIndex;
  late Map<String, dynamic>? restLoadParams;
  late Map<String, dynamic>? liteLoadParams;
  int? get selectedIndex => _selectedIndex;
  set selectedIndex(int? val) {
    _selectedIndex = val;
    notify();
  }

  int? _selectedIndex;
  List<int> _items = [];
  TField<String>? _listField;
  List<TField<String>>? _searchFields;
  TField<ReturnType>? _returnField;

  String Function(int index)? _itemAsString;
  bool Function(int index, Pattern text)? _filter;

  String _itemAsString1(int index) {
    return _listField![index] ?? "";
  }

  bool _filter1(int index, Pattern text) {
    for (int i = 0; i < _searchFields!.length; i++) {
      if ((_searchFields![i][index] ?? "").contains(text)) return true;
    }
    return false;
  }

  String _itemAsString2(int index) {
    return choices![index][listIndex] as String;
  }

  bool _filter2(int index, Pattern text) {
    return (choices![index][listIndex] as String).contains(text);
  }

  Future<bool> updateItems(
      {bool forceTableReload = false,
      Map<String, dynamic>? restLoadParams,
      List? liteLoadParam}) async {
    if (table != null) {
      if (restLoadParams != null) {
        this.restLoadParams = restLoadParams;
      }
      if (liteLoadParams != null) {
        this.liteLoadParams = liteLoadParams;
      }
      if (forceTableReload || !table!.opened) {
        if (table is TRestTable) {
          await (table! as TRestTable).load(this.restLoadParams ?? {});
        } else {
          await (table! as TLiteTable).load(this.liteLoadParams ?? {});
        }
      }
      if (!table!.opened) {
        return false;
      }
      if (_items.length != table!.recordCount) {
        _items = List.generate(table!.recordCount, (index) => index);
      }
    } else {
      if (_items.length != choices!.length) {
        _items = List.generate(choices!.length, (index) => index);
      }
    }
    return true;
  }

  TLookupEdit({
    ReturnType? value,
    int? selectedIndex,
    String label = '',
    this.table,
    this.choices,
    super.field,
    this.returnField,
    this.listField,
    this.searchFields,
    this.returnIndex = 0,
    this.listIndex = 1,
    this.onButtonPressed,
    this.enableSearch = true,
    this.buttonIcon,
    // this.onCompare,
    this.onFilter,
    this.onGetItemText,
    this.onSelected,
    this.restLoadParams,
    this.liteLoadParams,
    super.contentPadding,
  }) {
    if (listField != null) {
      _listField = listField;
    } else if (table != null) {
      _listField = table!.fields[listIndex] as TField<String>;
    }
    if (searchFields != null) {
      _searchFields = searchFields;
    } else if (table != null) {
      _searchFields = [table!.fields[listIndex] as TField<String>];
    }

    if (returnField != null) {
      _returnField = returnField;
    } else if (table != null) {
      _returnField = table!.fields[returnIndex] as TField<ReturnType>;
    }
    _label = label;
    if (value != null) {
      setValue(value);
    } else {
      _selectedIndex = selectedIndex;
    }
    if (onFilter != null) {
      _filter = onFilter;
    } else if (_listField != null) {
      _filter = _filter1;
    } else {
      _filter = _filter2;
    }
    if (onGetItemText != null) {
      _itemAsString = onGetItemText;
    } else if (_listField != null) {
      _itemAsString = _itemAsString1;
    } else {
      _itemAsString = _itemAsString2;
    }
    updateItems();
  }
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<int>(
      suffixProps: DropdownSuffixProps(
          dropdownButtonProps: DropdownButtonProps(
        iconClosed: GestureDetector(
          child: Icon(buttonIcon ?? Icons.add),
          onTap: () {
            if (onButtonPressed != null) onButtonPressed!();
          },
        ),
        iconOpened: GestureDetector(
          child: Icon(buttonIcon ?? Icons.add),
          onTap: () {
            if (onButtonPressed != null) onButtonPressed!();
          },
        ),
      )),
      decoratorProps: DropDownDecoratorProps(
          baseStyle: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
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
          )),
      selectedItem: _selectedIndex,
      onChanged: (value) {
        _selectedIndex = value;
        if (onSelected != null) {
          onSelected!(this.value, value);
        }
        notify();
      },
      popupProps: PopupProps.menu(
          disableFilter: true,
          showSearchBox: enableSearch,
          fit: FlexFit.loose,
          searchDelay: const Duration(milliseconds: 300)),
      items: (filter, loadProps) {
        var re = RegExp(
            filter
                .replaceAll('.', '\\.')
                .replaceAll('*', '\\*')
                .replaceAll(' ', '.*'),
            caseSensitive: false);
        return _items
            .where(
              (element) => _filter!(element, re),
            )
            .toList();
      },
      itemAsString: _itemAsString,
    );
  }

  @override
  ReturnType? getValue() {
    if (_selectedIndex == null) return null;
    if (_returnField != null) {
      return _returnField![_selectedIndex!];
    }
    return choices![_selectedIndex!][returnIndex];
  }

  @override
  setValue([ReturnType? v]) {
    if (v == null) {
      _selectedIndex = null;
      return;
    }
    if (_returnField != null) {
      _selectedIndex = _returnField!.findFirst(v);
      return;
    }
    _selectedIndex = null;
    for (int i = 0; i < choices!.length; i++) {
      if (choices![i][listIndex] == v) {
        _selectedIndex = i;
        break;
      }
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
