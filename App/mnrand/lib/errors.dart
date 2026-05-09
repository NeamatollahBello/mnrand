import 'lib/flutter_utils.dart';

const msgar = {
  'http': 'حدث خطأ بالاتصال بالسرفر، تحقق من اتصالك بالانترنت',
  'empty': 'تم الحصول على رد فارغ من المخدم',
  'format': 'تم الحصول على رد غير متوقع من المخدم',
  'login': 'خطأ باسم المستخدم أو كلمة المرور',
  'sql': 'حصل خطأ اثناء تنفيذ العملية',
  'exp': 'صلاحية السرفر منتهية',
  'per': 'ليس لديك صلاحية للقيام بهذه العملية',
  'lim': 'لا يمكن إتمام العملية بسبب تجاوز الحد الأعلى',
};

var msg = msgar;

showApiError(Map<String, dynamic> res) {
  if (res['e'] != 'ok') {
    showSnack(msg[res['e']] ?? 'حدث الخطأ التالي: ${res['e']}');
    return true;
  }
  return false;
}

showMsg(String msgCode) {
  String? s = msg[msgCode];
  if (s == null) return;
  showSnack(s);
}
