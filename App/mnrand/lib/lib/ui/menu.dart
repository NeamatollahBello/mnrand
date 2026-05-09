import 'package:flutter/material.dart';
import 'forms.dart';

class TMenuItemData {
  final int itemIndex;
  final String itemText;

  TMenuItemData(this.itemIndex, this.itemText);
}

class TPopupMenu<SenderType> {
  List<String> items;
  Function(int itemIndex, String itemText, SenderType sender)? onItemPresseed;
  TPopupMenu({
    required this.items,
    this.onItemPresseed,
  });

  show(double x, double y, SenderType sender) {
    showMenu<TMenuItemData>(
        context: application.navigatorKey.currentContext!,
        position: RelativeRect.fromDirectional(
            textDirection:
                Directionality.of(application.navigatorKey.currentContext!),
            bottom: y,
            end: x,
            start: x,
            top: y),
        // position: RelativeRect.fromLTRB(x, y, x, y),
        items:
            List<PopupMenuItem<TMenuItemData>>.generate(items.length, (index) {
          return PopupMenuItem<TMenuItemData>(
            value: TMenuItemData(index, items[index]),
            child: Text(items[index]),
          );
        })).then((value) {
      if (value != null) {
        if (onItemPresseed != null) {
          onItemPresseed!(value.itemIndex, value.itemText, sender);
        }
      }
    });
  }
}
