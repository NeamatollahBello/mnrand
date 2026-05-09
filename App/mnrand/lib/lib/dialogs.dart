// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path/path.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';

Future<String> winSaveDialog(String suggested, String ext,
    [String extDesc = '']) async {
  if (!Platform.isWindows) return '';
  if (extDesc.trim().isEmpty) {
    extDesc = '${ext.toUpperCase()} Files';
  }

  final FileSaveLocation? result =
      await getSaveLocation(suggestedName: suggested, acceptedTypeGroups: [
    XTypeGroup(extensions: [ext], label: extDesc)
  ]);
  if (result == null) return '';
  String p = setExtension(result.path, '.$ext');
  return p;
}

Future<XFile?> openDialog(
  Map<String, List<String>> descWithExts,
) async {
  return (await openFile(
      acceptedTypeGroups: descWithExts.entries.map<XTypeGroup>(
    (e) {
      return XTypeGroup(label: e.key, extensions: e.value);
    },
  ).toList()));
}

Future<String> androidBrowseAndSave(String suggested, String ext, String mime,
    {String? orgFileName, Uint8List? orgData}) async {
  if ((orgFileName ?? '').isEmpty) {
    String tmp = (await getApplicationDocumentsDirectory()).path;
    if (tmp.endsWith('/')) {
      tmp = '${tmp}tmp';
    } else {
      tmp = '$tmp/tmp';
    }
    File(tmp).writeAsBytesSync(orgData!);
    orgFileName = tmp;
  }
  String? filePath = await FlutterFileDialog.saveFile(
      params: SaveFileDialogParams(
          sourceFilePath: orgFileName,
          fileName: '$suggested.$ext',
          mimeTypesFilter: [mime]));
  return filePath ?? '';
}

// openFile(Map<String, List<String>>){
//   const XTypeGroup typeGroup = XTypeGroup(
//   label: 'images',
//   extensions: <String>['jpg', 'png'],
// );
// final XFile? file =
//     await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
// }