import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'lib/andsysutils.dart';
import 'addclient.dart';
import 'my_reader.dart';
import 'package:flutter/material.dart';
import 'apptype.dart';
import 'clients.dart';
import 'additem.dart';
import 'api.dart';
import 'appui.dart';
import 'dayly.dart';
import 'errors.dart';
import 'lib/db/db.dart';
import 'lib/flutter_utils.dart';
import 'lib/ui/combo.dart';
import 'lib/ui/date_edit.dart';
import 'lib/ui/double_edit.dart';
import 'lib/ui/forms.dart';
import 'lib/ui/grid.dart';
import 'lib/ui/lookup_edit.dart';
import 'lib/ui/text_edit.dart';
import 'lib/ui/ui.dart';
import 'lib/utils.dart';
import 'materials.dart';
import 'options.dart';
import 'pagetemplate.dart';
import 'printbill.dart';
import 'printbill8cm.dart';
import 'printbilla4.dart';
import 'package:spell_num/spell_num.dart';
import 'package:tafqit/tafqit.dart';

class TItemsTable extends TTable {
  late final id = strField(null, 'id');
  late final name = strField(id, 'name');
  late final qty = doubleField(name, 'qty');
  late final price = doubleField(qty, 'price');
  late final total = doubleField(price, 'total');
  late final notes = strField(total, 'notes');
  late final unit = intField(notes, 'unit');
  late final unitName = strField(unit, 'unit_name');
  TItemsTable() {
    unitName;
  }
}

class TBarcodesTable extends TTable {
  late final id = strField(null, 'matid');
  late final unit = intField(id, 'unit');
  late final barcode = strField(unit, 'barcode');
  TBarcodesTable() {
    barcode;
  }
}

class TAddBillForm extends TForm {
  List<List> payTypes = [];
  List<List> payTypesNoNull = [];
  TUIPart sumPart = TUIPart();
  TUIPart prtSave = TUIPart();
  TItemsTable items = TItemsTable();
  TDateEdit timeEdt = TDateEdit(
    contentPadding: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
    showTime: true,
    value: DateTime.now(),
    label: "الوقت",
  );

  Future formShow() async {
    accEdt.buttonIcon =
        (isMazeed && canAddClient) ? Icons.add : Icons.arrow_drop_down;
    accEdt.onButtonPressed =
        (isMazeed && canAddClient) ? edtAccButtonPressed : null;
  }

  bool showBarcode = false;
  bool isSaving = false;
  late TDoubleEdit edtVatRate = TDoubleEdit(
      allowNegative: false,
      label: 'نسبة الضريبة',
      maximumFractionDigits: 2,
      onChange: payedChange,
      value: 15);
  late TCombobox bTypeEdt = TCombobox(
    contentPadding: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
    items: [
      [1, 'مبيعات'],
      [2, 'م. مبيعات'],
      [3, 'عرض سعر'],
      [4, 'محضر جرد'],
    ],
    label: 'نوع الفاتورة',
    value: 1,
    onChange: bTypeChange,
  );
  late TLookupEdit accEdt = TLookupEdit<String>(
      onSelected: accSelected,
      label: 'العميل',
      table: accountsForm.clients,
      searchFields: [accountsForm.clients.code, accountsForm.clients.name],
      contentPadding: const EdgeInsetsDirectional.only(bottom: 8, start: 6));

  String accPriceKind = '';
  late TDBGrid itemsGrid = TDBGrid(
      settingsFileName: '${rootDir}itemsgs.conf',
      [
        TGridColumn(items.name, 'المادة'),
        TGridColumn(items.unitName, 'الواحدة'),
        TGridColumn(items.qty, 'الكمية', format: ',###.###'),
        TGridColumn(items.price, 'السعر', format: ',###.##'),
        TGridColumn(items.total, 'الاجمالي', format: ',###.##'),
        TGridColumn(items.notes, 'ملاحظات'),
      ],
      popupMenuItems: ['حذف'],
      onMenuItemPressed: gridPopupClick,
      onCellTap: gridCellTap);
  late TDoubleEdit discEdt = TDoubleEdit(
      value: 0, label: 'الحسم', onChange: discChange, allowNegative: true);
  late TDoubleEdit payedEdt = TDoubleEdit(
    value: 0,
    onChange: payedChange,
    label: 'المبلغ المدفوع',
  );

