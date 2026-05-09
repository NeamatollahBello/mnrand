// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'dart:async';

final DateFormat defaultJsonDateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
final DateFormat defaultJsonDateFormat = DateFormat('yyyy-MM-dd');
final DateFormat defaultJsonTimeFormat = DateFormat('HH:mm:ss');

const ffAutoInc = 1;
const ffAdd = 2;
const ffEdit = 4;
const ffDelete = 8;
const ffReturnAfterAdd = 16;
const ffReturnAfterEdit = 32;
const ffSendIfNotModified = 64;
const ffNoLoad = 128;
const ffKey = ffEdit + ffDelete + ffAutoInc + ffSendIfNotModified;
const ffData = ffEdit + ffAdd;

enum TTableState {
  tsIdle,
  tsLoading,
  tsRefreshing,
  tsGetting,
  tsAdding,
  tsEditing,
  tsFiltering,
  tsComparing,
  tsDeleting
}

class TField<T> {
  Type get dataType => T;
  final String fieldName;
  final int flags;
  bool get isAdd => (flags & ffAdd) == ffAdd;
  bool get isEdit => (flags & ffEdit) == ffEdit;
  bool get isReturnAfterAdd => (flags & ffReturnAfterAdd) == ffReturnAfterAdd;
  bool get isReturnAfterEdit =>
      (flags & ffReturnAfterEdit) == ffReturnAfterEdit;
  bool get isDelete => (flags & ffDelete) == ffDelete;
  bool get isSendIfNotModified =>
      (flags & ffSendIfNotModified) == ffSendIfNotModified;
  bool get isLoad => (flags & ffNoLoad) == 0;
  bool get isAutoInc => (flags & ffAutoInc) == ffAutoInc;
  bool get isKey => (flags & ffKey) == ffKey;

  //constructor

  TField(this.fieldName,
      {this.flags = ffData,
      this.defaultValue,
      this.jsonFormat,
      this.trueStr = 'True',
      this.falseStr =
          'False'}); //table and index is assigned later in table class when assigning fields property

  late TTable table;
  late int index;

  T? defaultValue;
  T? _newValue; //used for editing and adding
  //values of the field (value for each row)
  T? operator [](int i) {
    return (i >= 0 && i < table.recordCount) ? table._data[i][index] : null;
  }

  operator []=(int i, T value) {
    table._data[i][index] = value;
  }
  //properties used inside table editing and appending procedure

  int? findFirst(T? val, [int start = 0]) {
    for (int i = start; i < table.recordCount; i++) {
      if (table._data[i][index] == val) {
        return i;
      }
    }
    return null;
  }

  T? _getValue() {
    if (table._state == TTableState.tsAdding ||
        table._state == TTableState.tsEditing) {
      return _newValue;
    } else if (table._state == TTableState.tsComparing ||
        table._state == TTableState.tsFiltering ||
        table._state == TTableState.tsGetting) {
      return table._data[table._recIndex][index];
    }
    return null;
  }

  T? _getOrgValue() {
    if (table._state == TTableState.tsAdding) {
      return defaultValue;
    } else if (table._state == TTableState.tsEditing) {
      return table._data[table._recIndex][index];
    }
    return null;
  }

  T? get value => _getValue();
  T? get orgValue => _getOrgValue();
  T? get compareValue => table._state == TTableState.tsComparing
      ? table._data[table._recIndex2][index]
      : null;

  set value(T? v) {
    if (table._state == TTableState.tsAdding ||
        table._state == TTableState.tsEditing) {
      if (_newValue != v) {
        _newValue = v;
        table._modified = true;
      }
    } else if (table._state == TTableState.tsComparing ||
        table._state == TTableState.tsFiltering ||
        table._state == TTableState.tsGetting) {
      if (table._data[table._recIndex][index] != v) {
        table._data[table._recIndex][index] = v;
        table._modified = true;
      }
    }
  }

  bool get modified =>
      table._state == TTableState.tsEditing ? value != orgValue : false;

  //properties used inside table sorting procedure

  //format settings and methods
  Object? jsonFormat; //number format object or dateformat object
  String trueStr = 'True';
  String falseStr = 'False';
  //events that can be assigned after field creation for custom format
  String Function(T? value)? onGetText;
  T? Function(String? text)? onSetText;
  String Function(T? value)? onGetJsonText;

