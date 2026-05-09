import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'reg.dart';
import 'apptype.dart';
import 'lib/andsysutils.dart';
import 'lib/printutils.dart';
import 'package:path_provider/path_provider.dart';
import 'apptheme.dart';
import 'lib/ui/forms.dart';

List<String> priceKinds = [
  '',
  'تكلفة',
  'الجملة',
  'نصف الجملة',
  'تصدير',
  'موزع',
  'مفرق',
  'مستهلك'
];

String compAddress = '';
String defaultPayedAccount = '';
bool canAddBill = false;
bool canAddReturn = false;
bool canAddPrice = false;
bool canAddStock = false;
bool canAddPayIn = false;
bool canAddPayOut = false;
bool canAddDiscIn = false;
bool canAddDiscOut = false;
bool canAddSpent = false;
bool canAddClient = false;
bool canAddMat = false;
bool canKashf = false;
bool canTeacher = false;
bool canShowCost = false;
bool canShowQuality = false;
bool isOnlyPOS = false;
bool isBillTTC = false;
bool isReturnTTC = false;
bool isPriceTTC = false;
bool isStockTTC = false;
bool checkSAAddress = false;
int canChangePrice = 1;
int matUpdateInterval = 30;
String defaultPayedPrice = '';
String priceField = '';

Uint8List compLogo = Uint8List.fromList([]);

DateTime? lastAppBack;

late String rootDir;
//must replace this approch by inheritin TApplication and override constructor
rechecklic() async {
  while (true) {
    await Future.delayed(const Duration(days: 1));
    if (registerForm.visible) continue;
    licStatus = await getLic();
    if (licStatus != 0) {
      await registerForm.showModal();
    }
  }
}

initAppUI() async {
  //get root directory
  if (Platform.isAndroid) {
    rootDir = (await getApplicationDocumentsDirectory()).path;
    if (!rootDir.endsWith('/')) rootDir += '/';
  } else if (Platform.isWindows) {
    rootDir = '${File(Platform.resolvedExecutable).parent.path}\\';
  }

  //get device id
  await androidEnsurePhonePermission();
  await androidGenDeviceID();
  licStatus = await getLic();
  await initPrinting();

  //application

  application.onCanBackExit = () async {
    if (lastAppBack == null) {
      lastAppBack = DateTime.now();
      return false;
    }
    if (DateTime.now().difference(lastAppBack!).inMilliseconds < 1500) {
      return true;
    }
    lastAppBack = DateTime.now();
    return false;
  };

  registerForm.onCanBackClose = () async {
    return false;
  };
  application.title = isMazeed
      ? (isAudit ? 'Audit Unit' : 'المزيد أندرويد')
      : 'المنارة أندرويد';
  application.supportedLocales = const [Locale('en'), Locale('ar')];
  application.locale = const Locale('ar');
  application.theme = appTheme;
}
