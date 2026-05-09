import 'dart:io';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_device_identifier/flutter_device_identifier.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import '../apptype.dart';
import 'package:http/http.dart' as http;

DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
AndroidDeviceInfo? androidInfo;
late String andDeviceID;
late String licCheckError;

late String licCompName;
late String licTaxNum;
late bool licHasPOS;
late bool licNoQR;
late String licTradeRecord;
Uint8List licdata = Uint8List(0);

Future<void> getNetLicense(String deviceId) async {
  String url = isMazeed
      ? 'http://sallasync.arambs.com/mzdlic/u3632222dcscdd654p.php'
      : 'http://sallasync.arambs.com/mnrlic/u3632222dcscdd654p.php'; // Replace with your PHP page URL
  try {
    final Map<String, String> body = {'deviceid': deviceId};
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      licdata = Uint8List(0);
      return;
    }
    final Map<String, dynamic> data = jsonDecode(response.body);
    var ls = data['lic'] ?? '';
    if (ls == '') {
      licdata = Uint8List(0);
      return;
    }
    licdata = Uint8List.fromList(hex.decode(ls));
  } catch (e) {
    licdata = Uint8List(0);
  }
}

late int licStatus;

Future<int> getLic() async {
  if (Platform.isWindows) {
    licCompName = 'الشركة التجريبية';
    licTaxNum = '111222';
    licTradeRecord = '222111';
    andDeviceID = 'WindowsWindows';
    licHasPOS = true;
    licNoQR = false;
    return 0;
  }
  if (!Platform.isAndroid) return 1;

  int r = 0;
  try {
    await getNetLicense(andDeviceID);
    if (andDeviceID == 'error') return 2;
    String id2 =
        sha256.convert(utf8.encode(andDeviceID)).toString().toLowerCase();
    Uint8List id3 = Uint8List.fromList(sha256
        .convert(utf8.encode(isMazeed
            ? ('$id2${andDeviceID}m$id2')
            : (id2 + andDeviceID + andDeviceID)))
        .bytes);
    int i = id3.length ~/ 2;
    Uint8List iv = id3.sublist(i);
    String check = sha256
        .convert(utf8.encode(isMazeed
            ? (andDeviceID + andDeviceID + id2)
            : (id2 + andDeviceID + id2)))
        .toString()
        .toLowerCase();

    AesCrypt c = AesCrypt();
    c.aesSetParams(id3, iv, AesMode.cbc);
    Uint8List pd = c.aesDecrypt(licdata);
    int l = pd.length;
    for (int i = pd.length - 1; i >= 0; i--) {
      if (pd[i] == 0) {
        l = i;
      } else {
        break;
      }
    }
    pd = pd.sublist(0, l);
    String pt = utf8.decode(pd, allowMalformed: false);
    List<String> pts =
        pt.split(String.fromCharCode(13) + String.fromCharCode(10));
    if (pts.length != 7) return 3;
    if (pts[pts.length - 1] != check) return 4;
    licCompName = pts[0];
    licTaxNum = pts[1];
    licTradeRecord = pts[2];
    if (pts[3] != 'noexp') {
      if (DateTime.parse(pts[3]).isBefore(DateTime.now())) {
        return 6;
      }
    }
    licHasPOS = pts[4] == 'pos';
    licNoQR = pts[5] == 'noqr';
  } catch (e) {
    r = 5;
    licCheckError = e.toString();
  }
  return r;
}

androidEnsureStoragePermission() async {
  if (!Platform.isAndroid) {
    return;
  }

  androidInfo ??= await deviceInfo.androidInfo;

  late Permission sp;
  if (androidInfo!.version.sdkInt >= 30) {
    sp = Permission.manageExternalStorage;
  } else {
    sp = Permission.storage;
  }
  int trys = 0;
  while ((!await sp.isGranted) && trys < 10) {
    if (await sp.isPermanentlyDenied) {
      exit(0);
    }
    if (await sp.isDenied) {
      await sp.request();
      trys++;
    }
  }
  if (await sp.isDenied) {
    exit(0);
  }
}

androidGenDeviceID() async {
  if (!Platform.isAndroid) {
    return;
  }

  andDeviceID = (await FlutterDeviceIdentifier.androidID).trim();

  if (andDeviceID.isEmpty ||
      andDeviceID.toLowerCase() == 'unknown' ||
      andDeviceID.toLowerCase() == 'null') {
    andDeviceID = 'error';
    return;
  }

  if (androidInfo!.version.sdkInt <= 29) {
    try {
      andDeviceID += await FlutterDeviceIdentifier.imeiCode;
    } on Exception {
      //
    }

    try {
      andDeviceID += await FlutterDeviceIdentifier.serialCode;
    } on Exception {
      //
    }
  }
  String id2 =
      sha256.convert(utf8.encode(andDeviceID)).toString().toLowerCase();
  andDeviceID = sha256
      .convert(utf8.encode(andDeviceID + id2 + id2))
      .toString()
      .toLowerCase();
}

androidEnsurePhonePermission() async {
  if (!Platform.isAndroid) {
    return;
  }

  androidInfo ??= await deviceInfo.androidInfo;
  if (androidInfo!.version.sdkInt > 29) return;
  Permission sp = Permission.phone;
  int trys = 0;
  while ((!await sp.isGranted) && trys < 10) {
    if (await sp.isPermanentlyDenied) {
      exit(0);
    }
    if (await sp.isDenied) {
      await sp.request();
      trys++;
    }
  }
  if (await sp.isDenied) {
    exit(0);
  }
}
