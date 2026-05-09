// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'lib/flutter_utils.dart';
import 'lib/ui/forms.dart';
import 'lib/dialogs.dart';
import 'package:printing/printing.dart';

class TPreviewForm extends TForm {
  TPreviewForm();
  late Uint8List pdf;
  late String docName;
  Future Function()? onReturn;

  @override
  Widget build(BuildContext context) {
    return PdfPreview(
      pdfFileName: '$docName.pdf',
      allowSharing: Platform.isAndroid,
      canChangeOrientation: false,
      canChangePageFormat: false,
      canDebug: false,
      actions: [
        IconButton(
            onPressed: () async {
              if (Platform.isWindows) {
                String p = await winSaveDialog(docName, 'pdf');
                if (p.isEmpty) return;
                final File pdfFile = File(p);
                if (pdfFile.existsSync()) {
                  yesNo('الملف موجود مسبقا، هل تريد استبداله؟', () async {
                    await pdfFile.writeAsBytes(pdf);
                  });
                } else {
                  await pdfFile.writeAsBytes(pdf);
                }
              } else if (Platform.isAndroid) {
                androidBrowseAndSave(docName, 'pdf', 'application/pdf',
                    orgData: pdf);
              }
            },
            icon: const Icon(Icons.save)),
        IconButton(
            onPressed: () async {
              if (onReturn != null) onReturn!();
              close();
            },
            icon: const Icon(Icons.close)),
      ],
      build: (format) async {
        return pdf;
      },
    );
  }

  preview(Uint8List pdf, String docName, {Future Function()? onReturn}) {
    this.pdf = pdf;
    this.onReturn = onReturn;
    this.docName = docName;
    showModal();
  }
}

TPreviewForm previewForm = TPreviewForm();
