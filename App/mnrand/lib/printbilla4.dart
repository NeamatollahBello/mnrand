import 'dart:async';
import 'package:flutter/services.dart';
import 'lib/andsysutils.dart';
import 'appui.dart';
import 'lib/printutils.dart';
import 'printbill.dart';
import 'utils.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';

class BillPrintA4 extends BillPrint {
  Widget multiLangHeaderLine(String ar, en, val) {
    return Row(children: [
      st12.en(en),
      Expanded(child: st12.ar(val, alignment: Alignment.center)),
      st12.ar(ar),
    ]);
  }

  Widget multiLangSummeryLine(String ar, en, val) {
    return Row(children: [
      st11.en(en, width: 5 * cm),
      st11.en(val),
      Expanded(child: st11.ar(ar, alignment: Alignment.centerRight)),
    ]);
  }

  Widget multiLangSummeryBoldLine(String ar, en, val) {
    return Row(children: [
      st12b.en(en, width: 5 * cm),
      st12b.en(val),
      Expanded(child: st12b.ar(ar, alignment: Alignment.centerRight)),
    ]);
  }

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
        Row(children: [
          Container(width: 1 * cm),
          if (compLogo.isNotEmpty)
            Image(MemoryImage(compLogo), width: 3 * cm, height: 3 * cm),
          Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            st15b.ar(seller),
            st15b.ar('الرقم الضريبي $taxNum'),
            st15b.ar('السجل التجاري $tradeRecord')
          ]),
          Container(width: 1 * cm)
        ]),
        Container(height: 0.5 * cm),
        st15b.ar(title, alignment: Alignment.center),
        Divider(
            height: 0.3 * cm, thickness: 0.05 * cm, indent: cm, endIndent: cm),
        Container(height: 0.3 * cm),
        Row(children: [
          Container(width: cm),
          billType < 2 && (!licNoQR)
              ? BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: qrs,
                  width: 2.5 * cm,
                  height: 2.5 * cm)
              : Container(width: 2.5 * cm, height: 2.5 * cm),
          Container(width: 0.3 * cm),
          Expanded(
              child: Column(children: [
            Row(children: [
              Expanded(
                  flex: 3,
                  child: multiLangHeaderLine('طريقة الدفع: ', 'Pay Type: ',
                      isSubPaid ? 'آجل' : payType)),
              Expanded(
                  flex: 5,
                  child: multiLangHeaderLine(
                      billType <= 2
                          ? 'رقم الفاتورة: '
                          : (billType == 3
                              ? 'رقم عرض السعر: '
                              : 'رقم محضر الجرد: '),
                      billType <= 2
                          ? 'Invoice Number: '
                          : (billType == 3
                              ? 'Offer price number: '
                              : 'Inventory report number'),
                      billNum.toString())),
            ]),
            Row(children: [
              Expanded(
                  flex: 3, child: multiLangHeaderLine('البائع ', 'Sale: ', '')),
              Expanded(
                  flex: 5,
                  child: multiLangHeaderLine(
                      billType <= 2
                          ? 'تاريخ الفاتورة: '
                          : (billType == 3
                              ? 'تاريخ عرض السعر: '
                              : 'تاريخ الجرد: '),
                      billType <= 2
                          ? 'Invoice date: '
                          : (billType == 3
                              ? 'Offer price date: '
                              : 'Inventory report date: '),
                      dateFormat.format(billTime))),
            ]),
            multiLangHeaderLine('العميل: ', 'Customer: ', clientName),
            if (clientTaxNum.trim().isNotEmpty)
              multiLangHeaderLine('الرقم الضريبي: ', 'VAT No.: ', clientTaxNum),
            multiLangHeaderLine('العنوان: ', 'Address: ', clientAddress),
          ])),
          Container(width: cm)
        ]),
        Container(height: 0.3 * cm),
      ]);
    } else {
      return Container(height: 0.3 * cm);
    }
  }

  Widget getFooter(Context context) {
    DateTime d = DateTime.now();
    return Column(children: [
      Container(height: 0.3 * cm),
      st12.ar(compAddress,
          alignment: Alignment.center, textAlign: TextAlign.center),
      Row(children: [
        Container(width: cm),
        Expanded(
          child: st11.en(
              'Printed on: ${dateFormat.format(d)}    Time: ${timeFormat.format(d)}',
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.left),
        ),
        st11.en('Page ${context.pageNumber} of ${context.pagesCount}'),
        Container(width: 2 * cm),
      ]),
      Container(height: 0.3 * cm),
    ]);
  }

  Widget getSummery(Context context) {
    return Row(children: [
      Container(width: cm),
      Expanded(
          child: Column(children: [
        Divider(height: 0.3 * cm, thickness: 0.05 * cm),
        multiLangSummeryLine('إجمالي الكمية:', 'Total Qty.:',
            ((amount * 100).round() / 100).toString()),
        multiLangSummeryLine('مجموع الفاتورة:', 'Sub Total:',
            'SAR ${((total * 100).round() / 100).toString()}'),
        if ((discount * 100).round() != 0)
          multiLangSummeryLine('الخصومات:', 'Total discount:',
              'SAR ${((discount * 100).round() / 100).toString()}'),
        multiLangSummeryLine('ضريبة القيمة المضافة: ', 'Total VAT:',
            'SAR ${((tax * 100).round() / 100).toString()}'),
        if (isSubPaid)
          multiLangSummeryLine('إجمالي المبلغ المستحق:', 'Total amount due:',
              'SAR ${((wanted * 100).round() / 100).toString()}'),
        if (!isSubPaid)
          multiLangSummeryBoldLine(
              'إجمالي المبلغ المستحق:',
              'Total amount due:',
              'SAR ${((wanted * 100).round() / 100).toString()}'),
        if (isSubPaid)
          multiLangSummeryLine('المبلغ المدفوع:', 'Paid amount:',
              'SAR ${((paid * 100).round() / 100).toString()}'),
        if (isSubPaid)
          multiLangSummeryBoldLine('المبلغ المتبقي:', 'Remaining amount:',
              'SAR ${((remain * 100).round() / 100).toString()}'),
        Divider(height: 0.3 * cm, thickness: 0.05 * cm),
        st13.copyWith(color: PdfColors.red).ar('المبلغ المطلوب: $only',
            alignment: Alignment.center, textAlign: TextAlign.center),
        st13.copyWith(color: PdfColors.red).ar('الرصيد: $balance',
            alignment: Alignment.center, textAlign: TextAlign.center),
        Divider(height: 0.3 * cm, thickness: 0.05 * cm),
        Container(height: 0.3 * cm),
        Row(children: [
          Expanded(
              child: st13.ar('اسم وتوقيع المستلم',
                  alignment: Alignment.center, textAlign: TextAlign.center)),
          Expanded(
              child: st13.ar('أعدت من قبل',
                  alignment: Alignment.center, textAlign: TextAlign.center)),
        ]),
        Row(children: [
          Expanded(
              child: st13.ar('..........................',
                  alignment: Alignment.center, textAlign: TextAlign.center)),
          Expanded(
              child: st13.ar('..........................',
                  alignment: Alignment.center, textAlign: TextAlign.center)),
        ]),
      ])),
      Container(width: cm),
    ]);
  }

  Table getItemsTable(Context context) {
    String totalColTitle =
        ttc ? 'المجموع (شامل الضريبة)' : 'المجموع (غير شامل الضريبة)';
    String totalColTitleEN =
        ttc ? 'Item SubTotal (Including VAT)' : 'Item SubTotal (Excluding VAT)';
    TableRow header = TableRow(repeat: true, children: [
      Column(children: [
        st11b.en(totalColTitleEN,
            alignment: Alignment.center, textAlign: TextAlign.center),
        st11b.ar(totalColTitle,
            alignment: Alignment.center, textAlign: TextAlign.center)
      ]),
      st13b.ar('السعر\nPrice',
          alignment: Alignment.center, textAlign: TextAlign.center),
      st13b.ar('الواحدة\nUnit',
          alignment: Alignment.center, textAlign: TextAlign.center),
      st13b.ar('الكمية\nQty',
          alignment: Alignment.center, textAlign: TextAlign.center),
      st13b.ar('الصنف\nDescription',
          alignment: Alignment.center, textAlign: TextAlign.center),
      st13b.en('No', alignment: Alignment.center, textAlign: TextAlign.center),
    ]);

    List<TableRow> rows = List.generate(items.length + 1, (index) {
      if (index == 0) return header;
      //items array:
      //Name, Amount, Items.Price, Items.TaxRate
      List item = items[index - 1];
      return TableRow(children: [
        st12.ar(((item[1] * item[2] * 100 as double).round() / 100).toString()),
        st12.ar(((item[2] * 100 as double).round() / 100).toString()),
        st12.ar(item[3]),
        st12.ar(((item[1] * 100 as double).round() / 100).toString()),
        st12.ar(item[0]),
        st12.ar(index.toString()),
      ]);
    });
    return Table(
        border: TableBorder.all(width: 0.05 * cm),
        columnWidths: {
          5: FixedColumnWidth(1 * cm),
          4: FixedColumnWidth(6 * cm),
          3: FixedColumnWidth(2 * cm),
          2: FixedColumnWidth(2 * cm),
          1: FixedColumnWidth(3 * cm),
          0: FixedColumnWidth(4 * cm),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.full,
        tableWidth: TableWidth.min,
        children: rows);
  }

  @override
  Future<Uint8List> getLocalReport() async {
    final doc = Document(theme: ThemeData.withFont(base: billfont));
    PdfPageFormat pf = getPageFormat();

    doc.addPage(MultiPage(
        pageFormat: pf,
        crossAxisAlignment: CrossAxisAlignment.center,
        footer: getFooter,
        header: getHeader,
        mainAxisAlignment: MainAxisAlignment.start,
        build: (Context context) {
          return [
            getItemsTable(context),
            getSummery(context),
            //footer is automatically added and repeated
          ];
        })); // Page

    return await doc.save();
  }

  @override
  PdfPageFormat getPageFormat() {
    return PdfPageFormat.a4.copyWith(
        marginBottom: 0.5 * cm,
        marginLeft: 0.5 * cm,
        marginRight: 0.5 * cm,
        marginTop: 0.5 * cm);
  }
}
