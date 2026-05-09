import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import '../db/db.dart';
import '../flutter_utils.dart';
import 'menu.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'ui.dart';

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

NoGlowBehavior noGlowBehavior = NoGlowBehavior();

class TDataGridCell<T> extends DataGridCell<T> {
  final TGridColumn column;
  TDataGridCell(this.column, {required super.value})
      : super(columnName: column.field.fieldName);
}

class TColumnHeaderWidget extends GridColumn {
  TField field;
  TColumnHeaderWidget(this.field,
      {required super.label,
      super.columnWidthMode = ColumnWidthMode.none,
      super.visible = true,
      super.allowSorting = true,
      super.sortIconPosition = ColumnHeaderIconPosition.end,
      super.filterIconPosition = ColumnHeaderIconPosition.end,
      super.autoFitPadding = const EdgeInsets.all(16.0),
      super.minimumWidth = double.nan,
      super.maximumWidth = double.nan,
      super.width = double.nan,
      super.allowEditing = true,
      super.allowFiltering = true,
      super.filterPopupMenuOptions,
      super.filterIconPadding = const EdgeInsets.symmetric(horizontal: 8.0)})
      : super(columnName: field.fieldName);
}

class TGridColumn<T> {
  TGridColumn(this.field, this.caption,
      {this.width = double.nan,
      this.nullText = '',
      this.falseText,
      this.trueText,
      this.onGetText,
      this.format,
      this.sortable = false,
      this.formatLocale,
      this.visible = true}) {
    if (format != null) {
      if (field is TField<DateTime>) {
        df = intl.DateFormat(format, formatLocale);
      }
      if (field is TField<double>) {
        nf = intl.NumberFormat(format, formatLocale);
      }
    }
  }
  TField<T> field;
  double width; // = double.nan;
  String caption;
  bool visible;
  String nullText;
  String? trueText;
  String? falseText;
  String? format;
  String? formatLocale;
  bool sortable;
  late TDBGrid _grid;
  String Function(T? value)? onGetText;
  intl.DateFormat? df;
  intl.NumberFormat? nf;

  TDataGridCell generateDataCell(int tableRowIndex) {
    //data
    if (field.dataType == int ||
        field.dataType == double ||
        field.dataType == String ||
        field.dataType == DateTime ||
        field.dataType == bool) {
      return TDataGridCell<T>(this, value: field[tableRowIndex]);
    }
    return TDataGridCell<String>(this, value: field[tableRowIndex].toString());
  }

  TColumnHeaderWidget generateColHeaderWidget() {
    //data + col header widget
    return TColumnHeaderWidget(field,
        width: width,
        visible: visible,
        label: UI(
          ripple: false,
          color: Colors.transparent,
          paddingAll: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Text(
                      '$caption  ',
                      textAlign: TextAlign.center,
                    )),
                    if (_grid._sortCol == this)
                      Icon(_grid._sortType == 1
                          ? Icons.arrow_upward
                          : Icons.arrow_downward)
                  ],
                ),
              ),
            ],
          ),
          onClick: () {
            if (sortable) {
              if (_grid._sortCol == this) {
                if (_grid._sortType == 1) {
                  _grid._sortType = -1;
                } else {
                  if (_grid._sortType == -1) {
                    _grid._sortCol = null;
                  }
                }
              } else {
                _grid._sortCol = this;
                _grid._sortType = 1;
              }
              _grid.refreshItems();
            }
          },
        ));
  }

  Widget generateCellWidget(T? value) {
    late String text;
    if (onGetText != null) {
      text = onGetText!(value);
    } else {
      if (value == null) {
        text = nullText;
      } else if (trueText != null && falseText != null) {
        if (value is bool?) {
          text = (value as bool) ? trueText! : falseText!;
        } else if (value is int?) {
          text = ((value as int?) == 1) ? trueText! : falseText!;
        } else {
          text = falseText!;
        }
      } else if (df != null) {
        text = df!.format(value as DateTime);
      } else if (nf != null) {
        text = nf!.format(value as double);
      } else {
        text = value.toString();
      }
    }
    return Container(
      alignment: AlignmentDirectional.centerStart,
      padding: const EdgeInsets.all(8.0),
      child: Text(text),
    );
  }
}

class TGridColumns {
  TGridColumns(this.columns) {
    orgIndexes = List.generate(columns.length, (index) => index);
  }
  List<TGridColumn> columns;
  late List<int> orgIndexes;
  swap(int from, int to) {
    int tmp = orgIndexes.removeAt(from);
    orgIndexes.insert(to, tmp);
  }

  resize(int colIndex, double width) {
    columns[orgIndexes[colIndex]].width = width;
  }
}

class TGridDataSource extends DataGridSource {
  final TGridColumns gridColumns;
  TGridDataSource(this.gridColumns);

  setRows(List<DataGridRow> rows) {
    _rows = rows;
  }

  List<DataGridRow> _rows = [];

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return (e as TDataGridCell).column.generateCellWidget(e.value);
    }).toList());
  }
}

