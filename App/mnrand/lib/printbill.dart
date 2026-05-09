import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'lib/ui/forms.dart';
import '/printbill8cm.dart';
import 'package:share_plus/share_plus.dart';

import 'addbill.dart';
import 'apptype.dart';
import 'appui.dart';
import 'lib/andsysutils.dart';
import 'lib/flutter_utils.dart';
import 'preview.dart';
import 'utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:tafqit/tafqit.dart';

late List billDesigns;

_initBillPrint<T extends BillPrint>(T billPrint, bill) {
  // load bill data
  billPrint.isSmall = T == BillPrint8Cm;
  billPrint.seller = licCompName;
  billPrint.taxNum = licTaxNum;
  billPrint.tradeRecord = licTradeRecord;
  billPrint.compAddress = compAddress;
  if (billPrint.seller.isEmpty || billPrint.taxNum.isEmpty) {
    showSnack('يرجى ضبط اسم المنشأة والرقم الضريبي');
    return null;
  }
  billPrint.vatRate = bill['vatrate'];
  billPrint.actacc = bill['actacc'] ?? 1;
  billPrint.clientName = bill['accname'] ?? '';
  billPrint.ttc = bill['ttc'] ?? false;
  billPrint.clientTaxNum = bill['acctaxnum'] ?? '';
  billPrint.billTime = DateTime.parse(bill['time']);
  billPrint.discount = bill['disc'] ?? 0;
  billPrint.notes = bill['notes'] ?? '';
  billPrint.clientAddress = bill['accaddress'] ?? '';
  billPrint.paid = bill['payed'] ?? 0;
  billPrint.billType = bill['btype'];
  billPrint.billNum = bill['num'];
  billPrint.logID = bill['logid'] ?? '';
  billPrint.balance = bill['new_balance'] ?? '';

  billPrint.items = (bill['items'] as List)
      .map((e) => [
            e['name'],
            e['amount'],
            e['price'],
            (e['unit_name'] ?? '').replaceAll('الواحدة الافتراضية', '')
          ])
      .toList();

  billPrint.calcTotal();
  if (billPrint.remain > 0.02) {
    billPrint.payType = 'آجل';
  } else {
    int i = addBillForm.payTypes.indexWhere((element) =>
        element[0] == (isMazeed ? bill['actacc'] : bill['payacc']));
    if (i == -1) {
      billPrint.payType = '';
    } else {
      billPrint.payType = addBillForm.payTypes[i][1];
    }
  }
  if (billPrint.payType == '') billPrint.payType = 'آجل';
}

printBill<T extends BillPrint>(
    T billPrint, billData, bool directPrint, Future Function() onReturn) async {
  _initBillPrint<T>(billPrint, billData);

  Uint8List? pdf = await billPrint.getReport();
  if (pdf == null) return;
  if (Platform.isWindows) {
    if (directPrint) {
      //in windows layout print directly
      Printing.layoutPdf(
        onLayout: (format) async {
          return pdf;
        },
        format: billPrint.getPageFormat(),
        name: billPrint.docName,
      );
    } else {
      previewForm.preview(pdf, billPrint.docName);
    }
  }
  if (Platform.isAndroid) {
    if (directPrint) {
      //direct print not supported in android, layoutPdf function will display preview
      Printing.layoutPdf(
        onLayout: (format) async {
          return pdf;
        },
        format: billPrint.getPageFormat(),
        name: billPrint.docName,
      );
    } else {
      Printing.layoutPdf(
        onLayout: (format) async {
          return pdf;
        },
        format: billPrint.getPageFormat(),
        name: billPrint.docName,
      );
    }
  }
}

shareBill<T extends BillPrint>(T billPrint, billData) async {
  _initBillPrint<T>(billPrint, billData);
  Uint8List? pdf = await billPrint.getReport();
  if (pdf == null) return;
  String p = (await getApplicationCacheDirectory()).path;
  if (p.endsWith('/')) {
    p += '${billPrint.docName}.pdf';
  } else {
    p += '/${billPrint.docName}.pdf';
  }
  File(p).writeAsBytesSync(pdf);
  await SharePlus.instance.share(ShareParams(files: [XFile(p)]));
}

abstract class BillPrint {
  Tafqit tfq = Tafqit();
  late bool ttc;
  late String seller;
  late String taxNum;
  late String tradeRecord;
  late int billType;
  late int actacc = 1;
  late int billNum;
  late String logID;
  late DateTime billTime;
  late List<List> items;
  late double vatRate;
  late double discount;
  late double paid;
  late double wanted;
  late double remain;
  late bool isSubPaid;
  late String payType;
  late String clientName;
  late String clientTaxNum;
  late String clientAddress;
  late String notes;
  late String compAddress;
  late String balance;

