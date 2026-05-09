import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'printbill.dart';
import 'clients.dart';
import 'addbill.dart';
import 'api.dart';
import 'appui.dart';
import 'dayly.dart';
import 'errors.dart';
import 'lib/db/db.dart';
import 'lib/flutter_utils.dart';
import 'lib/ui/check_box.dart';
import 'materials.dart';
import 'pos.dart';
import 'dart:async';
import 'appsettings.dart';
import 'package:flutter/material.dart';
import 'lib/ui/forms.dart';
import 'lib/ui/text_edit.dart';
import 'lib/ui/ui.dart';
import 'apptype.dart';

class TLoginForm extends TForm {
  Future<String> tryLoad() async {
    if (apiToken.isEmpty) return 'token';
    isLoading = true;

    loadingText = 'جاري تحميل الإعدادات';
    notify();
    await Future.delayed(const Duration(milliseconds: 500));
    var res = await api('settings', {});
    if ((res['e'] ?? 'ok') != 'ok') {
      isLoading = false;
      notify();
      return res['e'];
    }
    compAddress = res['data']['CompAddress'] ?? "";
    defaultPayedAccount = res['data']['DefaultPayedAccount'] ?? '';
    canAddBill = res['data']['pBill'] ?? false;
    canAddReturn = res['data']['pReturn'] ?? false;
    canAddPrice = res['data']['pPrice'] ?? false;
    canAddStock = res['data']['pStock'] ?? false;
    canAddPayIn = res['data']['pPayIn'] ?? false;
    canAddPayOut = res['data']['pPayOut'] ?? false;
    canAddDiscIn = res['data']['pDiscIn'] ?? false;
    canAddDiscOut = res['data']['pDiscOut'] ?? false;
    canAddSpent = res['data']['pSpent'] ?? false;
    canAddClient = res['data']['pAddCust'] ?? false;
    canAddMat = res['data']['pAddMat'] ?? false;
    canKashf = res['data']['pCustReport'] ?? false;
    canTeacher = res['data']['pGLedger'] ?? false;
    canShowCost = res['data']['pShowCost'] ?? false;
    canShowQuality = res['data']['pShowQuality'] ?? false;
    isOnlyPOS = res['data']['pOnlyPOS'] ?? false;
    isBillTTC = res['data']['bttc'] ?? false;
    isReturnTTC = res['data']['rttc'] ?? false;
    isPriceTTC = res['data']['pttc'] ?? false;
    isStockTTC = res['data']['sttc'] ?? false;
    checkSAAddress = res['data']['CheckSAAddress'] ?? false;
    canChangePrice = res['data']['pEditPrice'] ?? 1;
    matUpdateInterval = res['data']['MatUpdateInterval'] ?? 30;
    defaultPayedPrice = priceKinds[res['data']['DefaultPayedPrice'] ?? 0];
    priceField = res['data']['PriceField'] ?? 'حسب الزبون';
    if (priceField.trim().isEmpty) priceField = 'حسب الزبون';
    compLogo = (await Dio().post<Uint8List>('${apiUrl}logo',
                options: Options(
                    responseType: ResponseType.bytes,
                    headers: {'authorization': 'Bearer $apiToken'})))
            .data ??
        Uint8List.fromList([]);

    var reps = await api('reports', {});
    if ((reps['e'] ?? 'ok') != 'ok') {
      isLoading = false;
      notify();
      return reps['e'];
    }
    billDesigns = reps['data'];
    loadingText = 'جاري تحميل قائمة المواد';
    notify();
    await Future.delayed(const Duration(milliseconds: 500));

    var sw = api('matlist', {});
    res = await sw;
    if ((res['e'] ?? 'ok') != 'ok') {
      isLoading = false;
      notify();
      return res['e'];
    }
    await materialsForm.materials.load(res['data']);
    if (isMazeed) {
      for (int i = 0; i < materialsForm.materials.recordCount; i++) {
        List j = jsonDecode(materialsForm.materials.prices1[i] ?? '[]');
        var p = (j.firstWhere(
                  (e) => e['PriceKind'] == defaultPayedPrice,
                  orElse: () => {"Price": 0.0},
                )['Price'] ??
                0.0)
            .toDouble();
        materialsForm.materials.price1[i] = p;
      }
    }
    materialsForm.groupMaterials();
    await materialsForm.matGroups.load(res['groups']);
    await addBillForm.barcodes.load(res['barcodes']);

    loadingText = 'جاري تحميل قائمة الزبائن';
    notify();
    await Future.delayed(const Duration(milliseconds: 500));
    res = await api('clientlist', {});
    if ((res['e'] ?? 'ok') != 'ok') {
      isLoading = false;
      notify();
      return res['e'];
    }
    await accountsForm.clients.load(res['data']);

    loadingText = 'جاري تحميل قائمة الحسابات';
    notify();
    await Future.delayed(const Duration(milliseconds: 500));
    res = await api('acclist', {});
    if ((res['e'] ?? 'ok') != 'ok') {
      isLoading = false;
      notify();
      return res['e'];
    }
    await accountsForm.accounts.load(res['data']);

    loadingText = 'جاري تحميل العمليات';
    notify();
    DateTime? d1 = DateTime.now();
    await Future.delayed(const Duration(milliseconds: 500));
    res = await api('oplog', {
      'd1': defaultJsonDateTimeFormat.format(d1),
      'd2': defaultJsonDateTimeFormat.format(d1.add(const Duration(days: 1)))
    });
    if ((res['e'] ?? 'ok') != 'ok') {
      isLoading = false;
      notify();
      return res['e'];
    }
    await daylyForm.dayly.load(res['data']);
    daylyForm.listView.refreshItems();
    daylyForm.dfType.value = 0;
    daylyForm.searchEdt.value = '';

    if (!isMazeed) {
      loadingText = 'جاري تحميل أنواع الدفع';
      notify();
      await Future.delayed(const Duration(milliseconds: 500));
      res = await api('paytypelist', {});
      if ((res['e'] ?? 'ok') != 'ok') {
        isLoading = false;
        notify();
        return res['e'];
      }
    }
    addBillForm.updatePayTypes(res['data']);

    if (isOnlyPOS) {
      posForm.prepareNew();
      posForm.showOnly();
    } else {
      daylyForm.showOnly();
    }

    if (!hasLoaded) {
      //run material update thread after first time loading
      //it will run forever
      updateMaterialThread();
      hasLoaded = true;
    }
    return '';
  }