  late TCombobox payType = TCombobox(
    contentPadding: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
    label: 'نوع الدفع',
    onChange: payTypeChange,
    items: isMazeed ? payTypesNoNull : payTypes,
  );

  //used in mazeed only
  late TCombobox edtActAcc = TCombobox(
      contentPadding: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
      label: 'نوع الدفع',
      onChange: actAccChange,
      items: addBillForm.payTypes);

  TBarcodesTable barcodes = TBarcodesTable();
  TTextEdit notesEdt = TTextEdit(label: 'ملاحظات');
  TAddBillForm() : super() {
    onShow = formShow;
  }

  late bool _isEdit;
  bool _isTTC = false;
  double tax = 0;
  double total = 0;
  double net = 0;
  double remain = 0;
  String title = '';

  final player = AudioPlayer();

  accSelected(String? val, int? index) {
    if (index == null || index < 0) {
      accPriceKind = '';
    } else {
      accPriceKind = priceKinds[accountsForm.clients.priceKind[index] ?? 0];
    }
  }

  prepareNew(int bt) {
    _isEdit = false;
    bTypeEdt.value = bt;
    if (!isMazeed) _isTTC = getTTC();
    timeEdt.value = DateTime.now();
    accEdt.value = null;
    accPriceKind = '';
    payedEdt.value = 0;
    edtVatRate.value = optionsForm.taxRateEdt.value ?? 0;
    items.clear();
    itemsGrid.refreshItems();
    discEdt.value = 0;
    if (!isMazeed) {
      payType.value = null;
    } else {
      edtActAcc.value = 1;
      payType.value = 0;
    }
    notesEdt.value = '';
    recalc();
    if (bt == 1) {
      title = 'إضافة فاتورة مبيعات';
    } else if (bt == 2) {
      bTypeEdt.value = 2;
      title = 'إضافة فاتورة مرتجع مبيعات';
    } else if (bt == 3) {
      bTypeEdt.value = 3;
      title = 'إضافة عرض سعر';
    } else if (bt == 4) {
      bTypeEdt.value = 4;
      title = 'إضافة محضر جرد';
    } else {
      title = '';
    }
  }

  prepareEdit(bill) async {
    _isEdit = true;
    timeEdt.value = DateTime.parse(bill['time']);
    accEdt.value = bill['account'];
    payedEdt.value = bill['payed'] ?? 0.0;
    edtVatRate.value = bill['vatrate'];

    if (!isMazeed) _isTTC = bill['ttc'] ?? false;
    items.clear();
    for (int i = 0; i < bill['items'].length; i++) {
      await items.add(() {
        items.id.value = bill['items'][i]['id'];
        items.name.value = bill['items'][i]['name'];
        items.notes.value = bill['items'][i]['notes'];
        items.price.value = bill['items'][i]['price'];
        items.qty.value = bill['items'][i]['amount'];
        items.unit.value = bill['items'][i]['unit'];
        items.unitName.value = bill['items'][i]['unit_name'];
        items.total.value =
            bill['items'][i]['price'] * bill['items'][i]['amount'];
      });
    }
    itemsGrid.refreshItems();
    discEdt.value = bill['disc'];
    payType.value = bill['payacc'];
    if (isMazeed) {
      edtActAcc.value = bill['actacc'];
    }

    notesEdt.value = bill['notes'];
    recalc();
    if (bill['btype'] == 1) {
      title = 'عرض فاتورة مبيعات ${bill['num']}';
    } else if (bill['btype'] == 2) {
      bTypeEdt.value = 2;
      title = 'عرض فاتورة مرتجع مبيعات ${bill['num']}';
    } else if (bill['btype'] == 3) {
      bTypeEdt.value = 3;
      title = 'عرض سعر ${bill['num']}';
    } else if (bill['btype'] == 4) {
      bTypeEdt.value = 4;
      title = 'عرض محضر جرد ${bill['num']}';
    } else {
      title = '';
    }
  }

