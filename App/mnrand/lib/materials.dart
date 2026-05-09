import 'dart:convert';

import 'package:flutter/material.dart';
import '../apptype.dart';
import 'addbill.dart';
import 'api.dart';
import 'appui.dart';
import 'errors.dart';
import 'lib/db/db.dart';
import 'lib/flutter_utils.dart';
import 'lib/ui/forms.dart';
import 'lib/ui/grid.dart';
import 'lib/ui/text_edit.dart';
import 'lib/ui/ui.dart';
import 'pagetemplate.dart';
import 'show_qtys.dart';

class TMaterialsTable extends TTable {
  late final id = strField(null, 'id');
  late final name = strField(id, 'name');
  late final group = strField(name, 'group');
  late final code = strField(group, 'code');
  late final price1 = doubleField(code, 'price1');
  late final price2 = doubleField(price1, 'price2');
  late final price3 = doubleField(price2, 'price3');
  late final price4 = doubleField(price3, 'price4');
  late final price5 = doubleField(price4, 'price5');
  late final prices1 = strField(price5, 'prices1');
  late final prices2 = strField(prices1, 'prices2');
  late final prices3 = strField(prices2, 'prices3');
  late final unit1 = strField(prices3, 'unit1');
  late final unit2 = strField(unit1, 'unit2');
  late final unit3 = strField(unit2, 'unit3');
  late final unit4 = strField(unit3, 'unit4');
  late final unit5 = strField(unit4, 'unit5');
  late final barcode1 = strField(unit5, 'barcode1');
  late final qty = doubleField(barcode1, 'qty');
  late final cost = doubleField(qty, 'cost');
  late final quality = strField(cost, 'quality');
  late final qtyDetails = strField(quality, 'qtys');
  late final isttc = intField(qtyDetails, 'ttc');
  TMaterialsTable() {
    isttc;
  }
}

class TMatGroupsTable extends TTable {
  late final id = strField(null, 'id');
  late final name = strField(id, 'name');
  TMatGroupsTable() {
    name;
  }
}

class TMaterialGroup {
  late int startIndex;
  late int count;
  late String name;
}

class TFilteredMaterialGroup {
  late List<int> indexes;
  late String name;
}

class TMaterialsForm extends TForm {
  TMaterialsForm() : super() {
    onShow = () async {
      grid.columns[4].visible = canShowCost;
      grid.columns[5].visible = (!isMazeed) && canShowQuality;
      grid.refreshItems();
    };
  }
  TMaterialsTable materials = TMaterialsTable();
  TMatGroupsTable matGroups = TMatGroupsTable();

  int _listCompare(int index1, int index2) {
    return (materials.name[index1] ?? '')
        .compareTo(materials.name[index2] ?? "");
  }

  bool _listFilter(int index) {
    if (searchText.isEmpty) return true;
    return ((materials.name[index] ?? '').contains(searchRe) ||
        (materials.group[index] ?? '').contains(searchRe) ||
        (materials.code[index] ?? '').contains(searchRe) ||
        (materials.barcode1[index] ?? '').contains(searchRe));
  }

  List<TMaterialGroup> groups = [];

