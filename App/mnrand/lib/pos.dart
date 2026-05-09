import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'my_reader.dart';
import 'package:flutter/material.dart';
import 'package:group_grid_view/group_grid_view.dart';
import 'addbill.dart';
import 'api.dart';
import 'appsettings.dart';
import 'appui.dart';
import 'clients.dart';
import 'dayly.dart';
import 'errors.dart';
import 'lib/db/db.dart';
import 'lib/flutter_utils.dart';
import 'lib/ui/combo.dart';
import 'lib/ui/forms.dart';
import 'lib/ui/text_edit.dart';
import 'lib/ui/ui.dart';
import 'lib/utils.dart';
import 'materials.dart';
import 'options.dart';
import 'posedit.dart';
import 'printbill.dart';
import 'printbill8cm.dart';
import 'printbilla4.dart';
import 'package:spell_num/spell_num.dart';
import 'package:tafqit/tafqit.dart';
import 'apptype.dart';

class TPosForm extends TForm {
  TPosForm() : super() {
    onClosed = () async {
      if (needRefreshDayly) {
        daylyForm.searchClick();
      }
    };
  }
  bool needRefreshDayly = false;
  late TTextEdit edtSearch = TTextEdit(
    label: 'البحث',
    onChange: (text) {
      searchText = text;
      refresh();
    },
  );
  String searchText = '';
  int searchMode =
      0; //0 no search is active, 1 search by typing, 2 search by scanning barcode
  double vatRate = 0;
  TUIPart sumview = TUIPart();
  num lineCount = 0, quantitySum = 0, billSum = 0;
  TItemsTable items = TItemsTable();
  late TCombobox payType = TCombobox(
    contentPadding: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
    label: 'نوع الدفع',
    items: addBillForm.payTypesNoNull,
  )..itemIndex = 0;

  recalc() {
    lineCount = items.recordCount;
    quantitySum = 0;
    billSum = 0;
    for (int i = 0; i < items.recordCount; i++) {
      quantitySum += items.qty[i] ?? 0;
      billSum += items.total[i] ?? 0;
    }
    if (!isBillTTC) {
      billSum = billSum + vatRate.roundToDouble() * billSum / 100;
    }
  }

  prepareNew() {
    items.clear();
    payType.itemIndex = 0;
    vatRate = optionsForm.taxRateEdt.value ?? 0;
    recalc();
    sumview.refresh();
  }

  addMaterial(int index) async {
    double price;
    if (isMazeed) {
      List jp = jsonDecode(materialsForm.materials.prices1[index] ?? '[]');
      var p = jp.firstWhere(
          (element) => element['PriceKind'] == defaultPayedPrice,
          orElse: () => {"Price": 0.0});
      price = p['Price'].toDouble();
    } else {
      price = materialsForm.materials.price1[index] ?? 0;
    }
    if ((materialsForm.materials.isttc[index] ?? 0) == 1) {
      price = price / 1.15;
    }

    var matid = materialsForm.materials.id[index];

    int? itemIndex;
    for (int i = 0; i < items.recordCount; i++) {
      if (items.id[i] == matid &&
          (items.price[i] ?? 0) == price &&
          items.unit[i] == 1) {
        itemIndex = i;
      }
    }
    if (itemIndex == null) {
      await items.add(
        () {
          items.id.value = materialsForm.materials.id[index];
          items.name.value = materialsForm.materials.name[index];
          items.notes.value = '';
          items.price.value = price;
          items.qty.value = 1;
          items.total.value = items.price.value ?? 0;
          items.unit.value = 1;
          items.unitName.value =
              materialsForm.materials.unit1[index] ?? 'الواحدة الافتراضية';
        },
      );
    } else {
      await items.edit(itemIndex, () {
        items.qty.value = (items.qty.value ?? 0) + 1;
        items.total.value = (items.total.value ?? 0) + price;
      });
    }
    recalc();
    sumview.refresh();
  }

