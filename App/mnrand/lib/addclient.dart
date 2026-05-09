import 'package:flutter/material.dart';
import 'appui.dart';
import 'lib/ui/combo.dart';
import 'utils.dart';
import 'api.dart';
import 'errors.dart';
import 'lib/flutter_utils.dart';
import 'lib/ui/forms.dart';
import 'lib/ui/text_edit.dart';
import 'lib/ui/ui.dart';
import 'pagetemplate.dart';

class TAddClientForm extends TForm {
  TAddClientForm() : super();
  late bool _isEdit;
  prepareNew() {
    _isEdit = false;
    edtAdd.value = "";
    edtBuild.value = "";
    edtCRN.value = "";
    edtCity.value = "";
    edtMobile.value = "";
    edtPhoneJob.value = "";
    edtKind.value = 0;
    edtName.value = "";
    edtPost.value = "";
    edtStreet.value = "";
    edtSubCity.value = "";
    edtVat.value = "";
  }

  late TTextEdit edtName = TTextEdit(
    label: 'اسم الزبون',
  );
  late TTextEdit edtVat = TTextEdit(
    label: 'الرقم الضريبي',
  );
  late TTextEdit edtCRN = TTextEdit(
    label: 'السجل التجاري',
  );
  late TTextEdit edtPhoneJob = TTextEdit(
    label: 'هاتف العمل',
  );
  late TTextEdit edtMobile = TTextEdit(
    label: 'الموبايل',
  );
  late TCombobox edtKind = TCombobox(label: 'نوع الحساب', items: [
    [0, 'شركة'],
    [1, 'فرد']
  ]);
  late TTextEdit edtCity = TTextEdit(
    label: 'المدينة',
  );
  late TTextEdit edtSubCity = TTextEdit(
    label: 'الحي',
  );
  late TTextEdit edtPost = TTextEdit(
    label: 'الرمز البريدي',
  );
  late TTextEdit edtStreet = TTextEdit(
    label: 'اسم الشارع',
  );
  late TTextEdit edtBuild = TTextEdit(
    label: 'رقم المبنى',
  );
  late TTextEdit edtAdd = TTextEdit(
    label: 'الرقم الإضافي',
  );

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
                      "إضافة زبون",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.red),
                    ),
                  ),
                  UI(
                    child: edtName,
                    maxHeight: 70,
                    paddingAll: 8,
                  ),
                  UI(
                    child: edtVat,
                    maxHeight: 70,
                    paddingAll: 8,
                  ),
                  UI(
                    child: edtCRN,
                    maxHeight: 70,
                    paddingAll: 8,
                  ),
                  UI(
                    child: edtPhoneJob,
                    maxHeight: 70,
                    paddingAll: 8,
                  ),
                  UI(
                    child: edtMobile,
                    maxHeight: 70,
                    paddingAll: 8,
                  ),
                  UI(
                    child: edtKind,
                    maxHeight: 70,
                    paddingAll: 8,
                  ),
                  UI(
                      paddingVert: 8,
                      child: const Text(
                        'العنوان الوطني',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue),
                      )),
                  UI(
                    child: edtCity,
                    maxHeight: 70,
                    paddingAll: 8,
                  ),
                  UI(
                    child: edtSubCity,
                    maxHeight: 70,
                    paddingAll: 8,
                  ),
                  UI(
                    child: edtPost,
                    maxHeight: 70,
                    paddingAll: 8,
                  ),
                  UI(
                    child: edtStreet,
                    maxHeight: 70,
                    paddingAll: 8,
                  ),
                  UI(
                    child: edtBuild,
                    maxHeight: 70,
                    paddingAll: 8,
                  ),
                  UI(
                    child: edtAdd,
                    maxHeight: 70,
                    paddingAll: 8,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isEdit)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: save, child: const Text('موافق')),
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
    var s = (edtName.value ?? '').trim();
    if (s.isEmpty) {
      showSnack('يرجى إدخال اسم الزبون.');
      return;
    }
    if (checkSAAddress) {
      s = (edtMobile.value ?? '').trim();
      if (s != '' && s.length < 10) {
        showSnack('اذا قمت بضبط رقم الموبايل فيجب أن يكون طوله 10 أو أكثر');
        return;
      }
      if (s != '' && !isPhone(s)) {
        showSnack('يجب أن يتضمن رقم الموبايل أرقاما ورمز + فقط');
        return;
      }
      s = (edtPhoneJob.value ?? '').trim();
      if (s != '' && s.length < 10) {
        showSnack('اذا قمت بضبط هاتف العمل فيجب أن يكون طوله 10 أو أكثر');
        return;
      }
      if (s != '' && !isPhone(s)) {
        showSnack('يجب أن يتضمن رقم هاتف العمل أرقاما ورمز + فقط');
        return;
      }
      s = (edtVat.value ?? '').trim();
      if (s != '' && s.length != 15) {
        showSnack('اذا قمت بضبط الرقم الضريبي فيجب أن يكون طوله 15');
        return;
      }
      if (s != '' && !isNumeric(s)) {
        showSnack('يجب أن يتضمن الرقم الضريبي أرقاما فقط');
        return;
      }
      s = (edtCRN.value ?? '').trim();
      if (s != '' && s.length != 10) {
        showSnack('اذا قمت بضبط السجل التجاري فيجب أن يكون طوله 10');
        return;
      }
      if (s != '' && !isNumeric(s)) {
        showSnack('يجب أن يتضمن السجل التجاري أرقاما فقط');
        return;
      }
      s = (edtPost.value ?? '').trim();
      if (s != '' && s.length != 5) {
        showSnack('اذا قمت بضبط الرمز البريدي فيجب أن يكون طوله 5');
        return;
      }
      if (s != '' && !isNumeric(s)) {
        showSnack('يجب أن يتضمن الرمز البريدي أرقاما فقط');
        return;
      }
      s = (edtBuild.value ?? '').trim();
      if (s != '' && s.length != 4) {
        showSnack('اذا قمت بضبط رقم المبنى فيجب أن يكون طوله 4');
        return;
      }
      if (s != '' && !isNumeric(s)) {
        showSnack('يجب أن يتضمن رقم المبنى أرقاما فقط');
        return;
      }
      s = (edtAdd.value ?? '').trim();
      if (s != '' && s.length != 4) {
        showSnack('اذا قمت بضبط الرقم الإضافي فيجب أن يكون طوله 4');
        return;
      }
      if (s != '' && !isNumeric(s)) {
        showSnack('يجب أن يتضمن الرقم الإضافي أرقاما فقط');
        return;
      }
    }
    var res = await api('addclient', {
      'CustName': edtName.value ?? "",
      'vat': edtVat.value ?? "",
      'crn': edtCRN.value ?? "",
      'phonejob': edtPhoneJob.value ?? "",
      'mobile': edtMobile.value ?? "",
      'kind': edtKind.value ?? 0,
      'city': edtCity.value ?? "",
      'subcity': edtSubCity.value ?? "",
      'post': edtPost.value ?? "",
      'street': edtStreet.value ?? "",
      'build': edtBuild.value ?? "",
      'add': edtAdd.value ?? "",
    });
    if (showApiError(res)) return;
    close(res['data'][0]);
  }

  void cancel() {
    close(null);
  }
}

TAddClientForm addClientForm = TAddClientForm();
