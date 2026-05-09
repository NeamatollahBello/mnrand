import 'appui.dart';
import 'lib/ui/ui.dart';
import 'login.dart';
import 'package:share_plus/share_plus.dart';
import 'pagetemplate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'lib/andsysutils.dart';
import 'lib/ui/forms.dart';

class TRegisterForm extends TForm {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    late String msg;
    if (licStatus == 1) {
      msg =
          'لم تقم بترخيص البرنامج، يرجى التواصل مع البائع وتزويده بالمعرِّف التالي للحصول على كود الترخيص';
    }
    if (licStatus == 6) {
      msg =
          'ترخيص التطبيق منتهي، يرجى التواصل مع البائع وتزويده بالمعرِّف التالي للحصول على كود ترخيص جديد';
    }
    if (licStatus == 2) {
      msg = 'لا يمكن استخدام البرنامج على هذا الجهاز';
    }
    if (licStatus == 3 || licStatus == 4) {
      msg =
          'خطأ في الترخيص، يرجى التواصل مع البائع وتزويده بمعرف الجهاز بالأسفل للحصول على كود الترخيص';
    }
    if (licStatus == 5) {
      msg = 'حصل خطأ أثناء التحقق من الترخيص\n$licCheckError';
    }
    return TTemplatePage(
        activeIndex: 0,
        appBarTitle: '',
        showAppBar: false,
        showBackButton: false,
        showBottomBar: false,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
              if (licStatus == 1 ||
                  licStatus == 3 ||
                  licStatus == 4 ||
                  licStatus == 5 ||
                  licStatus == 6)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    andDeviceID,
                    textAlign: TextAlign.center,
                  ),
                ),
              if (licStatus == 1 ||
                  licStatus == 3 ||
                  licStatus == 4 ||
                  licStatus == 5 ||
                  licStatus == 6)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: andDeviceID));
                          },
                          child: const Text('نسخ معرف الجهاز')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: () {
                            SharePlus.instance
                                .share(ShareParams(text: andDeviceID));
                          },
                          child: const Text('مشاركة معرف الجهاز')),
                    )
                  ],
                ),
              if (licStatus == 1 ||
                  licStatus == 3 ||
                  licStatus == 4 ||
                  licStatus == 6)
                UI(
                  alignment: Alignment.center,
                  paddingAll: 8,
                  child: TextButton(
                    child: const Text('تحديث'),
                    onPressed: () async {
                      isLoading = true;
                      refresh();
                      licStatus = await getLic();
                      isLoading = false;
                      refresh();
                      if (licStatus != 0) {
                        refresh();
                      } else {
                        if (isFirst) {
                          loginForm.tryLoad();
                          rechecklic();
                          loginForm.showOnly();
                        } else {
                          await close();
                        }
                      }
                    },
                  ),
                ),
              if ((licStatus == 1 ||
                      licStatus == 3 ||
                      licStatus == 4 ||
                      licStatus == 6) &&
                  isLoading)
                UI(
                  alignment: Alignment.center,
                  maxWidth: 400,
                  paddingAll: 8,
                  paddingTop: 25,
                  child: const Text('جاري التحديث ...'),
                ),
            ]));
  }
}

TRegisterForm registerForm = TRegisterForm();
