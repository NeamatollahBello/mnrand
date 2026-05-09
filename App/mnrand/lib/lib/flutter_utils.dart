import 'dart:io';
import 'package:kumi_popup_window/kumi_popup_window.dart';
import 'package:flutter/material.dart';
import 'ui/forms.dart';

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

bypassHttpCertError() {
  HttpOverrides.global = PostHttpOverrides();
}

onNextFrame(Function() action) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    action();
  });
}

yesNo(String text, Function() onYes,
    {Function()? onNo,
    String yesText = 'نعم',
    String noText = '   لا   ',
    bool backDismiss = true,
    bool outDismiss = true}) {
  var c = application.navigatorKey.currentContext;
  if (c == null) {
    return;
  }
  late KumiPopupWindow p;
  p = showPopupWindow(
    c,
    clickBackDismiss: backDismiss,
    clickOutDismiss: outDismiss,
    childFun: (popup) {
      return Padding(
        key: GlobalKey(),
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(text,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.start),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              await p.dismiss(c);
                              await onYes();
                            },
                            child: Text(yesText)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              p.dismiss(c);

                              if (onNo != null) {
                                onNo();
                              }
                            },
                            child: Text(noText)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

showSnack(String msg) {
  ScaffoldMessenger.of(application.navigatorKey.currentContext!)
      .showSnackBar(SnackBar(content: Text(msg)));
}

List<BoxShadow> getShadow(
    Color frontColor, Color shadowColor, double dx, double dy, double blur) {
  return [
    BoxShadow(color: shadowColor, blurRadius: blur, offset: Offset(dx, dx)),
    BoxShadow(color: frontColor)
  ];
}
