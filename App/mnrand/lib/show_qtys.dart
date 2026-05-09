import 'dart:convert';

import 'package:flutter/material.dart';
import 'lib/db/db.dart';
import 'lib/ui/forms.dart';
import 'lib/ui/grid.dart';
import 'lib/ui/ui.dart';

class TQtyTable extends TTable {
  late final store = strField(null, 'storename');
  late final qty = doubleField(store, 'qty');
  TQtyTable() {
    qty;
  }
}

class TShowQtyForm extends TForm {
  TQtyTable qtyTable = TQtyTable();
  late TDBGrid grdQty = TDBGrid([
    TGridColumn(qtyTable.store, 'المستودع', width: 200),
    TGridColumn(qtyTable.qty, 'الكمية', width: 100, format: ',###.###'),
  ]);

  TShowQtyForm() : super() {
    modalMode = TModalMode.dialog;
    clickOutWillPop = true;
    dialogBorderRadius = BorderRadiusDirectional.circular(8);
    dialogHorizontalPosition = TDialogHorizontalPosition.expand;
    dialogVerticalPosition = TDialogVerticalPosition.expand;
    dialogBorderSide =
        const BorderSide(color: Color.fromARGB(255, 139, 187, 226));
    dialogPadding = const EdgeInsets.symmetric(vertical: 100, horizontal: 50);
  }

  setQtys(String jqty) async {
    await qtyTable.load(jsonDecode(jqty));
    grdQty.refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return UI(
      paddingAll: 8,
      child: grdQty,
    );
  }
}

TShowQtyForm showQtyForm = TShowQtyForm();
