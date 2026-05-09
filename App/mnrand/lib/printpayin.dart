import 'dart:io';
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';
import 'appui.dart';
import 'lib/andsysutils.dart';
import 'lib/flutter_utils.dart';
import 'preview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:tafqit/tafqit.dart';

_initPayInPrint<T extends PayInPrint>(T payinPrint, payin) {
  // load payin data
  payinPrint.seller = licCompName;
  payinPrint.taxNum = licTaxNum;
  payinPrint.tradeRecord = licTradeRecord;
  payinPrint.compAddress = compAddress;
  if (payinPrint.seller.isEmpty || payinPrint.taxNum.isEmpty) {
    showSnack('يرجى ضبط اسم المنشأة والرقم الضريبي');
    return null;
  }
  payinPrint.clientName = payin['accname'] ?? '';
  payinPrint.payinTime = DateTime.parse(payin['time']);
  payinPrint.notes = payin['notes'] ?? '';
  payinPrint.paid = payin['amount'] ?? 0;
  payinPrint.payinNum = payin['num'] ?? 0;
  payinPrint.balance = payin['new_balance'] ?? '';
  payinPrint.payType = (payin['acc2'] ?? 0) == 0 ? 'نقدي' : 'شبكة';
  int m, n;
  m = payinPrint.paid.truncate();
  n = (payinPrint.paid * 100).round() % 100;
  payinPrint.only = Tafqit().tafqitNumberWithParts(
          listOfNumberAndParts: [m, n],
          tafqitUnitCode: TafqitUnitCode.saudiRiyal) ??
      '';
  payinPrint.docName =
      'سند قبض رقم ${payinPrint.payinNum} من ${payinPrint.clientName}';
}

printPayIn<T extends PayInPrint>(T payinPrint, payinData, bool directPrint,
    Future Function() onReturn) async {
  _initPayInPrint<T>(payinPrint, payinData);
  Uint8List pdf = await payinPrint.getReport();

  if (Platform.isWindows) {
    if (directPrint) {
      //in windows layout print directly
      Printing.layoutPdf(
        onLayout: (format) async {
          return pdf;
        },
        format: payinPrint.getPageFormat(),
        name: payinPrint.docName,
      );
    } else {
      previewForm.preview(pdf, payinPrint.docName);
    }
  }
  if (Platform.isAndroid) {
    if (directPrint) {
      //direct print not supported in android, layoutPdf function will display preview
      Printing.layoutPdf(
        onLayout: (format) async {
          return pdf;
        },
        format: payinPrint.getPageFormat(),
        name: payinPrint.docName,
      );
    } else {
      Printing.layoutPdf(
        onLayout: (format) async {
          return pdf;
        },
        format: payinPrint.getPageFormat(),
        name: payinPrint.docName,
      );
    }
  }
}

sharePayIn<T extends PayInPrint>(T payinPrint, payinData) async {
  _initPayInPrint<T>(payinPrint, payinData);
  Uint8List pdf = await payinPrint.getReport();
  String p = (await getApplicationCacheDirectory()).path;
  if (p.endsWith('/')) {
    p += '${payinPrint.docName}.pdf';
  } else {
    p += '/${payinPrint.docName}.pdf';
  }
  File(p).writeAsBytesSync(pdf);
  await SharePlus.instance.share(ShareParams(files: [XFile(p)]));
}

abstract class PayInPrint {
  Tafqit tfq = Tafqit();
  late String seller;
  late String taxNum;
  late String tradeRecord;
  late String payType;
  late int payinNum;
  late DateTime payinTime;
  late double paid;
  late String clientName;
  late String notes;
  late String compAddress;
  late String balance;

  late double cm;
  late String only;
  late String docName;
  Future<Uint8List> getReport();
  PdfPageFormat getPageFormat();
}
