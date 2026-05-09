import 'package:flutter/material.dart';

import 'ui.dart';
import '../db/db.dart';

class TEditGroup {
  final List<TEdit> edits;
  TEditGroup(this.edits) {
    for (TEdit e in edits) {
      e.group = this;
    }
  }
  loadAll() {
    for (TEdit e in edits) {
      e.loadFromField();
    }
  }

  saveAll() {
    for (TEdit e in edits) {
      e.saveToField();
    }
  }

  initAll() {
    for (TEdit e in edits) {
      e.initValue();
    }
  }
}

abstract class TEdit<T> extends TUI {
  TEdit({this.field, this.contentPadding});
  TField<T>? field;

  EdgeInsetsGeometry? contentPadding;

  late TEditGroup group;
  T? getValue();
  setValue(T? v);
  saveToField() {
    if (field == null) return;
    field!.value = getValue();
  }

  loadFromField() {
    if (field == null) return;
    setValue(field!.value);
  }

  initValue();
  T? get value => getValue();

  set value(T? value) {
    setValue(value);
  }
}
