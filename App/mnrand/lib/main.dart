import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'appui.dart';
import 'lib/andsysutils.dart';
import 'lib/flutter_utils.dart';
import 'login.dart';
import 'reg.dart';
import 'utils.dart';
import 'lib/ui/forms.dart';
import 'appsettings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("ar_SA", null);
  setFormats('ar_SA');
  await loadSettings();
  bypassHttpCertError();
  await initAppUI();
  if (licStatus != 0) {
    application.run(registerForm);
  } else {
    loginForm.tryLoad();
    rechecklic(); //runs after 1 day and every day
    application.run(loginForm);
  }
}
