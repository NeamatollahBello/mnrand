import 'package:flutter/material.dart';
import 'lib/ui/double_edit.dart';
import 'lib/ui/lookup_edit.dart';
import 'materials.dart';
import 'api.dart';
import 'errors.dart';
import 'lib/flutter_utils.dart';
import 'lib/ui/forms.dart';
import 'lib/ui/text_edit.dart';
import 'lib/ui/ui.dart';
import 'pagetemplate.dart';

class TAddMaterialForm extends TForm {
  TAddMaterialForm() : super();
  late bool _isEdit;
  prepareNew() {
    _isEdit = false;
    edtCost.value = 0;
    edtGroup.value = "";
    edtName.value = "";
    edtUnit.value = "";
    edtVatRate.value = 15;
  }

  late TTextEdit edtName = TTextEdit(
    label: 'اسم المادة',
  );
  late TLookupEdit edtGroup = TLookupEdit<String>(
      label: 'المجموعة',
      table: materialsForm.matGroups,
      buttonIcon: Icons.arrow_downward,
      contentPadding: const EdgeInsetsDirectional.only(bottom: 8, start: 6));

  late TTextEdit edtUnit = TTextEdit(
    label: 'الواحدة',
  );
  late TDoubleEdit edtCost = TDoubleEdit(
    label: 'التكلفة',
  );
  late TDoubleEdit edtVatRate = TDoubleEdit(
    label: 'نسبة الضريبة',
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
                      "إضافة مادة",
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
                    child: edtGroup,
                    maxHeight: 70,
                    paddingAll: 8,
                  ),
                  UI(
                    child: edtUnit,
                    maxHeight: 70,
                    paddingAll: 8,
                  ),
                  UI(
                    child: edtCost,
                    maxHeight: 70,
                    paddingAll: 8,
                  ),
                  UI(
                    child: edtVatRate,
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
    if (edtName.value == null) {
      showSnack('يرجى إدخال جميع البيانات المطلوبة.');
      return;
    }

    var res = await api('addmat', {
      'cost': edtCost.value ?? 0.0,
      'group': edtGroup.value ?? "",
      'name': edtName.value ?? "",
      'unit': edtUnit.value ?? "",
      'vatrate': edtVatRate.value ?? 0.0,
    });
    if (showApiError(res)) return;
    close(res['data'][0]);
  }

  void cancel() {
    close(null);
  }
}

TAddMaterialForm addMaterialForm = TAddMaterialForm();
