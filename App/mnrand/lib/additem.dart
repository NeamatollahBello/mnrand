import 'dart:convert';
import 'package:flutter/material.dart';
import 'addmaterial.dart';
import 'apptype.dart';
import 'appui.dart';
import 'lib/flutter_utils.dart';
import 'lib/ui/combo.dart';
import 'lib/ui/double_edit.dart';
import 'lib/ui/forms.dart';
import 'lib/ui/lookup_edit.dart';
import 'lib/ui/text_edit.dart';
import 'lib/ui/ui.dart';
import 'materials.dart';
import 'pagetemplate.dart';

class TAddItemForm extends TForm {
  TAddItemForm() : super() {
    onShow = () async {
      priceEdt.readOnly = canChangePrice > 2;
      matLookup.updateItems();
      matLookup.buttonIcon =
          (isMazeed && canAddClient) ? Icons.add : Icons.arrow_drop_down;
      matLookup.onButtonPressed =
          (isMazeed && canAddClient) ? matLookupButtonPressed : null;
    };
  }
  String priceKind = '';
  late TLookupEdit<String> matLookup = TLookupEdit<String>(
      table: materialsForm.materials,
      searchFields: [
        materialsForm.materials.name,
        materialsForm.materials.code,
        materialsForm.materials.group,
        materialsForm.materials.barcode1
      ],
      buttonIcon: Icons.arrow_drop_down,
      label: 'المادة',
      onSelected: matSelected,
      contentPadding: const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 8));
  TDoubleEdit qtyEdt = TDoubleEdit(label: 'الكمية');
  TDoubleEdit priceEdt = TDoubleEdit(label: 'السعر');
  TTextEdit notesEdt = TTextEdit(label: 'ملاحظات');
  double getPrice(int? matIndex, int priceIndex) {
    double r = 0;
    if (priceIndex == 1) {
      r = materialsForm.materials.price1[matIndex ?? -1] ?? 0;
    }
    if (priceIndex == 2) {
      r = materialsForm.materials.price2[matIndex ?? -1] ?? 0;
    }
    if (priceIndex == 3) {
      r = materialsForm.materials.price3[matIndex ?? -1] ?? 0;
    }
    if (priceIndex == 4) {
      r = materialsForm.materials.price4[matIndex ?? -1] ?? 0;
    }
    if (priceIndex == 5) {
      r = materialsForm.materials.price5[matIndex ?? -1] ?? 0;
    }
    if ((materialsForm.materials.isttc[matIndex ?? -1] ?? 0) == 1) {
      r = r / 1.15;
    }
    return r;
  }

  double getPriceMazeed(int? matIndex, int priceIndex, String priceKind) {
    String sp = '[]';
    if (priceIndex == 1) {
      sp = materialsForm.materials.prices1[matIndex ?? -1] ?? '[]';
    }
    if (priceIndex == 2) {
      sp = materialsForm.materials.prices2[matIndex ?? -1] ?? '[]';
    }
    if (priceIndex == 3) {
      sp = materialsForm.materials.prices3[matIndex ?? -1] ?? '[]';
    }
    List jp = jsonDecode(sp);
    var r = jp
            .firstWhere((element) => element['PriceKind'] == priceKind,
                orElse: () => {"Price": 0.0})['Price']
            .toDouble() ??
        0.0;

    if ((materialsForm.materials.isttc[matIndex ?? -1] ?? 0) == 1) {
      r = r / 1.15;
    }
    return r;
  }

  late TCombobox edtUnit = TCombobox(items: [])
    ..onChange = (itemIndex, value) {
      if (isMazeed) {
        priceEdt.value =
            getPriceMazeed(matLookup.selectedIndex, value, priceKind);
      } else {
        priceEdt.value = getPrice(matLookup.selectedIndex, value);
      }
    };
  saveClick() {
    if (matLookup.selectedIndex == null) {
      showSnack('يرجى اختيار المادة');
      return;
    }
    if ((qtyEdt.value ?? 0) <= 0) {
      showSnack('يرجى تحديد الكمية');
      return;
    }
    if ((priceEdt.value ?? 0) <= 0) {
      showSnack('يرجى تحديد السعر');
      return;
    }

    double orgPrice = 0;
    if (isMazeed) {
      orgPrice =
          getPriceMazeed(matLookup.selectedIndex, edtUnit.value, priceKind);
    } else {
      orgPrice = getPrice(matLookup.selectedIndex, edtUnit.value);
    }

    if (canChangePrice > 1 && (priceEdt.value ?? 0) < orgPrice) {
      showSnack('لا يمكن استخدام سعر أقل من السعر المحدد');
      return;
    }

    close([
      matLookup.value ?? '',
      matLookup.selectedIndex == null
          ? ''
          : materialsForm.materials.name[matLookup.selectedIndex!] ?? '',
      qtyEdt.value ?? 0,
      priceEdt.value ?? 0,
      notesEdt.value ?? '',
      edtUnit.value ?? 1,
      edtUnit.items[edtUnit.itemIndex][1] ?? 'الواحدة الافتراضية',
    ]);
  }

  cancelClick() {
    close();
  }

  reloadUnits(int matIndex) {
    List<List> items = [];
    if (matIndex == -1 ||
        (materialsForm.materials.unit1[matIndex] ?? '').isEmpty) {
      items.add([1, 'الواحدة الافتراضية']);
    } else {
      items.add([1, materialsForm.materials.unit1[matIndex]]);
    }
    if ((materialsForm.materials.unit2[matIndex] ?? '').isNotEmpty) {
      items.add([2, materialsForm.materials.unit2[matIndex]]);
    }
    if ((materialsForm.materials.unit3[matIndex] ?? '').isNotEmpty) {
      items.add([3, materialsForm.materials.unit3[matIndex]]);
    }
    if ((materialsForm.materials.unit4[matIndex] ?? '').isNotEmpty) {
      items.add([4, materialsForm.materials.unit4[matIndex]]);
    }
    if ((materialsForm.materials.unit5[matIndex] ?? '').isNotEmpty) {
      items.add([5, materialsForm.materials.unit5[matIndex]]);
    }
    edtUnit.items = items;
    edtUnit.value = 1;
  }

  init(String? matID, double qty, double price, String notes, int unit,
      String priceKind) {
    this.priceKind = priceKind;
    matLookup.value = matID;
    qtyEdt.value = qty;
    priceEdt.value = price;
    notesEdt.value = notes;
    reloadUnits(matLookup.selectedIndex ?? -1);
    edtUnit.value = unit;
  }

  matSelected(val, int? index) {
    double r;
    if (isMazeed) {
      r = getPriceMazeed(index, 1, priceKind);
    } else {
      r = getPrice(index, 1);
    }
    priceEdt.value = r;
    reloadUnits(matLookup.selectedIndex ?? -1);
  }

  @override
  Widget build(BuildContext context) {
    return TTemplatePage(
      activeIndex: 0,
      appBarTitle: '',
      showAppBar: false,
      showBackButton: false,
      showBottomBar: false,
      child: Center(
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      UI(
                        child: matLookup,
                        constraints: const BoxConstraints(maxHeight: 70),
                        padding: const EdgeInsetsDirectional.all(8),
                      ),
                      UI(
                          child: edtUnit,
                          constraints: const BoxConstraints(maxHeight: 70),
                          padding: const EdgeInsetsDirectional.all(8)),
                      UI(
                          child: qtyEdt,
                          constraints: const BoxConstraints(maxHeight: 70),
                          padding: const EdgeInsetsDirectional.all(8)),
                      UI(
                          child: priceEdt,
                          constraints: const BoxConstraints(maxHeight: 70),
                          padding: const EdgeInsetsDirectional.all(8)),
                      UI(
                          child: notesEdt,
                          constraints: const BoxConstraints(maxHeight: 70),
                          padding: const EdgeInsetsDirectional.all(8))
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: saveClick, child: const Text('موافق')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: cancelClick,
                          child: const Text('إلغاء الأمر')),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  matLookupButtonPressed() async {
    addMaterialForm.prepareNew();
    var r = await addMaterialForm.showModal();
    if (r == null) return;
    var i = await materialsForm.materials.add(() {
      materialsForm.materials.barcode1.value = r['barcode1'];
      materialsForm.materials.code.value = r['code'];
      materialsForm.materials.cost.value = r['cost'];
      materialsForm.materials.group.value = r['group'];
      materialsForm.materials.id.value = r['id'];
      materialsForm.materials.isttc.value = r['ttc'];
      materialsForm.materials.name.value = r['name'];
      materialsForm.materials.price1.value = r['price1'];
      materialsForm.materials.price2.value = r['price2'];
      materialsForm.materials.price3.value = r['price3'];
      materialsForm.materials.price4.value = r['price4'];
      materialsForm.materials.price5.value = r['price5'];
      materialsForm.materials.prices1.value = r['prices1'];
      materialsForm.materials.prices2.value = r['prices2'];
      materialsForm.materials.prices3.value = r['prices3'];
      materialsForm.materials.qty.value = r['qty'];
      materialsForm.materials.qtyDetails.value = r['qtys'];
      materialsForm.materials.quality.value = r['quality'];
      materialsForm.materials.unit1.value = r['unit1'];
      materialsForm.materials.unit2.value = r['unit2'];
      materialsForm.materials.unit3.value = r['unit3'];
      materialsForm.materials.unit4.value = r['unit4'];
      materialsForm.materials.unit5.value = r['unit5'];
    });
    matLookup.updateItems();
    matLookup.selectedIndex = i;
    matLookup.refresh();
    matSelected(matLookup.value, matLookup.selectedIndex);
  }
}

TAddItemForm addItemForm = TAddItemForm();