  late double total;
  late double tax;
  late double amount;
  double cm = PdfPageFormat.cm;
  late String qrs;
  late String only;
  late String docName;
  late bool isSmall;
  Future<Uint8List> getLocalReport();
  Future<Uint8List?> getReport() async {
    var rp = await remotePrint();
    if (rp != null) if (rp.isNotEmpty) return rp;
    if (rp == null) return await getLocalReport();
    return null;
  }

  PdfPageFormat getPageFormat();

  Future<Uint8List?> remotePrint() async {
    if (logID.isEmpty) return null;
    var freps = billDesigns
        .where((e) => e['BillType'] == billType && e['IsSmall'] == isSmall)
        .toList();
    if (freps.isEmpty) return null;
    String? repid;
    if (freps.length == 1) {
      repid = freps[0]['ID'];
    } else {
      repid = await showModalBottomSheet(
        context: application.navigatorKey.currentContext!,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: freps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(freps[index]['Name']),
                  onTap: () {
                    Navigator.pop(context, freps[index]['ID']);
                  },
                );
              },
            ),
          );
        },
      );
    }
    if (repid == null) return Uint8List.fromList([]);
    var dt = (await Dio().post<Uint8List>('${apiUrl}print',
            data: {"report": repid, "logid": logID},
            options: Options(
                responseType: ResponseType.bytes,
                headers: {'authorization': 'Bearer $apiToken'})))
        .data;
    return dt;
  }

  calcTotal() {
    //items array:
    //Name, Amount, Items.Price, Items.TaxRate
    tax = 0;
    total = 0;
    amount = 0;
    for (int i = 0; i < items.length; i++) {
      total += items[i][1] * items[i][2];
      amount += items[i][1];
    }
    if (!ttc) {
      tax = ((total - discount) * vatRate).roundToDouble() / 100.0;
      wanted = total + tax - discount;
    } else {
      tax = (100 * (total - discount) * vatRate / (100 + vatRate))
              .roundToDouble() /
          100.0;
      wanted = total - discount;
    }
    if (isMazeed) {
      if (actacc != 1) paid = wanted;
    }
    remain = wanted - paid;
    if (remain <= 0.02) remain = 0;

    isSubPaid = (paid * 100).round() != 0 && (remain * 100).round() != 0;
    int m, n;
    if (isSubPaid) {
      m = remain.truncate();
      n = (remain * 100).round() % 100;
    } else {
      m = wanted.truncate();
      n = (wanted * 100).round() % 100;
    }
    only = Tafqit().tafqitNumberWithParts(
            listOfNumberAndParts: [m, n],
            tafqitUnitCode: TafqitUnitCode.saudiRiyal) ??
        '';
    docName = 'فاتورة ';
    if (billType == 1) docName += 'مبيعات - ';
    if (billType == 2) docName += 'مرتجع مبيعات - ';
    if (billType == 3) docName = 'عرض سعر - ';
    if (billType == 4) docName = 'محضر جرد - ';
    docName +=
        '${clientName.replaceAll('/', '_')} - رقم $billNum - تاريخ ${dashDateFormat.format(billTime)}';
    qrs = _getBillQR();
  }

  String _getBillQR() {
    if (billType != 1) return '';
    String tm = billTime.toUtc().toIso8601String();
    List<int> bytecode = List.empty(growable: true);
    List<int> bs = utf8.encode(seller);
    if (bs.length > 255) bs.length = 255;
    bytecode.add(1);
    bytecode.add(bs.length);
    bytecode.addAll(bs);
    bs = utf8.encode(taxNum);
    if (bs.length > 255) bs.length = 255;
    bytecode.add(2);
    bytecode.add(bs.length);
    bytecode.addAll(bs);
    bs = utf8.encode(tm);
    bytecode.add(3);
    bytecode.add(bs.length);
    bytecode.addAll(bs);
    bs = utf8
        .encode((((total + tax - discount) * 100).round() / 100).toString());
    if (bs.length > 255) bs.length = 255;
    bytecode.add(4);
    bytecode.add(bs.length);
    bytecode.addAll(bs);
    bs = utf8.encode(((tax * 100).round() / 100).toString());
    if (bs.length > 255) bs.length = 255;
    bytecode.add(5);
    bytecode.add(bs.length);
    bytecode.addAll(bs);
    return base64Encode(bytecode);
  }
}
