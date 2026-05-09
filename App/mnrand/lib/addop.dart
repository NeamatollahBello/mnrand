import 'dart:io';

import 'package:flutter/material.dart';
import 'dayly.dart';
import 'options.dart';
import 'printpayin.dart';
import 'printpayin8cm.dart';
import 'apptype.dart';
import 'clients.dart';
import 'addbill.dart';
import 'api.dart';
import 'errors.dart';
import 'lib/db/db.dart';
import 'lib/flutter_utils.dart';
import 'lib/ui/combo.dart';
import 'lib/ui/date_edit.dart';
import 'lib/ui/double_edit.dart';
import 'lib/ui/forms.dart';
import 'lib/ui/lookup_edit.dart';
import 'lib/ui/text_edit.dart';
import 'lib/ui/ui.dart';
import 'pagetemplate.dart';

class TAddOpForm extends TForm {
  TAddOpForm() : super();
  int opType = 0;
  late bool _isEdit;
  bool isSaving = false;
  TUIPart prtSave = TUIPart();
  //0 general, 1 payin, 2 payout, 3 spend, 4 discout, 5 discin
  List<String> titles = [
    'اضافة قبد عام',
    'إضافة سند قبض',
    'إضافة سند دفع',
    'إضافة مصروف',
    'إضافة حسم ممنوح',
    'إضافة حسم مكتسب'
  ];
  prepareNew(int opt) {
    _isEdit = false;
    opType = opt;
    title = titles[opt];
    edtAcc.value = null;
    edtAcc2.value = null;
    edtTime.value = DateTime.now();
    edtAmount.value = 0;
    edtNotes.value = '';
    edtPayType.itemIndex = 0;
    if (opt == 0) {
      edtAcc.label = 'دائن';
    } else if (opt == 1 || opt == 2 || opt == 4 || opt == 5) {
      edtAcc.label = 'الزبون';
    }
  }

  prepareEdit(op) async {
    _isEdit = true;
    opType = op['optype'];
    title = titles[opType].replaceFirst('إضافة', 'عرض');
    edtAcc.value = opType == 3 ? null : op['acc1'];
    edtAcc2.value = opType == 0 ? op['acc2'] : null;
    edtTime.value = DateTime.parse(op['time']);
    edtAmount.value = op['amount'];
    edtNotes.value = op['notes'];
    if (opType == 3) {
      edtPayType.value = op['acc1'];
    } else if (opType == 1 || opType == 2) {
      edtPayType.value = op['acc2'];
    } else {
      edtPayType.value = null;
    }

    if (opType == 0) {
      edtAcc.label = 'دائن';
    } else if (opType == 1 || opType == 2 || opType == 4 || opType == 5) {
      edtAcc.label = 'الزبون';
    }
  }

  String title = '';
  TDateEdit edtTime = TDateEdit(
    contentPadding: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
    showTime: true,
    value: DateTime.now(),
    label: "الوقت",
  );

  late TLookupEdit edtAcc = TLookupEdit<String>(
      label: 'الحساب',
      table: accountsForm.clients,
      searchFields: [accountsForm.clients.name, accountsForm.clients.code],
      buttonIcon: Icons.arrow_drop_down,
      contentPadding: const EdgeInsetsDirectional.only(bottom: 8, start: 6));

  late TLookupEdit edtAcc2 = TLookupEdit<String>(
      label: 'مدين',
      table: accountsForm.clients,
      searchFields: [accountsForm.clients.name, accountsForm.clients.code],
      buttonIcon: Icons.arrow_drop_down,
      contentPadding: const EdgeInsetsDirectional.only(bottom: 8, start: 6));

  late TDoubleEdit edtAmount = TDoubleEdit(
    value: 0,
    label: 'المبلغ',
  );

  late TCombobox edtPayType = TCombobox(
    contentPadding: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
    label: 'نوع الدفع',
    items: addBillForm.payTypesNoNull,
  );

  TTextEdit edtNotes = TTextEdit(label: 'ملاحظات');