  String _toJsonString(T? v) {
    if (onGetJsonText != null) {
      return onGetJsonText!(v);
    }
    if (v == null) {
      return 'null';
    }
    if (T == String) {
      return ((v as String?) ?? '');
    }
    if (T == bool) {
      return ((v as bool?) ?? false) ? trueStr : falseStr;
    }
    if (T == double) {
      if (jsonFormat == null) {
        return ((v as double?) ?? 0).toString();
      } else {
        return (jsonFormat as NumberFormat).format(v);
      }
    }
    if (T == int) {
      if (jsonFormat == null) {
        return ((v as int?) ?? 0).toString();
      } else {
        return (jsonFormat as NumberFormat).format(v);
      }
    }

    if (T == DateTime) {
      if (jsonFormat == null) {
        return defaultJsonDateTimeFormat.format(v as DateTime);
      } else {
        return (jsonFormat as DateFormat).format(v as DateTime);
      }
    }
    return "";
  }
}

class TTable {
  TField<int> intField(
    TField? prevField,
    String fieldName, {
    int flags = ffData,
    int? defaultValue,
    Object? jsonFormat,
  }) {
    var f = TField<int>(fieldName,
        flags: flags, defaultValue: defaultValue, jsonFormat: jsonFormat);
    f.index = fields.length;
    f.table = this;
    fields.add(f);
    return f;
  }

  TField<String> strField(
    TField? prevField,
    String fieldName, {
    int flags = ffData,
    String? defaultValue,
  }) {
    var f = TField<String>(fieldName, flags: flags, defaultValue: defaultValue);
    f.index = fields.length;
    f.table = this;
    fields.add(f);
    return f;
  }

  TField<double> doubleField(
    TField? prevField,
    String fieldName, {
    int flags = ffData,
    double? defaultValue,
    Object? jsonFormat,
  }) {
    var f = TField<double>(fieldName,
        flags: flags, defaultValue: defaultValue, jsonFormat: jsonFormat);
    f.index = fields.length;
    f.table = this;
    fields.add(f);
    return f;
  }

  TField<bool> boolField(TField? prevField, String fieldName,
      {int flags = ffData,
      bool? defaultValue,
      String trueStr = 'True',
      String falseStr = 'False'}) {
    var f = TField<bool>(
      fieldName,
      flags: flags,
      defaultValue: defaultValue,
      falseStr: falseStr,
      trueStr: trueStr,
    );
    f.index = fields.length;
    f.table = this;
    fields.add(f);
    return f;
  }

  TField<DateTime> dateTimeField(
    TField? prevField,
    String fieldName, {
    int flags = ffData,
    DateTime? defaultValue,
    Object? jsonFormat,
  }) {
    var f = TField<DateTime>(fieldName,
        flags: flags, defaultValue: defaultValue, jsonFormat: jsonFormat);
    f.index = fields.length;
    f.table = this;
    fields.add(f);
    return f;
  }

  List<TField> fields = List<TField>.empty(growable: true);
  TTable();
  bool opened = false;
  TTableState _state = TTableState.tsIdle;
  int _recIndex = -1;
  int _recIndex2 = -1;
  List<List> _data = [];
  bool _modified = false;
  bool get modified => _modified;
  int get recordCount => !opened ? 0 : _data.length;
  List<TTableView> views = [];

  int _compare(int compare, int compareTo, int Function() onCompare) {
    if (_state != TTableState.tsComparing ||
        compare < 0 ||
        compare >= _data.length ||
        compareTo < 0 ||
        compareTo >= _data.length) {
      return 0; //equal
    }
    _recIndex = compare;
    _recIndex2 = compareTo;

    return onCompare();
  }

  bool _filter(int index, bool Function() onFilter) {
    if (index < 0 ||
        index >= _data.length ||
        _state != TTableState.tsFiltering) {
      return false; //equal
    }
    _recIndex = index;
    return onFilter();
  }

  notifyRebuild() {
    for (int i = 0; i < views.length; i++) {
      if (views[i].autoNotify) {
        views[i].notifyRebuild();
      }
    }
  }

  notifyAdd(int index) {
    for (int i = 0; i < views.length; i++) {
      if (views[i].autoNotify) {
        views[i].notifyAdd(index);
      }
    }
  }

  notifyEdit(int index) {
    for (int i = 0; i < views.length; i++) {
      if (views[i].autoNotify) {
        views[i].notifyEdit(index);
      }
    }
  }

  notifyDel(int index) {
    for (int i = 0; i < views.length; i++) {
      if (views[i].autoNotify) {
        views[i].notifyDel(index);
      }
    }
  }