  recalc() {
    total = 0;
    tax = 0;
    for (int i = 0; i < items.recordCount; i++) {
      total += items.total[i] ?? 0;
    }
    total = (total * 100).roundToDouble() / 100;
    if (!_isTTC) {
      tax = ((total - (discEdt.value ?? 0)) * (edtVatRate.value ?? 0))
              .roundToDouble() /
          100;
      net = total + tax - (discEdt.value ?? 0);
    } else {
      tax = ((total - (discEdt.value ?? 0)) * (edtVatRate.value ?? 0)) /
          (100 + (edtVatRate.value ?? 0));
      tax = (tax * 100).roundToDouble() / 100;
      net = total - (discEdt.value ?? 0);
    }
    net = (net * 100).roundToDouble() / 100;
    remain = (payType.value == null) ? net : net - (payedEdt.value ?? 0);
    remain = (remain * 100).roundToDouble() / 100;
    if (remain <= 0.02) remain = 0;
    sumPart.notify();
  }

  gridCellTap(TCellCoordinates details) async {
    addItemForm.init(
        items.id[details.tableRowIndex],
        items.qty[details.tableRowIndex] ?? 0,
        items.price[details.tableRowIndex] ?? 0,
        items.notes[details.tableRowIndex] ?? '',
        items.unit[details.tableRowIndex] ?? 1,
        priceField == 'حسب الزبون' ? accPriceKind : priceField);
    var r = await addItemForm.showModal();
    if (r == null) return;
    await items.edit(details.tableRowIndex, () {
      items.id.value = r[0];
      items.name.value = r[1];
      items.qty.value = r[2];
      items.price.value = r[3];
      items.notes.value = r[4];
      items.total.value = r[2] * r[3];
      items.unit.value = r[5];
      items.unitName.value = r[6];
    });
    itemsGrid.refreshItems();
    recalc();
  }