  @override
  Widget build(BuildContext context) {
    return TTemplatePage(
        showBottomBar: false,
        activeIndex: 0,
        showAppBar: false,
        appBarTitle: '',
        showBackButton: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  UI(
                    paddingAll: 8,
                    child: Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.red),
                    ),
                  ),
                  UI(
                    child: edtTime,
                    maxHeight: 70,
                    paddingAll: 8,
                  ),
                  if (opType != 3)
                    UI(
                      child: edtAcc,
                      maxHeight: 70,
                      paddingAll: 8,
                    ),
                  if (opType == 0)
                    UI(
                      child: edtAcc2,
                      maxHeight: 70,
                      paddingAll: 8,
                    ),
                  UI(
                    maxHeight: 70,
                    paddingHorz: 8,
                    paddingTop: 8,
                    child: Row(
                      children: [
                        if (opType == 1 || opType == 2 || opType == 3)
                          UI(
                            child: edtAmount,
                            maxWidth: 150,
                            maxHeight: 70,
                          )
                        else
                          Expanded(
                            child: UI(
                              child: edtAmount,
                              maxHeight: 70,
                            ),
                          ),
                        if (opType == 1 || opType == 2 || opType == 3)
                          Expanded(
                              child: UI(
                            paddingStart: 8,
                            child: edtPayType,
                            maxHeight: 70,
                          ))
                      ],
                    ),
                  ),
                  UI(
                    child: edtNotes,
                    maxHeight: 70,
                    paddingHorz: 8,
                    paddingBottom: 8,
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isEdit)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UIPart(prtSave, (context) {
                      return ElevatedButton(
                          onPressed: isSaving ? null : save,
                          child: const Text('موافق'));
                    }),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: cancel,
                      child: Text(_isEdit ? 'إغلاق' : 'إلغاء الأمر')),
                ),
              ],
            )
          ],
        ));
  }

  void save() async {
    if ((opType != 3 && edtAcc.value == null) ||
        (edtTime.value == null) ||
        (opType == 0 && edtAcc2.value == null) ||
        ((edtAmount.value ?? 0) == 0) ||
        (edtPayType.value == null &&
            (opType == 1 || opType == 2 || opType == 3))) {
      showSnack('يرجى إدخال جميع البيانات المطلوبة.');
      return;
    }
    isSaving = true;
    prtSave.refresh();
    var j = {
      'optype': opType,
      'time': defaultJsonDateTimeFormat.format(edtTime.value ?? DateTime.now()),
      'notes': edtNotes.value ?? '',
      'amount': edtAmount.value ?? 0,
      'acc1': (opType == 3)
          ? (edtPayType.value ?? (isMazeed ? 0 : ''))
          : (edtAcc.value ?? ''),
      'acc2': (opType == 0)
          ? (edtAcc2.value ?? '')
          : opType <= 2
              ? (edtPayType.value ?? (isMazeed ? 0 : ''))
              : '',
      //next parameters are used for log
      "account": (opType == 3) ? null : edtAcc.value,
      "acccode": (opType == 3)
          ? ''
          : accountsForm.clients.code[edtAcc.selectedIndex ?? -1],
      "accname": (opType == 3)
          ? ''
          : accountsForm.clients.name[edtAcc.selectedIndex ?? -1],
    };

    var res = await api('addop', j);
    j['new_balance'] = res['new_balance'];
    j['num'] = res['num'];
    isSaving = false;
    prtSave.refresh();
    if (showApiError(res)) return;
    await close(1);
    await daylyForm.searchClick();
    showSnack("تم حفظ العملية بنجاح");
    if (j['optype'] == 1) {
      if ((optionsForm.cmbAfterBillAdd.value ?? '') == 'pre') {
        printPayIn(PayInPrint8Cm(), j, false, () async {});
      } else if ((optionsForm.cmbAfterBillAdd.value ?? '') == 'pri' &&
          Platform.isWindows) {
        printPayIn(PayInPrint8Cm(), j, true, () async {});
      } else if ((optionsForm.cmbAfterBillAdd.value ?? '') == 'pri' &&
          Platform.isAndroid) {
        printPayIn(PayInPrint8Cm(), j, false, () async {});
      } else if ((optionsForm.cmbAfterBillAdd.value ?? '') == 'shr' &&
          Platform.isAndroid) {
        sharePayIn(PayInPrint8Cm(), j);
      }
    }
  }

  void cancel() {
    close(null);
  }
}

TAddOpForm addOpForm = TAddOpForm();
