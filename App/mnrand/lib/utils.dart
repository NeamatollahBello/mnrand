import 'package:intl/intl.dart';

late DateFormat dayNameFormat;
late DateFormat timeFormat;
late DateFormat fullFormat;
late DateFormat dateFormat;
late DateFormat jtimeFormat;
late DateFormat jfullFormat;
late DateFormat jdateFormat;
late DateFormat dashDateFormat;

bool isNumeric(String s) {
  return RegExp(r'^[0-9]+$').hasMatch(s);
}

bool isPhone(String s) {
  return RegExp(r'^\+?[0-9]+$').hasMatch(s);
}

setFormats(String locale) {
  timeFormat = DateFormat('hh:mm a', locale);
  dateFormat = DateFormat('dd / MM / yyyy', locale);
  fullFormat = DateFormat('dd / MM / yyyy hh:mm a', locale);
  jtimeFormat = DateFormat('HH:mm:ss', locale);
  jdateFormat = DateFormat('yyyy-MM-dd', locale);
  jfullFormat = DateFormat('yyyy-MM-dd HH:mm:ss', locale);
  dayNameFormat = DateFormat('EEEE', locale);
  dashDateFormat = DateFormat('dd-MM-yyyy');
}

String dateToNextStr(DateTime? dt) {
  if (dt == null) return '';
  var no = DateTime.now();
  if (dt.isBefore(no)) {
    return fullFormat.format(dt);
  } else {
    no = DateTime(no.year, no.month, no.day);
    var diff = dt.difference(no);
    if (diff.inHours < 24) {
      return 'اليوم ${timeFormat.format(dt)}';
    } else if (diff.inHours < 24 * 2) {
      return 'غداً ${timeFormat.format(dt)}';
    } else if (diff.inHours < 24 * 7) {
      return '${dayNameFormat.format(dt)} ${timeFormat.format(dt)}';
    } else {
      return fullFormat.format(dt);
    }
  }
}