  clear() {
    for (int i = 0; i < _data.length; i++) {
      _data[i].clear();
    }
    _data.clear();
    opened = true;
    notifyRebuild();
  }

  loadFromJson(Future<List?> Function() jsonFunc) async {
    List json = (await jsonFunc()) ?? [];
    _data = List.generate(
        json.length,
        (i) => List.generate(fields.length, (j) {
              if (!fields[j].isLoad) return null;
              var v = json[i][fields[j].fieldName];
              if (v == null) return null;
              if (fields[j] is TField<DateTime>) return DateTime.parse(v);
              if (fields[j] is TField<int> && v is String) return int.parse(v);
              if (fields[j] is TField<double> && v is String) {
                return double.parse(v);
              }
              if (fields[j] is TField<double> && v is int) {
                return v.toDouble();
              }
              return v;
            }));
  }

  loadFromList(Future<List<List>?> Function() listFunc,
      [bool directAssign = true]) async {
    List<List> list = (await listFunc()) ?? [];
    if (directAssign) {
      _data = list;
    } else {
      _data = List.generate(list.length, (index) => list[index].toList());
    }
  }

  Future doLoad([params]) async {
    if (params is List<List>) {
      await loadFromList(() async => params);
    } else if (params is List) {
      await loadFromJson(() async => params);
    } else {
      clear();
    }
  }

  Future doRefreshRecord(int recIndex) async {}

  Future load([params]) async {
    if (_state != TTableState.tsIdle) {
      return;
    }
    _state = TTableState.tsLoading;
    opened = false;
    clear();
    await doLoad(params);
    _state = TTableState.tsIdle;
    notifyRebuild();
    opened = true;
  }

  get(int index, Function() getFunc) {
    if (_state != TTableState.tsIdle || index < 0 || index >= _data.length) {
      return;
    }
    _recIndex = index;
    _state = TTableState.tsGetting;
    getFunc();
    _state = TTableState.tsIdle;
  }

  Future storeAdd([params]) async {
    return null;
  }

  Future storeEdit(int index, [params]) async {
    return null;
  }

  Future storeDelete(int index, [params]) async {
    return null;
  }

  Future<int> add(Function() setFunc, [params]) async {
    if (_state != TTableState.tsIdle) {
      return -1;
    }
    _state = TTableState.tsAdding;
    for (TField f in fields) {
      f._newValue = f.defaultValue;
    }
    _modified = false;
    setFunc();

    var addRes = await storeAdd(params);
    if (addRes != null) return -1;
    _data.add(List.generate(
        fields.length, (i) => fields[i].isLoad ? fields[i]._newValue : null));
    _state = TTableState.tsIdle;
    notifyAdd(_data.length - 1);
    return _data.length - 1;
  }

  Future<bool> edit(int index, Function() setFunc, [params]) async {
    if (_state != TTableState.tsIdle || index < 0 || index >= _data.length) {
      return false;
    }
    _recIndex = index;
    _state = TTableState.tsEditing;

    for (TField f in fields) {
      f._newValue = f.table._data[_recIndex][f.index];
    }
    _modified = false;
    setFunc();

    var editRes = await storeEdit(index, params);
    if (editRes != null) return false;

    for (int i = 0; i < fields.length; i++) {
      _data[_recIndex][i] = fields[i].isLoad ? fields[i]._newValue : null;
    }
    _state = TTableState.tsIdle;
    notifyEdit(_recIndex);
    return true;
  }

  Future<bool> delete(int index, [params]) async {
    if (index < 0 || index >= _data.length || _state != TTableState.tsIdle) {
      return false;
    }
    _recIndex = index;
    _state = TTableState.tsDeleting;
    var delRes = await storeDelete(index, params);
    if (delRes != null) return false;
    _data.removeAt(_recIndex);
    _state = TTableState.tsIdle;
    notifyDel(_recIndex);
    return true;
  }

  Future refreshRecord(int recIndex) async {
    if (_state != TTableState.tsIdle) {
      return;
    }
    _state = TTableState.tsRefreshing;
    doRefreshRecord(recIndex);
    _state = TTableState.tsIdle;
    notifyEdit(recIndex);
  }
}

class TRestTable extends TTable {
  TRestTable({this.onLoad, this.onAdd, this.onEdit, this.onDelete});
  Future<Map<String, dynamic>?> Function(Map<String, dynamic> j)? onAdd;
  Future<Map<String, dynamic>?> Function(Map<String, dynamic> params)? onLoad;
  Future<Map<String, dynamic>?> Function(Map<String, dynamic> j)? onEdit;
  Future<Map<String, dynamic>?> Function(Map<String, dynamic> j)? onDelete;

