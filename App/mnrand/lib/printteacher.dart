// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'clients.dart';
import 'appui.dart';
import 'teacher.dart';
import 'lib/andsysutils.dart';
import 'lib/flutter_utils.dart';
import 'lib/printutils.dart';
import 'preview.dart';
import 'utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:tafqit/tafqit.dart';

TeacherPrint? _createTeacherPrint(
    int accIndex, DateTime? from, DateTime? to, TTeacherTable tbl) {
  // load bill data
  if (licTradeRecord.trim().isEmpty) {
    showSnack('لم تقم بضبط معلومات المنشأة');
    return null;
  }
  TeacherPrint kp = TeacherPrint();
  kp.tbl = tbl;
  kp.from = from;
  kp.to = to;
  kp.clientName = accountsForm.accounts.name[accIndex]!;
  kp.seller = licCompName;
  kp.taxNum = licTaxNum;
  kp.tradeRecord = licTradeRecord;
  kp.compAddress = compAddress;
  if (kp.seller.isEmpty || kp.taxNum.isEmpty) {
    showSnack('يرجى ضبط اسم المنشأة والرقم الضريبي');
    return null;
  }
  kp.docName = 'دفتر الأستاذ لحساب ${kp.clientName}';

  return kp;
}

printTeacher(int accIndex, DateTime from, DateTime to, TTeacherTable tbl,
    bool directPrint) async {
  TeacherPrint? kp = _createTeacherPrint(accIndex, from, to, tbl);
  if (kp != null) {
    Uint8List pdf = await kp.getA4();

    if ((Platform.isWindows && directPrint) || Platform.isAndroid) {
      Printing.layoutPdf(
        onLayout: (format) async {
          return pdf;
        },
        format: PdfPageFormat.a4,
        name: kp.docName,
      );
    } else {
      previewForm.preview(pdf, kp.docName);
    }
  }
}

shareTeacher(
    int accIndex, DateTime? from, DateTime? to, TTeacherTable tbl) async {
  TeacherPrint? kp = _createTeacherPrint(accIndex, from, to, tbl);
  if (kp != null) {
    Uint8List pdf = await kp.getA4();
    String p = (await getApplicationCacheDirectory()).path;
    if (p.endsWith('/')) {
      p += '${kp.docName}.pdf';
    } else {
      p += '/${kp.docName}.pdf';
    }
    File(p).writeAsBytesSync(pdf);
    await SharePlus.instance.share(ShareParams(files: [XFile(p)]));
  }
}

class TeacherPrint {
  Tafqit tfq = Tafqit();
  late String seller;
  late String taxNum;
  late String tradeRecord;
  late TTeacherTable tbl;
  late String clientName;
  late String compAddress;
  late DateTime? from;
  late DateTime? to;
  late String docName;
  late double cm;

  Widget getHeader(Context context) {
    String title = docName;
    if (from != null) title += ' من ${dateFormat.format(from!)}';
    if (to != null) title += ' إلى ${dateFormat.format(to!)}';

    if (context.pageNumber == 1) {
      return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(height: 0.3 * cm),
        Row(children: [
          Container(width: 1 * cm),
          if (compLogo.isNotEmpty)
            Image(MemoryImage(compLogo), width: 3 * cm, height: 3 * cm),
          Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            st15.ar(seller),
            st15b.ar('الرقم الضريبي $taxNum'),
            st15b.ar('السجل التجاري $tradeRecord')
          ]),
          Container(width: 1 * cm)
        ]),
        Container(height: 0.5 * cm),
        st15b.ar(title, alignment: Alignment.center),
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
          child: st12.en(
              'Printed on: ${dateFormat.format(d)}    Time: ${timeFormat.format(d)}',
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.left),
        ),
        st12.en('Page ${context.pageNumber} of ${context.pagesCount}'),
        Container(width: 2 * cm),
      ]),
      Container(height: 0.5 * cm),
    ]);
  }

  Table getItemsTable(Context context) {
    TableRow header = TableRow(repeat: true, children: [
      st14b.ar('رقم السند',
          alignment: Alignment.center, textAlign: TextAlign.center),
      st14b.ar('الرصيد',
          alignment: Alignment.center, textAlign: TextAlign.center),
      st14b.ar('دائن',
          alignment: Alignment.center, textAlign: TextAlign.center),
      st14b.ar('مدين',
          alignment: Alignment.center, textAlign: TextAlign.center),
      st14b.ar('البيان',
          alignment: Alignment.center, textAlign: TextAlign.center),
      st14b.ar('التاريخ',
          alignment: Alignment.center, textAlign: TextAlign.center),
    ]);

    List<TableRow> rows = List.generate(tbl.recordCount + 1, (index) {
      if (index == 0) return header;
      index--;
      return TableRow(children: [
        st12.ar(tbl.doc[index] ?? ''),
        st12.ar(tbl.balance[index] ?? ''),
        st12.ar(tbl.daen[index] ?? ''),
        st12.ar(tbl.madeen[index] ?? ''),
        st12.ar(tbl.notes[index] ?? ''),
        st12.ar(tbl.date[index] ?? ''),
      ]);
    });
    return Table(
        border: TableBorder.all(width: 0.05 * cm),
        columnWidths: {
          5: FixedColumnWidth(3 * cm),
          4: FixedColumnWidth(5 * cm),
          3: FixedColumnWidth(3 * cm),
          2: FixedColumnWidth(3 * cm),
          1: FixedColumnWidth(3.5 * cm),
          0: FixedColumnWidth(2.5 * cm),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.full,
        tableWidth: TableWidth.min,
        children: rows);
  }

  Future<Uint8List> getA4() {
    final doc = Document(theme: ThemeData.withFont(base: billfont));
    cm = PdfPageFormat.a4.width / 21;
    PdfPageFormat pf = PdfPageFormat.a4.copyWith(
        marginBottom: 0.5 * cm,
        marginLeft: 0.5 * cm,
        marginRight: 0.5 * cm,
        marginTop: 0.5 * cm);

    doc.addPage(MultiPage(
        pageFormat: pf,
        crossAxisAlignment: CrossAxisAlignment.center,
        footer: getFooter,
        header: getHeader,
        mainAxisAlignment: MainAxisAlignment.start,
        build: (Context context) {
          return [
            getItemsTable(context),
            // getSummery(context),
            //footer is automatically added and repeated
          ];
        })); // Page

    return doc.save();
  }
}
