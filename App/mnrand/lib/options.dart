import 'package:flutter/material.dart';
import 'appsettings.dart';
import 'lib/ui/check_box.dart';
import 'lib/ui/combo.dart';
import 'lib/ui/double_edit.dart';
import 'dart:io';
import 'lib/ui/forms.dart';
import 'lib/ui/ui.dart';
import 'pagetemplate.dart';

class TOptionsForm extends TForm {
  TOptionsForm() {
    load();
  }
  TCheckBox edtShowPriceInPOS = TCheckBox(label: 'عرض السعر في نقطة البيع');
  TDoubleEdit taxRateEdt = TDoubleEdit(label: 'نسبة الضريبة الافتراضية');
  TCombobox cmbAfterBillAdd = TCombobox(
      contentPadding: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
      label: 'بعد إضافة الفاتورة',
      value: null,
      items: Platform.isAndroid
          ? [
              ['', 'لا شيء'],
              ['pre', 'عرض نسخة الطباعة'],
              ['shr', 'مشاركة نسخة مطبوعة'],
              ['pri', 'طباعة'],
            ]
          : (Platform.isWindows
              ? [
                  ['', 'لا شيء'],
                  ['pre', 'معاينة الطباعة'],
                  ['pri', 'طباعة']
                ]
              : []));

  save() async {
    await prefs!.setBool('ShowPriceInPOS', edtShowPriceInPOS.checked);
    await prefs!.setString('AfterBillAdd', cmbAfterBillAdd.value ?? '');
    await prefs!
        .setString('DefaultTaxRate', (taxRateEdt.value ?? 0).toString());
    close();
  }

  load() {
    cmbAfterBillAdd.value = prefs!.getString('AfterBillAdd') ??
        (Platform.isAndroid ? 'shr' : 'pre');
    taxRateEdt.value = double.parse(prefs!.getString('DefaultTaxRate') ?? '15');
    edtShowPriceInPOS.checked = prefs!.getBool('ShowPriceInPOS') ?? true;
  }

  cancel() {
    load();
    close();
  }

  @override
  Widget build(BuildContext context) {
    return TTemplatePage(
      showBottomBar: false,
      activeIndex: 0,
      showAppBar: true,
      appBarTitle: 'الخيارات',
      showBackButton: true,
      backFunc: cancel,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text(
                            'الإعدادات الافتراضية',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.red),
                          ),
                        ),
                      ),
                      UI(
                        child: taxRateEdt,
                        width: 400,
                        maxHeight: 60,
                        paddingAll: 8,
                      ),
                      UI(
                        child: cmbAfterBillAdd,
                        width: 400,
                        maxHeight: 60,
                        paddingAll: 8,
                      ),
                      UI(
                        child: edtShowPriceInPOS,
                        width: 400,
                        maxHeight: 60,
                        paddingAll: 8,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: save, child: const Text('موافق')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: cancel, child: const Text('إلغاء الأمر')),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}

TOptionsForm optionsForm = TOptionsForm();