  Map<String, dynamic> _generateAddJson() {
    Map<String, dynamic> r = {};
    for (int i = 0; i < fields.length; i++) {
      TField f = fields[i];
      if (!f.isAdd || f.fieldName == '' || f._newValue == null) {
        continue;
      }
      r.addAll({f.fieldName: f._toJsonString(f._newValue)});
    }
    return r;
  }

  Map<String, dynamic> _generateEditJson() {
    Map<String, dynamic> r = {};
    for (int i = 0; i < fields.length; i++) {
      TField f = fields[i];
      if (!f.isEdit ||
          f.fieldName == '' ||
          (!f.modified && !f.isSendIfNotModified)) {
        continue;
      }
      r.addAll({f.fieldName: f._toJsonString(f._newValue)});
    }
    return r;
  }

  Map<String, dynamic> _generateDeleteJson(int index) {
    Map<String, dynamic> r = {};
    for (int i = 0; i < fields.length; i++) {
      TField f = fields[i];
      if (!f.isDelete || f.fieldName == '') {
        continue;
      }
      r.addAll({f.fieldName: f._toJsonString(f[index])});
    }
    return r;
  }

  @override
  Future doLoad([params]) async {
    if (params is List<Map<String, dynamic>>) {
      await loadFromJson(() async => params);
    } else {
      await loadFromJson(() async {
        return (await onLoad!(params ?? {}))?["results"] ?? [];
      });
    }
  }

  @override
  Future storeAdd([params]) async {
    bool direct = false;
    Map<String, dynamic> extra = {};
    Function(Map<String, dynamic> res)? customResFn;
    if (params != null) {
      if (params.length > 0) {
        direct = params[0] ?? false;
      }
      if (params.length > 1) {
        extra = params[1] ?? {};
      }
      if (params.length > 2) {
        customResFn = params[2];
      }
    }
    if (onAdd == null || direct) return null;
    //prepare json
    Map<String, dynamic> j = _generateAddJson();
    j.addAll({"extra": extra});
    //call api
    Map<String, dynamic>? r = await onAdd!(j);
    if (r == null) return -1;
    //handle returned generated fields value
    for (int i = 0; i < fields.length; i++) {
      TField f = fields[i];
      if (f.isReturnAfterAdd || f.isAutoInc) {
        var v = r[f.fieldName];
        if (v != null) {
          if (v is String && f is TField<DateTime>) {
            f._newValue = DateTime.parse(v);
          } else {
            f._newValue = v;
          }
        } else {
          f._newValue = null;
        }
      }
    }
    if (customResFn != null) {
      customResFn(r);
    }
    return null;
  }

  @override
  Future storeEdit(int index, [params]) async {
    bool direct = false;
    Map<String, dynamic> extra = {};
    Function(Map<String, dynamic> res)? customResFn;
    if (params != null) {
      if (params.length > 0) {
        direct = params[0] ?? false;
      }
      if (params.length > 1) {
        extra = params[1] ?? {};
      }
      if (params.length > 2) {
        customResFn = params[2];
      }
    }

    if (onEdit == null || direct) return null;

    Map<String, dynamic> j = _generateEditJson();

    j.addAll({"extra": extra});

    Map<String, dynamic>? r = await onEdit!(j);
    if (r == null) {
      _state = TTableState.tsIdle;
      return -1;
    }
    for (int i = 0; i < fields.length; i++) {
      TField f = fields[i];
      if (f.isReturnAfterEdit) {
        var v = r[f.fieldName];
        if (v != null) {
          if (v is String && f is TField<DateTime>) {
            f._newValue = DateTime.parse(v);
          } else {
            f._newValue = v;
          }
        } else {
          f._newValue = null;
        }
      }
    }
    if (customResFn != null) {
      customResFn(r);
    }
    return null;
  }

  @override
  Future storeDelete(int index, [params]) async {
    bool direct = false;
    Map<String, dynamic> extra = {};
    Function(Map<String, dynamic> res)? customResFn;
    if (params != null) {
      if (params.length > 0) {
        direct = params[0] ?? false;
      }
      if (params.length > 1) {
        extra = params[1] ?? {};
      }
      if (params.length > 2) {
        customResFn = params[2];
      }
    }
    if (onDelete == null || direct) return null;
    Map<String, dynamic> j = _generateDeleteJson(_recIndex);
    j.addAll({"extra": extra});
    Map<String, dynamic>? r = await onDelete!(j);
    if (r == null) {
      _state = TTableState.tsIdle;
      return -1;
    }
    if (customResFn != null) customResFn(r);
    return null;
  }
}