enum TGridRefreshMode { grmColSizes, grmColOrder, grmFilter, grmBoth }

class TCellCoordinates {
  TField field;
  int tableRowIndex;
  int visibleRowIndex;
  TCellCoordinates(
    this.field,
    this.tableRowIndex,
    this.visibleRowIndex,
  );
}

class TDBGrid extends TUI {
  final String? settingsFileName;
  final List<TGridColumn> columns;
  final DataGridController _controller = DataGridController();
  late final TGridColumns _cols = TGridColumns(columns);
  late TGridDataSource dataSource1 = TGridDataSource(_cols);
  late TGridDataSource dataSource2 = TGridDataSource(_cols);
  late TGridDataSource dataSource;
  List<String> popupMenuItems;
  Function(int index, String text, TCellCoordinates details)? onMenuItemPressed;
  List<String> Function(TCellCoordinates details)? onGetMenuItems;
  Function(TCellCoordinates details)? onCellTap;
  TPopupMenu<TCellCoordinates>? popmenu;
  TGridColumn? _sortCol;
  int _sortType = 1;

  int _sortCompare(int index1, int index2) {
    if (_sortCol == null) return 0;
    return (_sortCol!.field[index1]).compareTo(_sortCol!.field[index2]) *
        _sortType;
  }

  double _vertPos = 0;
  double _horzPos = 0;
  int Function(int index1, int index2)? _onCompare;
  bool Function(int index)? _onFilter;
  TDBGrid(this.columns,
      {int Function(int index1, int index2)? onCompare,
      bool Function(int index)? onFilter,
      this.popupMenuItems = const [],
      this.onMenuItemPressed,
      this.onCellTap,
      this.settingsFileName,
      this.onGetMenuItems}) {
    for (int i = 0; i < columns.length; i++) {
      columns[i]._grid = this;
    }
    loadSettings();
    _onCompare = onCompare;
    _onFilter = onFilter;
    dataSource = dataSource1;
    if (onGetMenuItems == null) createPopupMenu(popupMenuItems);
    refreshItems();
  }

  createPopupMenu(List<String> items) {
    if (items.isNotEmpty) {
      popmenu = TPopupMenu<TCellCoordinates>(
          items: items, onItemPresseed: onMenuItemPressed);
    } else {
      popmenu = null;
    }
  }

  late TTable _table;
  late List<int> _visibleIndexes;
  late List<int> _orgIndexes;
  late List<GridColumn> _gridColumns;

  _showIndex(int? index, double? vert, double? horz) {
    if (index == null && vert == null) {
      return;
    }
    if (horz != null) {
      _controller.scrollToHorizontalOffset(horz);
    }
    if (vert != null) {
      onNextFrame(() {
        _controller.scrollToVerticalOffset(vert);
        if (index != null && index >= 0) {
          onNextFrame(() => _controller.scrollToRow(index.toDouble(),
              position: DataGridScrollPosition.makeVisible));
        }
      });
    } else {
      if (index != null && index >= 0) {
        onNextFrame(() => _controller.scrollToRow(index.toDouble(),
            position: DataGridScrollPosition.makeVisible));
      }
    }
  }

  restorePos({bool restoreOffset = true, int? index, int? orgIndex}) {
    int Function(int index1, int index2)? cmp;
    if (_sortCol != null) {
      cmp = _sortCompare;
    } else if (_onCompare != null) {
      cmp = _onCompare;
    }

    double? vert = restoreOffset ? _vertPos : null;
    int? i;
    if (index != null || orgIndex != null) {
      if (_onFilter == null && cmp == null) {
        i = index ?? orgIndex;
      } else {
        i = index ?? _orgIndexes[orgIndex!];
      }
    }
    if (i != null || vert != null) {
      _showIndex(i, vert, _horzPos);
    }
  }

  savePos() {
    _vertPos = _controller.verticalOffset;
    _horzPos = _controller.horizontalOffset;
  }

  _rebuildIndexes() {
    int Function(int index1, int index2)? cmp;
    if (_sortCol != null) {
      cmp = _sortCompare;
    } else if (_onCompare != null) {
      cmp = _onCompare;
    }

    if (cmp == null && _onFilter == null) {
      return;
    }

    _visibleIndexes = List.generate(_table.recordCount, (index) => index);
    if (_onFilter != null) {
      _visibleIndexes.retainWhere((element) => _onFilter!(element));
    }
    if (cmp != null) {
      _visibleIndexes.sort((a, b) {
        return cmp!(a, b);
      });
    }

    _orgIndexes = List.filled(_table.recordCount, -1, growable: true);
    for (int i = 0; i < _visibleIndexes.length; i++) {
      _orgIndexes[_visibleIndexes[i]] = i;
    }
  }

