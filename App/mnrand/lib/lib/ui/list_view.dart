import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../db/db.dart';
import '../flutter_utils.dart';
import 'ui.dart';

class TListView extends TUI {
  double _storedPos = 0;
  late int _itemCount;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  late final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create()
        ..changes.listen((event) {
          _storedPos = event;
        });

  List<ItemPosition> visiblePositions = [];
  late final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create()
        ..itemPositions.addListener(() {
          visiblePositions =
              itemPositionsListener.itemPositions.value.toList(growable: false);
        });

  ensureVisible(int visibleIndex) {
    //must be more smart
    //if partialy visible or not visible jump direction ust be specified
    //must consider list reversion

    if (visiblePositions
            .indexWhere((element) => element.index == visibleIndex) ==
        -1) {
      itemScrollController.jumpTo(index: visibleIndex);
    }
  }

  int Function(int index1, int index2)? _onCompare;
  bool Function(int index)? _onFilter;
  late Widget Function(BuildContext context, int visibleIndex, int orgIndex)
      onDrawItem;
  final TTable? table;

  late bool _isHorz;

  bool get isHorz => _isHorz;

  set isHorz(bool value) {
    _isHorz = value;
    notify();
  }

  TListView(
      {this.table,
      bool isHorz = false,
      int? itemCount,
      int Function(int index1, int index2)? onCompare,
      bool Function(int index)? onFilter,
      required this.onDrawItem}) {
    _isHorz = isHorz;
    if (table != null) {
      _itemCount = table!.recordCount;
    } else if (itemCount != null) {
      _itemCount = itemCount;
    }
    _onCompare = onCompare;
    _onFilter = onFilter;

    refreshItems();
  }

  late List<int> _visibleIndexes;
  late List<int> _orgIndexes;

  _showIndex(int? index, double? offset) {
    if (index == null && offset == null) {
      return;
    }
    if (offset != null) {
      onNextFrame(() {
        scrollOffsetController.animateScroll(
            offset: offset, duration: Duration.zero);
        if (index != null && index >= 0) {
          onNextFrame(() {
            ensureVisible(index);
          });
        }
      });
    } else {
      if (index != null && index >= 0) {
        onNextFrame(() => itemScrollController.jumpTo(index: index));
      }
    }
  }

  restorePos({bool restoreOffset = true, int? index, int? orgIndex}) {
    double? o = restoreOffset ? _storedPos : null;
    int? i;
    if (index != null || orgIndex != null) {
      if (_onFilter == null && _onCompare == null) {
        i = index ?? orgIndex;
      } else {
        i = index ?? _orgIndexes[orgIndex!];
      }
    }
    if (i != null || o != null) {
      _showIndex(i, o);
    }
  }

  _rebuildIndexes() {
    if (_onCompare == null && _onFilter == null) {
      return;
    }

    _visibleIndexes = List.generate(_itemCount, (index) => index);
    if (_onFilter != null) {
      _visibleIndexes.retainWhere((element) => _onFilter!(element));
    }
    if (_onCompare != null) {
      _visibleIndexes.sort((a, b) {
        return _onCompare!(a, b);
      });
    }

    _orgIndexes = List.filled(_itemCount, -1, growable: true);
    for (int i = 0; i < _visibleIndexes.length; i++) {
      _orgIndexes[_visibleIndexes[i]] = i;
    }
  }

  refreshItems({
    int? itemCount,
    bool Function(int index)? filterFn,
    int Function(int index1, int index2)? compareFn,
    bool clearFilterFunc = false,
    bool clearCompareFunc = false,
  }) {
    if (table != null) {
      _itemCount = table!.recordCount;
    } else if (itemCount != null) {
      _itemCount = itemCount;
    }
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
    notify();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      scrollOffsetListener: scrollOffsetListener,
      itemPositionsListener: itemPositionsListener,
      scrollDirection: isHorz ? Axis.horizontal : Axis.vertical,
      itemScrollController: itemScrollController,
      scrollOffsetController: scrollOffsetController,
      itemBuilder: (context, index) {
        if (index < 0) {
          return Container();
        }
        int oIndex = index;
        if (_onFilter == null && _onCompare == null) {
          if (index >= _orgIndexes.length) {
            return Container();
          }
        } else {
          if (index >= _visibleIndexes.length) {
            return Container();
          }
          oIndex = _visibleIndexes[index];
          if (oIndex < 0 || oIndex >= _orgIndexes.length) {
            return Container();
          }
        }
        return onDrawItem(context, index, oIndex);
      },
      itemCount: (_onCompare == null && _onFilter == null)
          ? _itemCount
          : _visibleIndexes.length,
    );
  }
}