  save() async {
    if (bTypeEdt.value == 1 && !canAddBill) {
      showSnack('ليس لديك صلاحيات لإضافة فاتورة مبيعات');
      return;
    }
    if (bTypeEdt.value == 2 && !canAddReturn) {
      showSnack('ليس لديك صلاحيات لإضافة فاتورة مرتجع مبيعات');
      return;
    }
    if (bTypeEdt.value == 3 && !canAddPrice) {
      showSnack('ليس لديك صلاحيات لإضافة عرض سعر');
      return;
    }
    if (bTypeEdt.value == 4 && !canAddStock) {
      showSnack('ليس لديك صلاحيات لإضافة محضر جرد');
      return;
    }
    recalc();
    if (timeEdt.value == null ||
        (accEdt.selectedIndex ?? -1) < 0 ||
        total == 0 ||
        items.recordCount == 0 ||
        (payedEdt.value ?? 0) < 0 ||
        remain < 0 ||
        (total - (discEdt.value ?? 0)) < 0) {
      showSnack("يرجى إدخال كافة البيانات المطلوبة بشكل صحيح.");
      return;
    }
    if (isMazeed) {
      if (edtActAcc.value == payType.value && payedEdt.value != 0) {
        showSnack("لا يمكن استخدام نفس نوع الدفع للفاتورة والدفعة.");
        return;
      }
    }

    var j = {
      "comp_name": licCompName,
      "comp_taxnum": licTaxNum,
      "account": accEdt.value,
      "acccode": accountsForm.clients.code[accEdt.selectedIndex ?? -1],
      "accname": accountsForm.clients.name[accEdt.selectedIndex ?? -1],
      "accaddress": accountsForm.clients.address[accEdt.selectedIndex ?? -1],
      "acctaxnum": accountsForm.clients.taxNum[accEdt.selectedIndex ?? -1],
      "time": defaultJsonDateTimeFormat.format(timeEdt.value ?? DateTime.now()),
      "btype": bTypeEdt.value ?? 1,
      "vatrate": edtVatRate.value ?? 0.0,
      "disc": discEdt.value ?? 0.0,
      "payacc": payType.value ?? (isMazeed ? 1 : ''),
      if (isMazeed) "actacc": edtActAcc.value ?? 1,
      if (!isMazeed)
        "payed": payType.itemIndex == 0 ? 0.0 : payedEdt.value ?? 0.0,
      if (isMazeed) "payed": payedEdt.value ?? 0.0,
      "notes": notesEdt.value ?? '',
      if (!isMazeed) "ttc": _isTTC,
      if (isMazeed) "aronly": onlyStr(total, TafqitUnitCode.saudiRiyal),
      if (isMazeed) "enonly": spellNum(total, 2, ' Saudi riyals', 'halalas'),
      if (isMazeed)
        "restonly": (edtActAcc.value ?? 0) != 1
            ? onlyStr(0, TafqitUnitCode.saudiRiyal)
            : onlyStr(remain, TafqitUnitCode.saudiRiyal),
      "items": List.generate(
          items.recordCount,
          (index) => {
                "id": items.id[index],
                "name": items.name[index],
                "amount": items.qty[index] ?? 0.0,
                "price": items.price[index] ?? 0.0,
                "notes": items.notes[index] ?? '',
                "unit": items.unit[index] ?? 0.0,
                "unit_name": items.unitName[index] ?? '',
              })
    };
    isSaving = true;
    prtSave.refresh();
    var res = await api('addbill', j);
    isSaving = false;
    prtSave.refresh();
    j['new_balance'] = res['new_balance'];
    j['logid'] = res['logid'];
    if (showApiError(res)) return;
    j['num'] = res['num'];
    await close();
    await daylyForm.searchClick();
    showSnack("تم الحفظ بنجاح");
    if ((optionsForm.cmbAfterBillAdd.value ?? '') == 'pre') {
      printBill<BillPrintA4>(BillPrintA4(), j, false, () async {});
    } else if ((optionsForm.cmbAfterBillAdd.value ?? '') == 'pri' &&
        Platform.isWindows) {
      printBill(BillPrintA4(), j, true, () async {});
    } else if ((optionsForm.cmbAfterBillAdd.value ?? '') == 'pri' &&
        Platform.isAndroid) {
      printBill(BillPrint8Cm(), j, false, () async {});
    } else if ((optionsForm.cmbAfterBillAdd.value ?? '') == 'shr' &&
        Platform.isAndroid) {
      shareBill(BillPrintA4(), j);
    }
  }

  cancel() async {
    close();
  }

  bTypeChange(int itemIndex, value) {
    if (!_isEdit) {
      if (value == 1) {
        title = 'إضافة فاتورة مبيعات';
      }
      if (value == 2) {
        title = 'إضافة فاتورة مرتجع مبيعات';
      }
      if (value == 3) {
        title = 'إضافة عرض سعر';
      }
      if (value == 4) {
        title = 'إضافة محضر جرد';
      }
    }
    if (!isMazeed) _isTTC = getTTC();
    recalc();
    notify();
  }

  discChange(String text) {
    recalc();
  }

  payedChange(String text) {
    recalc();
  }

  addItemClick() async {
    addItemForm.init(null, 1, 0, '', 1,
        priceField == 'حسب الزبون' ? accPriceKind : priceField);
    var r = await addItemForm.showModal();
    if (r == null) return;
    await items.add(() {
      items.id.value = r[0];
      items.name.value = r[1];
      items.qty.value = r[2];
      items.price.value = r[3];
      items.notes.value = r[4];
      items.total.value = r[2] * r[3];
      items.unit.value = r[5];
      items.unitName.value = r[6];
    });
    itemsGrid.refreshItems();
    recalc();
  }