  late TDBGrid grid = TDBGrid(
    settingsFileName: '${rootDir}matgs.conf',
    [
      TGridColumn(materials.code, 'رقم المادة', sortable: true),
      TGridColumn(materials.name, 'اسم المادة', sortable: true),
      TGridColumn(materials.unit1, 'الواحدة 1', sortable: true),
      TGridColumn(materials.qty, 'الكمية', sortable: true, format: ',###.###'),
      TGridColumn(materials.cost, 'الكلفة', sortable: true, format: ',###.##'),
      TGridColumn(materials.quality, 'الجودة', sortable: true),
      TGridColumn(materials.group, 'المجموعة', sortable: true),
      TGridColumn(materials.price1, 'السعر 1',
          sortable: true, format: ',###.##'),
      TGridColumn(materials.unit2, 'الواحدة 2', sortable: true),
      TGridColumn(materials.price2, 'السعر 2',
          sortable: true, format: ',###.##'),
      TGridColumn(materials.unit3, 'الواحدة 3', sortable: true),
      TGridColumn(materials.price3, 'السعر 3',
          sortable: true, format: ',###.##'),
      if (!isMazeed) TGridColumn(materials.unit4, 'الواحدة 4', sortable: true),
      if (!isMazeed)
        TGridColumn(materials.price4, 'السعر 4',
            sortable: true, format: ',###.##'),
      if (!isMazeed) TGridColumn(materials.unit5, 'الواحدة 5', sortable: true),
      if (!isMazeed)
        TGridColumn(materials.price5, 'السعر 5',
            sortable: true, format: ',###.##'),
    ],
    onFilter: _listFilter,
    onCompare: _listCompare,
    onCellTap: (details) async {
      await showQtyForm
          .setQtys(materials.qtyDetails[details.tableRowIndex] ?? '');
      showQtyForm.showModal();
    },
  );
  String searchText = '';
  late RegExp searchRe;
  late TTextEdit searchEdit = TTextEdit(
    label: "البحث",
    onChange: (text) {
      searchText = text;
      searchRe = RegExp(
          searchText
              .replaceAll('.', '\\.')
              .replaceAll('*', '\\*')
              .replaceAll(' ', '.*'),
          caseSensitive: false);
      grid.refreshItems(refreshMode: TGridRefreshMode.grmFilter);
    },
    contentPadding: const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 8),
  );

  groupMaterials() {
    //materials returned from database are ordered by group
    groups = [];
    if (materials.recordCount == 0) return;
    int count = 1;
    String lastName = materials.group[0] ?? '';
    groups.add(TMaterialGroup()
      ..startIndex = 0
      ..name = lastName);

    for (int i = 1; i < materials.recordCount; i++) {
      String s = materials.group[i] ?? '';
      if (s != lastName) {
        groups.last.count = count;
        count = 1;
        groups.add(TMaterialGroup()
          ..startIndex = i
          ..name = s);
        lastName = s;
      } else {
        count++;
      }
    }
    groups.last.count = count;
  }

  List<TFilteredMaterialGroup> groupMaterialsWithFilter(String search) {
    //materials returned from database are ordered by group
    var re = RegExp(
        search
            .replaceAll('.', '\\.')
            .replaceAll('*', '\\*')
            .replaceAll(' ', '.*'),
        caseSensitive: false);
    List<TFilteredMaterialGroup> groups = [];
    if (materials.recordCount == 0) return groups;
    String lastName = '';
    for (int i = 0; i < materials.recordCount; i++) {
      if (!((materials.group[i] ?? '').contains(re) ||
          (materials.name[i] ?? '').contains(re) ||
          (materials.code[i] ?? '').contains(re) ||
          (materials.barcode1[i] ?? '').contains(re))) {
        continue;
      }

      if (groups.isEmpty || (materials.group[i] ?? '') != lastName) {
        lastName = materials.group[i] ?? '';
        groups.add(TFilteredMaterialGroup()
          ..name = lastName
          ..indexes = [i]);
      } else {
        groups.last.indexes.add(i);
      }
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return TTemplatePage(
        showBottomBar: false,
        activeIndex: 0,
        showAppBar: true,
        appBarTitle: 'المواد',
        showBackButton: true,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                      child: UI(
                        child: searchEdit,
                        constraints: const BoxConstraints(maxHeight: 40),
                        padding: const EdgeInsets.all(4),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: refreshList, child: const Text('تحديث'))
                  ],
                )),
              ],
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: UI(child: grid),
            )),
          ],
        ));
  }

  void refreshList() async {
    await Future.delayed(const Duration(milliseconds: 500));
    var res = await api('matlist', {});
    if (showApiError(res)) return;
    await materialsForm.materials.load(res['data']);
    for (int i = 0; i < materialsForm.materials.recordCount; i++) {
      List j = jsonDecode(materialsForm.materials.prices1[i] ?? '');
      var p = (j.firstWhere(
                (e) => e['PriceKind'] == defaultPayedPrice,
                orElse: () => {"Price": 0.0},
              )['Price'] ??
              0.0)
          .toDouble();
      materialsForm.materials.price1[i] = p;
    }
    materialsForm.groupMaterials();
    await materialsForm.matGroups.load(res['groups']);
    await addBillForm.barcodes.load(res['barcodes']);
    grid.refreshItems();
    showSnack('تم تحديث القائمة.');
  }
}

TMaterialsForm materialsForm = TMaterialsForm();
