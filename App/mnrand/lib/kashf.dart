import 'dart:io';
import 'package:flutter/material.dart';
import 'lib/ui/check_box.dart';
import 'apptype.dart';
import 'clients.dart';
import 'api.dart';
import 'appui.dart';
import 'errors.dart';
import 'lib/db/db.dart';
import 'lib/flutter_utils.dart';
import 'lib/ui/date_edit.dart';
import 'lib/ui/forms.dart';
import 'lib/ui/grid.dart';
import 'lib/ui/lookup_edit.dart';
import 'lib/ui/ui.dart';
import 'pagetemplate.dart';
import 'printkashf.dart';

class TKashfTable extends TTable {
  late var doc = strField(null, 'Doc');
  late var date = strField(doc, 'Date');
  late var madeen = strField(date, 'Madeen');
  late var daen = strField(madeen, 'Daen');
  late var docNotes = strField(daen, 'DocNotes');
  late var qty = strField(docNotes, 'Quantity');
  late var price = strField(qty, 'Price');
  late var total = strField(price, 'Total');
  late var addition = strField(total, 'Add');
  late var disc = strField(addition, 'Disc');
  TKashfTable() {
    disc;
  }
}

class TKashfForm extends TForm {
  late TKashfTable kashfTable = TKashfTable();
  late TLookupEdit accEdt = TLookupEdit(
      label: 'الحساب',
      buttonIcon: Icons.arrow_drop_down,
      table: accountsForm.clients,
      contentPadding: const EdgeInsetsDirectional.only(bottom: 8, start: 6));

  late TDBGrid grid = TDBGrid(
    [
      TGridColumn(kashfTable.doc, 'المستند'),
      TGridColumn(kashfTable.date, 'التاريخ'),
      TGridColumn(kashfTable.madeen, 'مدين'),
      TGridColumn(kashfTable.daen, 'دائن'),
      TGridColumn(kashfTable.docNotes, 'بيان المستند'),
      TGridColumn(kashfTable.qty, 'الكمية'),
      TGridColumn(kashfTable.price, 'السعر الإفرادي'),
      TGridColumn(kashfTable.total, 'المجموع'),
      if (!isMazeed) TGridColumn(kashfTable.addition, 'الإضافات'),
      if (!isMazeed) TGridColumn(kashfTable.disc, 'الحسميات'),
    ],
    settingsFileName: '${rootDir}kashfdgs.conf',
  );

  TCheckBox chkShowDetails = TCheckBox(label: 'تفصيلي');

  TDateEdit dtFrom = TDateEdit(
      value: DateTime.now().subtract(const Duration(days: 30)),
      canClear: false,
      label: 'من',
      contentPadding: const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 8));
  TDateEdit dtTo = TDateEdit(
      label: 'إلى',
      value: DateTime.now(),
      canClear: false,
      contentPadding: const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 8));
  String sumText = '';
  TUIPart sumPart = TUIPart();

  TKashfForm() {
    DateTime n = DateTime.now();
    dtFrom.value = DateTime(n.year, n.month - 1, n.day);
  }

  @override
  Widget build(BuildContext context) {
    return TTemplatePage(
        showBottomBar: false,
        activeIndex: 2,
        showAppBar: true,
        backFunc: () {
          close();
        },
        appBarTitle: 'كشف حساب',
        showBackButton: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  UI(
                    child: accEdt,
                    maxHeight: 52,
                    maxWidth: 375,
                    paddingTop: 12,
                    paddingHorz: 8,
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    UI(
                      child: dtFrom,
                      maxWidth: 180,
                      maxHeight: 52,
                      paddingTop: 8,
                      paddingHorz: 8,
                    ),
                    UI(
                      child: dtTo,
                      maxWidth: 180,
                      maxHeight: 52,
                      paddingTop: 8,
                      paddingHorz: 8,
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                    child: UI(
                      child: chkShowDetails,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                    child: ElevatedButton(
                        onPressed: () async => searchClick(),
                        child: const Text('  بحث  ')),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                    child: ElevatedButton(
                        onPressed: () async => searchClick(1),
                        child: Text(Platform.isWindows
                            ? '  معاينة قبل الطباعة  '
                            : (Platform.isAndroid ? ' نسخة للطباعة ' : ''))),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                    child: ElevatedButton(
                        onPressed: () async => searchClick(2),
                        child: Text(Platform.isWindows
                            ? '  طباعة  '
                            : (Platform.isAndroid
                                ? ' مشاركة نسخة مطبوعة '
                                : ''))),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DecoratedBox(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: UI(
                    child: grid,
                  ),
                ),
              ),
            ),
            UIPart(
                sumPart,
                (context) => UI(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
                    child: Text(
                      sumText,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.blue, fontSize: 12),
                    )))
          ],
        ));
  }

  searchClick([int btn = 0]) async {
    dynamic acc = accEdt.value;
    if (acc == null) {
      showSnack("يرجى تحديد الحساب.");
      return;
    }
    DateTime? d1 = dtFrom.value ?? DateTime.now();
    DateTime? d2 = dtTo.value ?? DateTime.now();
    var res = await api('kashf', {
      "cust": accEdt.value ?? '',
      "d1": defaultJsonDateFormat.format(d1),
      "d2": defaultJsonDateFormat.format(d2),
      "sbd": chkShowDetails.checked ? 1 : 0
    });

    if (showApiError(res)) return;
    await kashfTable.load(res['data']);
    grid.refreshItems(refreshMode: TGridRefreshMode.grmFilter);
    double tb = 0;
    for (int i = 0; i < kashfTable.recordCount; i++) {
      String s = kashfTable.madeen[i] ?? '';
      if (s.isNotEmpty) tb -= double.parse(s.replaceAll(',', ''));
      s = kashfTable.daen[i] ?? '';
      if (s.isNotEmpty) tb += double.parse(s.replaceAll(',', ''));
    }
    tb = (tb * 100).roundToDouble() / 100;
    if (tb > 0) {
      sumText = '$tb دائن';
    } else {
      sumText = '${-tb} مدين';
    }
    sumText = 'رصيد الحساب: $sumText';
    sumPart.notify();
    if (btn == 0) return;
    //print here
    if (btn == 1) {
      printKashf(accEdt.selectedIndex!, d1, d2, kashfTable, sumText, false);
    } else if (btn == 2) {
      if (Platform.isAndroid) {
        shareKashf(accEdt.selectedIndex!, d1, d2, kashfTable, sumText);
      } else if (Platform.isWindows) {
        printKashf(
          accEdt.selectedIndex!,
          d1,
          d2,
          kashfTable,
          sumText,
          true,
        );
      }
    }
  }
}

TKashfForm kashfForm = TKashfForm();