  addItemByBarcode(String barcode) async {
    var i = barcodes.barcode.findFirst(barcode);
    int? matindex;
    String? matid;
    if (i != null) matid = barcodes.id[i];
    if (matid != null) matindex = materialsForm.materials.id.findFirst(matid);
    if (matindex == null) {
      showSnack('باركود غير معروف');
      return;
    }
    var unit = barcodes.unit[i!] ?? 0;
    if (unit < 1 || unit > 5) return;
    String? unitName;
    double price = 0;
    if (unit == 1) {
      unitName = materialsForm.materials.unit1[matindex];
      price = materialsForm.materials.price1[matindex] ?? 0;
    } else if (unit == 2) {
      unitName = materialsForm.materials.unit2[matindex];
      price = materialsForm.materials.price2[matindex] ?? 0;
    } else if (unit == 3) {
      unitName = materialsForm.materials.unit3[matindex];
      price = materialsForm.materials.price3[matindex] ?? 0;
    } else if (unit == 4) {
      unitName = materialsForm.materials.unit4[matindex];
      price = materialsForm.materials.price4[matindex] ?? 0;
    } else if (unit == 5) {
      unitName = materialsForm.materials.unit5[matindex];
      price = materialsForm.materials.price5[matindex] ?? 0;
    }
    if ((unitName ?? '') == '') unitName = 'الواحدة الافتراضية';

    int? itemIndex;
    for (int i = 0; i < items.recordCount; i++) {
      if (items.id[i] == matid &&
          (items.price[i] ?? 0) == price &&
          items.unit[i] == unit) {
        itemIndex = i;
      }
    }

    if (itemIndex == null) {
      await items.add(() {
        items.id.value = matid;
        items.name.value = materialsForm.materials.name[matindex!];
        items.qty.value = 1;
        items.price.value = price;
        items.notes.value = '';
        items.total.value = price;
        items.unit.value = unit;
        items.unitName.value = unitName;
      });
    } else {
      await items.edit(itemIndex, () {
        items.qty.value = (items.qty.value ?? 0) + 1;
        items.total.value = (items.total.value ?? 0) + price;
      });
    }

    itemsGrid.refreshItems();
    recalc();
  }

  showBarcodClick() async {
    showBarcode = !showBarcode;
    notify();
  }

  gridPopupClick(int index, String text, TCellCoordinates details) async {
    await items.delete(details.tableRowIndex);
    itemsGrid.refreshItems(refreshMode: TGridRefreshMode.grmFilter);
    recalc();
  }

  payTypeChange(itemIndex, value) {
    if (!isMazeed) {
      if (payType.value != null) {
        payedEdt.value = net;
        accEdt.value ??= defaultPayedAccount;
        accEdt.refresh();
      }
      recalc();
    }
  }

  actAccChange(itemIndex, value) {
    if (!isMazeed) {
      if (edtActAcc.value != null) {
        accEdt.value ??= defaultPayedAccount;
        accEdt.refresh();
      }
    } else {
      if (edtActAcc.value != 1) {
        accEdt.value ??= defaultPayedAccount;
        accEdt.refresh();
      }
      if (edtActAcc.value == 0) {
        payType.value = 2;
      } else if (edtActAcc.value == 2) {
        payType.value = 0;
      }
    }
  }

