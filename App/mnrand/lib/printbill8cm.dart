import 'dart:async';
import 'package:flutter/services.dart';
import 'lib/andsysutils.dart';
import 'lib/printutils.dart';
import 'printbill.dart';
import 'utils.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';

class BillPrint8Cm extends BillPrint {
  Widget getHeader(Context context) {
    String title = billType > 2
        ? ''
        : clientTaxNum.trim().isEmpty
            ? 'فاتورة ضريبية مبسطة - '
            : 'فاتورة ضريبية - ';
    if (billType == 1) title += 'مبيعات';
    if (billType == 2) title += 'مرتجع مبيعات';
    if (billType == 3) title += 'عرض سعر';
    if (billType == 4) title += 'محضر جرد';

    if (context.pageNumber == 1) {
      return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(height: 0.3 * cm),
        st15b.ar(seller, alignment: Alignment.center),
        st13.ar('الرقم الضريبي $taxNum', alignment: Alignment.center),
        st13.ar('ضريبة القيمة المضافة $vatRate%', alignment: Alignment.center),
        st13b.ar(title, alignment: Alignment.center),
        Row(children: [
          Expanded(
              flex: 20,
              child: st11.ar(isSubPaid ? 'آجل' : payType,
                  alignment: Alignment.center)),
          Expanded(
              flex: 20, child: st11.ar('الدفع', alignment: Alignment.center)),
          Expanded(
              flex: 40,
              child: st11.ar(billNum.toString(), alignment: Alignment.center)),
          Expanded(flex: 20, child: st11.ar('الرقم')),
        ]),
        Row(children: [
          Expanded(
              flex: 40,
              child: st11.ar(timeFormat.format(billTime),
                  alignment: Alignment.center)),
          Expanded(
              flex: 40,
              child: st11.ar(dateFormat.format(billTime),
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
          Expanded(
              flex: 33,
              child: st13.ar(((total * 100).round() / 100).toString())),
          Expanded(flex: 67, child: st13.ar('الإجمالي')),
        ]),
        Row(children: [
          Expanded(
              flex: 33,
              child: st13.ar(((discount * 100).round() / 100).toString())),
          Expanded(flex: 67, child: st13.ar('الخصومات')),
        ]),
        Row(children: [
          Expanded(
              flex: 33,
              child: st13.ar(
                  (((total - discount - (ttc ? tax : 0)) * 100).round() / 100)
                      .toString())),
          Expanded(flex: 67, child: st13.ar('إجمالي الخاضع للضريبة')),
        ]),
        Row(children: [
          Expanded(
              flex: 33, child: st13.ar(((tax * 100).round() / 100).toString())),
          Expanded(flex: 67, child: st13.ar('إجمالي الضريبة')),
        ]),
        Row(children: [
          Expanded(
              flex: 33,
              child: st13.ar(((wanted * 100).round() / 100).toString())),
          Expanded(flex: 67, child: st13.ar('إجمالي المبلغ المستحق:')),
        ]),
        if (isSubPaid)
          Row(children: [
            Expanded(
                flex: 33,
                child: st13.ar(((paid * 100).round() / 100).toString())),
            Expanded(flex: 67, child: st13.ar('المبلغ المدفوع')),
          ]),
        if (isSubPaid)
          Row(children: [
            Expanded(
                flex: 33,
                child: st13.ar(((remain * 100).round() / 100).toString())),
            Expanded(flex: 67, child: st13.ar('المبلغ المتبقي')),
          ]),
        Container(width: 0.2 * cm),
        Center(
            child: billType < 2 && (!licNoQR)
                ? BarcodeWidget(
                    barcode: Barcode.qrCode(),
                    data: qrs,
                    width: 5 * cm,
                    height: 5 * cm)
                : Container(width: 5 * cm, height: 5 * cm)),
        Container(width: 0.2 * cm),
      ])),
    ]);
  }

  Table getItemsTable(Context context) {
    String totalColTitle =
        ttc ? 'المجموع (شامل الضريبة)' : 'المجموع (غير شامل الضريبة)';
    TableRow header = TableRow(repeat: true, children: [
      st7b.ar(totalColTitle,
          alignment: Alignment.center, textAlign: TextAlign.center),
      st10b.ar('السعر',
          alignment: Alignment.center, textAlign: TextAlign.center),
      st10b.ar('الكمية',
          alignment: Alignment.center, textAlign: TextAlign.center),
      st10b.ar('الصنف',
          alignment: Alignment.center, textAlign: TextAlign.center),
      st10b.ar('م', alignment: Alignment.center, textAlign: TextAlign.center),
    ]);

    List<TableRow> rows = List.generate(items.length + 1, (index) {
      if (index == 0) return header;
      //items array:
      //Name, Amount, Items.Price, Items.TaxRate
      List item = items[index - 1];
      return TableRow(children: [
        st11b
            .ar(((item[1] * item[2] * 100 as double).round() / 100).toString()),
        st11b.ar(((item[2] * 100 as double).round() / 100).toString()),
        st11b.ar(((item[1] * 100 as double).round() / 100).toString()),
        st11b.ar(item[0]),
        st11b.ar(index.toString()),
      ]);
    });
    return Table(
        border: TableBorder.all(width: 0.05 * cm),
        columnWidths: {
          0: FixedColumnWidth(1.75 * cm),
          1: FixedColumnWidth(1.5 * cm),
          2: FixedColumnWidth(1.25 * cm),
          3: FixedColumnWidth(2.75 * cm),
          4: FixedColumnWidth(0.75 * cm),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.full,
        tableWidth: TableWidth.min,
        children: rows);
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
  Future<Uint8List> getLocalReport() async {
    final doc = Document(theme: ThemeData.withFont(base: billfont));
    PdfPageFormat pf = getPageFormat();

    doc.addPage(Page(
      build: (context) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getHeader(context),
              getItemsTable(context),
              getSummery(context)
            ]);
      },
      pageFormat: pf,
    ));
    return await doc.save();
  }
}