  save() async {
    if (items.recordCount == 0) {
      showSnack("لم يتم اختيار اي مواد.");
      return;
    }
    var accIndex = accountsForm.clients.id.findFirst(defaultPayedAccount);
    if (accIndex == null) {
      showSnack("لم يتم تحديد الحساب النقدي.");
      return;
    }
    var accName = accountsForm.clients.name[accIndex] ?? '';
    var accCode = accountsForm.clients.code[accIndex] ?? '';
    var accAddress = accountsForm.clients.address[accIndex] ?? '';
    var accTaxNum = accountsForm.clients.taxNum[accIndex] ?? '';

    var j = {
      "account": defaultPayedAccount,
      "acccode": accCode,
      "accname": accName,
      "accaddress": accAddress,
      "acctaxnum": accTaxNum,
      "time": defaultJsonDateTimeFormat.format(DateTime.now()),
      "btype": 1,
      "vatrate": vatRate,
      "disc": 0.0,
      if (!isMazeed) "payacc": addBillForm.payTypesNoNull[payType.itemIndex][0],
      if (isMazeed) "payacc": 0,
      if (isMazeed) "actacc": addBillForm.payTypesNoNull[payType.itemIndex][0],
      if (!isMazeed) "payed": billSum,
      if (isMazeed) "payed": 0.0,
      "notes": '',
      if (!isMazeed) "ttc": isBillTTC,
      if (isMazeed) "aronly": onlyStr(billSum / 1.0, TafqitUnitCode.saudiRiyal),
      if (isMazeed)
        "enonly": spellNum(billSum / 1.0, 2, ' Saudi riyals', 'halalas'),
      if (isMazeed) "restonly": onlyStr(0, TafqitUnitCode.saudiRiyal),
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

    var res = await api('addbill', j);
    if (showApiError(res)) return;
    j['num'] = res['num'];
    needRefreshDayly = true;
    prepareNew();
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

  @override
  Widget build(BuildContext context) {
    List<TFilteredMaterialGroup>? filteredGroups;
    if (searchText.trim().isNotEmpty && searchMode == 1) {
      filteredGroups = materialsForm.groupMaterialsWithFilter(searchText);
    }
    var showPrice = optionsForm.edtShowPriceInPOS.checked;
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          const Text('نقطة بيع'),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search),
            color: searchMode == 1 ? Colors.white : Colors.black,
            onPressed: () async {
              searchMode = searchMode == 1 ? 0 : 1;
              refresh();
            },
          ),
          IconButton(
            icon: const Icon(Icons.barcode_reader),
            color: searchMode == 2 ? Colors.white : Colors.black,
            onPressed: () async {
              searchMode = searchMode == 2 ? 0 : 2;
              refresh();
            },
          ),
          if (isOnlyPOS)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await setApiToken('', true);
                close();
              },
            )
        ],
      )),
      body: UI(
        paddingAll: 8,
        child: Column(
          children: [
            if (searchMode == 2)
              UI(
                height: 150,
                paddingBottom: 4,
                color: Colors.black,
                child: ReaderWidget(
                  onScan: (p0) async {
                    if (p0.isValid && p0.text != null && p0.text != '') {
                      await addBillForm.player.play(AssetSource('barcode.mp3'));
                      var matindex =
                          materialsForm.materials.barcode1.findFirst(p0.text);
                      if (matindex != null) addMaterial(matindex);
                    } else {
                      showSnack('باركود غير صحيح.');
                    }
                  },
                ),
              ),
            if (searchMode == 1)
              UI(
                child: edtSearch,
                paddingBottom: 4,
              ),
            Expanded(
                child: GroupGridView(
              cacheExtent: 0,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120),
              sectionCount: filteredGroups == null
                  ? materialsForm.groups.length
                  : filteredGroups.length,
              itemInSectionCount: filteredGroups == null
                  ? ((section) {
                      return materialsForm.groups[section].count;
                    })
                  : ((section) {
                      return filteredGroups![section].indexes.length;
                    }),
              headerForSection: (section) {
                return UI(
                    paddingTop: section == 0 ? 0 : 14,
                    paddingBottom: 2,
                    paddingStart: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          filteredGroups == null
                              ? materialsForm.groups[section].name
                              : filteredGroups[section].name,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 48, 46, 91),
                              fontWeight: FontWeight.w800),
                        ),
                        const Divider()
                      ],
                    ));
              },
              itemInSectionBuilder: (context, indexPath) {
                int index = filteredGroups == null
                    ? materialsForm.groups[indexPath.section].startIndex +
                        indexPath.index
                    : filteredGroups[indexPath.section]
                        .indexes[indexPath.index];
                return UI(
                  useMaterial: true,
                  onClick: () async {
                    await addMaterial(index);
                  },
                  border: Border.all(
                      color: const Color.fromARGB(255, 152, 16, 183)),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  paddingAll: 3,
                  color: const Color.fromARGB(255, 59, 123, 206),
                  ialignment: Alignment.center,
                  child: Text(
                    showPrice
                        ? ('${materialsForm.materials.name[index]}\n${float2ArFormat.format(materialsForm.materials.price1[index] ?? 0)}')
                        : (materialsForm.materials.name[index] ?? ''),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                );
              },
            )),
            const Divider(),
            UIPart(
              sumview,
              (context) {
                return Column(
                  children: [
                    UI(
                      paddingAll: 4,
                      child: Text(
                          'مجموع العدد: $lineCount، مجموع الكمية: ${float3ArFormat.format(quantitySum)}'),
                    ),
                    UI(
                      paddingAll: 4,
                      child: Text(
                          'مجموع الفاتورة: ${float2ArFormat.format(billSum)}'),
                    ),
                  ],
                );
              },
            ),
            UI(
              paddingTop: 8,
              height: 40,
              child: CustomScrollView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                slivers: [
                  SliverToBoxAdapter(
                    child: UI(
                      paddingAll: 4,
                      child: ElevatedButton(
                        child: const Text('عرض'),
                        onPressed: () {
                          posEditForm.itemsGrid.refreshItems();
                          posEditForm.showModal();
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: UI(
                      paddingAll: 4,
                      child: ElevatedButton(
                        child: const Text(
                          'تصفير',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w900),
                        ),
                        onPressed: () {
                          prepareNew();
                        },
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    fillOverscroll: false,
                    hasScrollBody: false,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        UI(
                          width: 90,
                          height: 40,
                          child: payType,
                        ),
                        UI(
                          paddingAll: 4,
                          child: ElevatedButton(
                            onPressed: save,
                            child: const Text(
                              'حفظ',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TPosForm posForm = TPosForm();