String getSqlParams(String sql, List<String> listToFill) {
  sql = sql.trim();
  if (sql.isEmpty) return '';
  List<int> starts = '@:'.allMatches(sql).map((e) => e.start + 2).toList();
  for (int i = 0; i < starts.length; i++) {
    int start = starts[i];
    String s = '';
    while (start < sql.length) {
      String c = sql[start].toLowerCase();
      if ((c.compareTo('a') >= 0 && c.compareTo('z') <= 0) ||
          (c.compareTo('0') >= 0 && c.compareTo('9') <= 0) ||
          (c == '_')) {
        s += c;
      } else {
        break;
      }
      start += 1;
    }

    if (s.isNotEmpty) listToFill.add(s);
  }
  List<int> ol = List.generate(listToFill.length, (index) => index);
  ol.sort((a, b) => listToFill[b].compareTo(listToFill[a]));
  for (int i = 0; i < ol.length; i++) {
    sql = sql.replaceAll('@:${listToFill[ol[i]]}', '?');
  }
  return sql;
}

class TLiteTable extends TTable {
  TLiteTable(this.db, this.tableName, this.loadSQL, this.refreshSQL) {
    loadSQL = getSqlParams(loadSQL, loadParams);

    refreshSQL = getSqlParams(refreshSQL, refreshParams);
    for (int i = 0; i < fields.length; i++) {
      if (fields[i].isKey) {
        keyField = fields[i];
        break;
      }
    }
    returnedAddFields =
        fields.where((element) => element.isReturnAfterAdd).toList();
    returnedEditFields =
        fields.where((element) => element.isReturnAfterEdit).toList();
  }
  sqlite.Database db;
  String loadSQL;
  String tableName;
  TField? keyField;
  String refreshSQL;

  late List<String> loadParams = [];
  late List<String> refreshParams = [];

  late List<TField> returnedAddFields;
  late List<TField> returnedEditFields;

  @override
  Future doRefreshRecord(int recIndex) async {
    sqlite.ResultSet rs = db.select(
        refreshSQL, refreshParams.map((e) => keyField![recIndex]).toList());
    if (rs.isEmpty) return;
    sqlite.Row r = rs.first;
    for (int i = 0; i < fields.length - 1; i++) {
      _data[recIndex][i] = r.values[i];
    }
  }

  @override
  Future doLoad([params]) async {
    if (params is Map<String, dynamic>) {
      for (String k in params.keys) {
        dynamic v = params[k];
        if (v is DateTime) {
          params[k] = v.toIso8601String();
        }
      }
    }
    sqlite.ResultSet rs =
        db.select(loadSQL, loadParams.map((e) => params[e]).toList());
    for (int i = 0; i < fields.length; i++) {
      if (fields[i].dataType == DateTime) {
        for (int r = 0; r < rs.length; r++) {
          if (rs.rows[r][i] != null) {
            rs.rows[r][i] = DateTime.parse(rs.rows[r][i] as String);
          }
        }
      }
    }
    await super.doLoad(rs.rows);
  }

  @override
  Future storeAdd([params]) async {
    bool direct = params ?? false;
    if (direct) return null;
    List<String> fieldList = [];
    List fieldValueList = [];
    for (int i = 0; i < fields.length; i++) {
      TField f = fields[i];
      if (!f.isAdd || f.fieldName == '' || f._newValue == null) continue;
      fieldList.add('"${f.fieldName}"');
      if (f is TField<DateTime>) {
        fieldValueList.add((f._newValue as DateTime).toIso8601String());
      } else {
        fieldValueList.add(f._newValue);
      }
    }
    db.execute(
        'insert into "$tableName" (${fieldList.join(', ')}) values (${fieldList.map((e) => '?').join(', ')})',
        fieldValueList);
    if (keyField != null) {
      keyField!._newValue = db.lastInsertRowId;
    }
    if (returnedAddFields.isNotEmpty && keyField != null) {
      sqlite.ResultSet rs = db.select(
          'select ${returnedAddFields.map((e) => '"${e.fieldName}"').join(', ')} from "$tableName" where "${keyField!.fieldName}"=?',
          [keyField!._newValue]);
      for (int i = 0; i < returnedAddFields.length; i++) {
        returnedAddFields[i]._newValue = rs.first.values[i];
      }
    }
    return null;
  }

