import 'dart:async';
import 'package:flutter/services.dart';
import 'lib/printutils.dart';
import 'printpayin.dart';
import 'utils.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';

class PayInPrint8Cm extends PayInPrint {
  Widget getHeader(Context context) {
    String title = 'سند قبض';

    if (context.pageNumber == 1) {
      return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(height: 0.3 * cm),
        st15b.ar(seller, alignment: Alignment.center),
        st13.ar('الرقم الضريبي $taxNum', alignment: Alignment.center),
        st13b.ar(title, alignment: Alignment.center),
        Row(children: [
          Expanded(
              flex: 20, child: st11.ar(payType, alignment: Alignment.center)),
          Expanded(
              flex: 20, child: st11.ar('الدفع', alignment: Alignment.center)),
          Expanded(
              flex: 40,
              child: st11.ar(payinNum.toString(), alignment: Alignment.center)),
          Expanded(flex: 20, child: st11.ar('الرقم')),
        ]),
        Row(children: [
          Expanded(
              flex: 40,
              child: st11.ar(timeFormat.format(payinTime),
                  alignment: Alignment.center)),
          Expanded(
              flex: 40,
              child: st11.ar(dateFormat.format(payinTime),
                  alignment: Alignment.center)),
          Expanded(flex: 20, child: st11.ar('تاريخ')),
        ]),
        Row(children: [
          Expanded(
              flex: 40,
              child: st11.ar(clientName, alignment: Alignment.center)),
          Expanded(flex: 20, child: st11.ar('العميل')),
        ]),
        Container(height: 0.3 * cm),
      ]);
    } else {
      return Container(height: 0.3 * cm);
    }
  }

  Widget getSummery(Context context) {
    return Row(children: [
      Container(width: 0.2 * cm),
      Expanded(
          child: Column(children: [
        Divider(height: 0.7 * cm, thickness: 0.05 * cm),
        Row(children: [
          st13.ar(((paid * 100).round() / 100).toString()),
          Expanded(child: st13.ar('المبلغ المدفوع')),
        ]),
        Row(children: [
          Expanded(child: st13.ar(only)),
        ]),
        Row(children: [
          st13.ar(balance),
          Expanded(child: Container()),
          st13.ar('الرصيد')
        ]),
        Container(width: 0.2 * cm),
      ])),
    ]);
  }

  @override
  PdfPageFormat getPageFormat() {
    var v = PdfPageFormat.roll80.copyWith(
        marginBottom: 0.25 * cm,
        marginLeft: 0.1 * cm,
        marginRight: 0.25 * cm,
        marginTop: 0.1 * cm);
    return v;
  }

  @override
  Future<Uint8List> getReport() async {
    final doc = Document(theme: ThemeData.withFont(base: billfont));
    cm = PdfPageFormat.roll80.width / 8;
    PdfPageFormat pf = getPageFormat();

    doc.addPage(Page(
      build: (context) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [getHeader(context), getSummery(context)]);
      },
      pageFormat: pf,
    ));
    return await doc.save();
  }
}
