import 'dart:io';
import 'package:flutter/material.dart';
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
import 'printteacher.dart';

class TTeacherTable extends TTable {
  late var date = strField(null, 'Date');
  late var notes = strField(date, 'Notes');
  late var madeen = strField(notes, 'Madeen');
  late var daen = strField(madeen, 'Daen');
  late var balance = strField(daen, 'Balance');
  late var doc = strField(balance, 'Num');
  TTeacherTable() {
    doc;
  }
}

class TTeacherForm extends TForm {
  late TTeacherTable teacherTable = TTeacherTable();
  late TLookupEdit accEdt = TLookupEdit(
      label: 'الحساب',
      buttonIcon: Icons.arrow_drop_down,
      table: accountsForm.accounts,
      contentPadding: const EdgeInsetsDirectional.only(bottom: 8, start: 6));

  late TDBGrid grid = TDBGrid(
    [
      TGridColumn(teacherTable.date, 'التاريخ'),
      TGridColumn(teacherTable.notes, 'البيان'),
      TGridColumn(teacherTable.madeen, 'مدين'),
      TGridColumn(teacherTable.daen, 'دائن'),
      TGridColumn(teacherTable.balance, 'الرصيد'),
      TGridColumn(teacherTable.doc, 'المستند'),
    ],
    settingsFileName: '${rootDir}teacherdgs.conf',
  );

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

  TTeacherForm() {
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
        appBarTitle: 'دفتر الأستاذ',
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
            // UIPart(
            //     sumPart,
            //     (context) => UI(
            //         padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
            //         child: Text(
            //           sumText,
            //           style: Theme.of(context)
            //               .textTheme
            //               .bodyMedium!
            //               .copyWith(color: Colors.blue, fontSize: 12),
            //         )))
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
    var res = await api('teacher', {
      "cust": accEdt.value ?? '',
      "d1": defaultJsonDateFormat.format(d1),
      "d2": defaultJsonDateFormat.format(d2)
    });
    if (showApiError(res)) return;
    await teacherTable.load(res['data']);
    grid.refreshItems(refreshMode: TGridRefreshMode.grmFilter);
    // double tb = 0;
    // for (int i = 0; i < teacherTable.recordCount; i++) {
    //   String s = teacherTable.madeen[i] ?? '';
    //   if (s.isNotEmpty) tb -= double.parse(s.replaceAll(',', ''));
    //   s = teacherTable.daen[i] ?? '';
    //   if (s.isNotEmpty) tb += double.parse(s.replaceAll(',', ''));
    // }
    // tb = (tb * 100).roundToDouble() / 100;
    // if (tb > 0) {
    //   sumText = '$tb دائن';
    // } else {
    //   sumText = '${-tb} مدين';
    // }
    // sumText = 'رصيد الحساب: $sumText';
    // sumPart.notify();
    if (btn == 0) return;
    //print here
    if (btn == 1) {
      printTeacher(accEdt.selectedIndex!, d1, d2, teacherTable, false);
    } else if (btn == 2) {
      if (Platform.isAndroid) {
        shareTeacher(accEdt.selectedIndex!, d1, d2, teacherTable);
      } else if (Platform.isWindows) {
        printTeacher(
          accEdt.selectedIndex!,
          d1,
          d2,
          teacherTable,
          true,
        );
      }
    }
  }
}

TTeacherForm teacherForm = TTeacherForm();