  refreshItems({
    TGridRefreshMode refreshMode = TGridRefreshMode.grmBoth,
    bool Function(int index)? filterFn,
    int Function(int index1, int index2)? compareFn,
    bool clearFilterFunc = false,
    bool clearCompareFunc = false,
  }) {
    _table = columns[0].field.table;

    if (refreshMode != TGridRefreshMode.grmColOrder &&
        refreshMode != TGridRefreshMode.grmColSizes) {
      if (filterFn != null) {
        _onFilter = filterFn;
      }
      if (compareFn != null) {
        _onCompare = compareFn;
      }
      if (clearCompareFunc) {
        _onCompare = null;
      }
      if (clearFilterFunc) {
        _onFilter = null;
      }
      _rebuildIndexes();
    }
    int Function(int index1, int index2)? cmp;
    if (_sortCol != null) {
      cmp = _sortCompare;
    } else if (_onCompare != null) {
      cmp = _onCompare;
    }

    if (refreshMode != TGridRefreshMode.grmFilter) {
      _gridColumns = List<GridColumn>.generate(columns.length, (index) {
        TGridColumn c = columns[_cols.orgIndexes[index]];
        return c.generateColHeaderWidget();
      }, growable: false);
    }
    bool indexUsed = _onFilter != null || cmp != null;
    List<DataGridRow> r = List<DataGridRow>.generate(
        indexUsed ? _visibleIndexes.length : _table.recordCount, (rindex) {
      return DataGridRow(
          cells: List<TDataGridCell>.generate(
              _cols.orgIndexes.length,
              (cindex) => columns[_cols.orgIndexes[cindex]].generateDataCell(
                  indexUsed ? _visibleIndexes[rindex] : rindex)));
    });
    dataSource1.setRows(r);
    dataSource2.setRows(r);
    dataSource = (dataSource == dataSource1) ? dataSource2 : dataSource1;
    notify();
  }

  showOptionsMenu(details) {
    int Function(int index1, int index2)? cmp;
    if (_sortCol != null) {
      cmp = _sortCompare;
    } else if (_onCompare != null) {
      cmp = _onCompare;
    }

    var co = TCellCoordinates(
        (details.column as TColumnHeaderWidget).field,
        (_onFilter != null || cmp != null)
            ? _visibleIndexes[details.rowColumnIndex.rowIndex - 1]
            : details.rowColumnIndex.rowIndex - 1,
        details.rowColumnIndex.rowIndex - 1);
    if (onGetMenuItems != null) createPopupMenu(onGetMenuItems!(co));
    if (popmenu != null && details.rowColumnIndex.rowIndex > 0) {
      popmenu!.show(
          Directionality.of(lastContext) == TextDirection.rtl
              ? MediaQuery.of(lastContext).size.width -
                  details.globalPosition.dx
              : details.globalPosition.dx,
          details.globalPosition.dy,
          co);
    }
  }

  @override
  Widget build(BuildContext context) {
    int Function(int index1, int index2)? cmp;
    if (_sortCol != null) {
      cmp = _sortCompare;
    } else if (_onCompare != null) {
      cmp = _onCompare;
    }

    return SfDataGrid(
        onCellSecondaryTap: showOptionsMenu,
        onCellLongPress: showOptionsMenu,
        onCellTap: (details) {
          if (details.rowColumnIndex.rowIndex < 1) return;
          if (onCellTap != null) {
            onCellTap!(TCellCoordinates(
                (details.column as TColumnHeaderWidget).field,
                (_onFilter != null || cmp != null)
                    ? _visibleIndexes[details.rowColumnIndex.rowIndex - 1]
                    : details.rowColumnIndex.rowIndex - 1,
                details.rowColumnIndex.rowIndex - 1));
          }
        },
        controller: _controller,
        headerGridLinesVisibility: GridLinesVisibility.both,
        gridLinesVisibility: GridLinesVisibility.both,
        allowColumnsDragging: true,
        allowColumnsResizing: true,
        onColumnResizeEnd: (details) {
          _cols.resize(details.columnIndex, details.width);
          refreshItems(refreshMode: TGridRefreshMode.grmColSizes);
          saveSettings();
        },
        allowFiltering: false,
        onColumnDragging: (DataGridColumnDragDetails details) {
          if (details.action == DataGridColumnDragAction.dropped &&
              details.to != null) {
            _cols.swap(details.from, details.to!);
            refreshItems(refreshMode: TGridRefreshMode.grmColOrder);
          }
          return true;
        },
        source: dataSource,
        columns: _gridColumns);
  }

  void saveSettings() {
    if (settingsFileName != null) {
      dynamic ws = columns.map((e) => e.width.isNaN ? -1 : e.width).toList();
      dynamic gridSettings = {'colwidthes': ws};
      File f = File(settingsFileName!);
      f.writeAsStringSync(jsonEncode(gridSettings));
    }
  }

  void loadSettings() {
    if (settingsFileName != null) {
      File f = File(settingsFileName!);
      if (f.existsSync()) {
        dynamic gridSettings = jsonDecode(f.readAsStringSync());
        dynamic ws = gridSettings['colwidthes'];
        if (ws.length == columns.length) {
          for (int i = 0; i < columns.length; i++) {
            if (ws[i] != -1) columns[i].width = ws[i];
          }
        }
      }
    }
  }
}