  @override
  Future storeEdit(int index, [params]) async {
    bool direct = params ?? false;
    if (direct || keyField == null) return null;
    List<String> fieldList = [];
    List fieldValueList = [];
    for (int i = 0; i < fields.length; i++) {
      TField f = fields[i];
      if (!f.isEdit ||
          f.fieldName == '' ||
          (!f.modified && !f.isSendIfNotModified)) {
        continue;
      }
      fieldList.add('"${f.fieldName}"=? ');
      if (f is TField<DateTime>) {
        fieldValueList.add((f._newValue as DateTime).toIso8601String());
      } else {
        fieldValueList.add(f._newValue);
      }
    }
    if (fieldList.isEmpty) return null;
    fieldValueList.add(keyField!.orgValue);
    db.execute(
        'update "$tableName" set ${fieldList.join(',')} where "${keyField!.fieldName}"=?',
        fieldValueList);

    if (returnedEditFields.isNotEmpty) {
      sqlite.ResultSet rs = db.select(
          'select ${returnedEditFields.map((e) => '"${e.fieldName}"').join(', ')} from "$tableName" where "${keyField!.fieldName}"=?',
          [keyField!._newValue]);
      for (int i = 0; i < returnedEditFields.length; i++) {
        returnedEditFields[i]._newValue = rs.first.values[i];
      }
    }
    return null;
  }

  @override
  Future storeDelete(int index, [params]) async {
    bool direct = params ?? false;
    if (direct || keyField == null) return null;
    db.execute('delete from "$tableName" where "${keyField!.fieldName}"=?',
        [keyField![index]]);
    return null;
  }
}

class TTableView {
  final TTable table;
  int _recordCount = 0;

  int get recordCount =>
      table._state == TTableState.tsLoading ? 0 : _recordCount;

  bool Function()? _onFilter;
  int Function()? _onCompare;
  bool autoNotify;
  List<int> _viewIndexes = [];
  List<int> _ogrIndexes = [];
  TTableView(this.table,
      {bool Function()? onFilter,
      int Function()? onCompare,
      this.autoNotify = true}) {
    _onFilter = onFilter;
    _onCompare = onCompare;
    table.views.add(this);
    notifyRebuild();
  }

  setParams({bool Function()? onFilter, int Function()? onCompare}) {
    if (onFilter != _onFilter) {
      _onFilter = onFilter;
    }
    if (onCompare != _onCompare) {
      _onCompare = onCompare;
    }
    notifyRebuild();
  }

  _rebuildIndexes() {
    if (table._state != TTableState.tsIdle) return;
    if (table.recordCount == 0) {
      _ogrIndexes.clear();
      _viewIndexes.clear();
      _recordCount = 0;
      return;
    }
    _ogrIndexes = List.generate(table.recordCount, (index) => index);
    if (_onFilter != null) {
      table._state = TTableState.tsFiltering;
      _ogrIndexes.retainWhere((element) => table._filter(element, _onFilter!));
      table._state = TTableState.tsIdle;
    }
    _recordCount = _ogrIndexes.length;
    if (_recordCount == 0) {
      _viewIndexes.clear();
      return;
    }

    if (_onCompare != null) {
      table._state = TTableState.tsComparing;
      _ogrIndexes.sort((a, b) {
        return table._compare(a, b, _onCompare!);
      });
      table._state = TTableState.tsIdle;
    }

    if (_onFilter != null || _onCompare != null) {
      _viewIndexes = List.filled(table.recordCount, -1, growable: true);
      for (int i = 0; i < _ogrIndexes.length; i++) {
        _viewIndexes[_ogrIndexes[i]] = i;
      }
    } else {
      _viewIndexes = List.generate(table.recordCount, (index) => index);
    }
  }

  notifyRebuild() {
    _rebuildIndexes();
  }

  notifyAdd(int index) {
    _rebuildIndexes(); //need to find a better performance way
  }

  notifyEdit(int index) {
    _rebuildIndexes(); //need to find a better performance way
  }

  notifyDel(int index) {
    _rebuildIndexes();
  }

  int operator +(int i) {
    if (i < 0 || i >= table.recordCount) {
      return -1;
    }
    return _viewIndexes[i];
  }

  int operator -(int i) {
    if (i < 0 || i >= recordCount) {
      return -1;
    }
    return _ogrIndexes[i];
  }
}