  updatePayTypes(types) {
    if (isMazeed) {
      payTypes = [
        [0, 'نقدي'],
        [1, 'آجل'],
        [2, 'شبكة'],
        [3, 'بنكي'],
      ];
      payTypesNoNull = [
        [0, 'نقدي'],
        [2, 'شبكة']
      ];
    } else {
      payTypes = [
        [null, 'آجل']
      ];
      payTypesNoNull = [];
      for (int i = 0; i < types.length; i++) {
        payTypes.add([types[i]['Account'], types[i]['Name']]);
        payTypesNoNull.add([types[i]['Account'], types[i]['Name']]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TTemplatePage(
        showBottomBar: false,
        activeIndex: 0,
        showAppBar: false,
        appBarTitle: '',
        showBackButton: false,
        child: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                children: [
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Text(
                              title,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            UI(
                              child: bTypeEdt,
                              width: 140,
                              maxHeight: 60,
                              paddingAll: 4,
                            ),
                            Expanded(
                                child: UI(
                              child: timeEdt,
                              maxHeight: 60,
                              paddingAll: 4,
                            ))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: DefaultTextStyle(
                                style: const TextStyle(fontSize: 12),
                                child: UI(
                                  child: accEdt,
                                  maxHeight: 60,
                                  paddingAll: 4,
                                ),
                              ),
                            ),
                            if (isMazeed)
                              UI(
                                child: edtActAcc,
                                maxHeight: 60,
                                width: 80,
                                paddingAll: 4,
                              ),
                          ],
                        ),
                        UI(
                            maxHeight: 30,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: addItemClick,
                                    icon: const Icon(
                                      Icons.add,
                                    )),
                                const Expanded(
                                    child: Center(child: Text('المواد'))),
                                IconButton(
                                    onPressed: showBarcodClick,
                                    icon: const Icon(Icons.barcode_reader))
                              ],
                            )),
                        if (showBarcode)
                          UI(
                            height: 200,
                            child: ReaderWidget(
                              onScan: (p0) async {
                                if (p0.isValid &&
                                    p0.text != null &&
                                    p0.text != '') {
                                  await player.play(AssetSource('barcode.mp3'));
                                  addItemByBarcode(p0.text!);
                                } else {
                                  showSnack('باركود غير صحيح.');
                                }
                              },
                            ),
                          ),
                        UI(
                          border: Border.all(color: Colors.black),
                          paddingAll: 8,
                          child: itemsGrid,
                          maxHeight: 250,
                        ),
                        UIPart(sumPart, (context) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('المجموع: ${float2ArFormat.format(total)}'),
                              Row(
                                children: [
                                  UI(
                                    child: discEdt,
                                    paddingAll: 4,
                                    width: 100,
                                    maxHeight: 50,
                                  ),
                                  const Text('    '),
                                  UI(
                                    child: edtVatRate,
                                    paddingAll: 4,
                                    width: 100,
                                    maxHeight: 50,
                                  ),
                                ],
                              ),
                              UI(
                                  paddingAll: 4,
                                  paddingBottom: 8,
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                      "الضريبة: ${float2ArFormat.format(tax)}، الصافي: ${float2ArFormat.format(net)}")),
                              Row(
                                children: [
                                  UI(
                                    child: payType,
                                    paddingAll: 4,
                                    width: 100,
                                    maxHeight: 60,
                                  ),
                                  if (payType.itemIndex > 0 || isMazeed)
                                    UI(
                                      child: payedEdt,
                                      paddingAll: 4,
                                      width: 100,
                                      maxHeight: 60,
                                    ),
                                  if (payType.itemIndex > 0 || isMazeed)
                                    UI(
                                        paddingAll: 4,
                                        child: Text(
                                            "المتبقي ${float2ArFormat.format(remain)}")),
                                ],
                              ),
                            ],
                          );
                        }),
                        UI(
                          child: notesEdt,
                          paddingAll: 4,
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
              )),
        ));
  }

  bool getTTC() {
    if (isMazeed) return false;
    if (_isEdit) return _isTTC;
    int bt = bTypeEdt.value ?? 1;
    if (bt == 1) return isBillTTC;
    if (bt == 2) return isReturnTTC;
    if (bt == 3) return isPriceTTC;
    if (bt == 4) return isStockTTC;
    return false;
  }

  edtAccButtonPressed() async {
    addClientForm.prepareNew();
    var r = await addClientForm.showModal();
    if (r == null) return;
    var i = await accountsForm.clients.add(() {
      accountsForm.clients.address.value = r['Address'];
      accountsForm.clients.code.value = r['code'];
      accountsForm.clients.id.value = r['id'];
      accountsForm.clients.name.value = r['name'];
      accountsForm.clients.number.value = r['number'];
      accountsForm.clients.phone.value = r['phone'];
      accountsForm.clients.priceKind.value = r['CustPrice'];
      accountsForm.clients.taxNum.value = r['TaxNum'];
    });
    accEdt.updateItems();
    accEdt.selectedIndex = i;
    accEdt.refresh();
    accSelected(accEdt.value, accEdt.selectedIndex);
  }
}

TAddBillForm addBillForm = TAddBillForm();