  bool isLoading = false;
  bool hasLoaded = false;
  String loadingText = '';
  TTextEdit edtServer = TTextEdit(label: 'السرفر', text: lastServer);
  TTextEdit edtComp = TTextEdit(label: 'كود قاعدة البيانات', text: lastComp);
  TTextEdit edtUser = TTextEdit(label: 'اسم المستخدم', text: lastUser);
  TTextEdit edtPass = TTextEdit(label: 'كلمة المرور', text: lastPass);
  TCheckBox chkRemember = TCheckBox(label: 'تذكرني');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UI(
        maxWidth: 400,
        alignment: AlignmentDirectional.center,
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    loadingText,
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  //cance button not workig yet, there is a problem in canceling async function
                  // TextButton(
                  //     onPressed: () {
                  //       waiting?.cancel();
                  //     },
                  //     child: const Text('إلغاء الأمر'))
                ],
              )
            : ListView(
                shrinkWrap: true,
                children: [
                  UI(paddingAll: 8, child: edtServer),
                  if (isMazeed) UI(paddingAll: 8, child: edtComp),
                  UI(paddingAll: 8, child: edtUser),
                  UI(paddingAll: 8, child: edtPass),
                  UI(paddingAll: 8, child: chkRemember),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () async {
                            apiUrl =
                                'http://${edtServer.value}:${isMazeed ? 8031 : 8030}/';
                            var res = await api('login', {
                              'dbcode': edtComp.value,
                              'user': edtUser.value,
                              'pass': edtPass.value
                            });
                            if (showApiError(res)) return;

                            await setApiToken(
                                res['token'], chkRemember.checked);
                            await setLastUserPass(
                                edtComp.value ?? '',
                                edtUser.value ?? '',
                                edtPass.value ?? '',
                                chkRemember.checked);
                            await setLastServer(edtServer.value ?? '', true);
                            var s = await tryLoad();

                            if (s.isNotEmpty) {
                              showSnack(msg[s] ?? 'حدث الخطأ التالي: $s');
                            }
                          },
                          child: const Text('دخول')),
                    ],
                  )
                ],
              ),
      ),
    );
  }

  void updateMaterialThread() async {
    while (true) {
      await Future.delayed(Duration(minutes: matUpdateInterval));
      try {
        var res = await api('matlist', {});
        if ((res['e'] ?? 'ok') != 'ok') {
          return;
        }
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
        showSnack("تم إجراء تحديث تلقائي لقائمة المواد.");
      } catch (e) {}
    }
  }
}

TLoginForm loginForm = TLoginForm();
