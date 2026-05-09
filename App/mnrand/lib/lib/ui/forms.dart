import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class TApplication extends TUI {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey {
    return _navigatorKey;
  }

  bool _mainFormSet = false;
  late TForm _mainForm;
  String _title = '';

  String get title => _title;

  set title(String value) {
    _title = value;
    notify();
  }

  terminate() {
    if (onTerminate != null) onTerminate!();
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    }
    exit(0);
  }

  Color? _seedColor;

  Color? get seedColor => _seedColor;

  set seedColor(Color? value) {
    _seedColor = value;
    notify();
  }

  ThemeData? _theme;

  ThemeData? get theme => _theme;

  set theme(ThemeData? value) {
    _theme = value;
    notify();
  }

  Locale? _locale;
  Locale? get locale => _locale;
  set locale(Locale? value) {
    _locale = value;
    notify();
  }

  bool _useSafeArea = true;
  bool get useSafeArea => _useSafeArea;
  set useSafeArea(bool value) {
    _useSafeArea = value;
    notify();
  }

  Iterable<Locale> _supportedLocales = [const Locale('en', 'US')];

  Iterable<Locale> get supportedLocales => _supportedLocales;

  set supportedLocales(Iterable<Locale> value) {
    _supportedLocales = value;
    notify();
  }

  Future<bool> Function()? onCanBackExit;
  Future<bool> Function()? onTerminate;

  run(TForm mainForm) {
    _mainForm = mainForm;
    runApp(UI(child: this));
  }

  Widget _build1(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: _supportedLocales,
        locale: _locale,
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        title: title,
        theme: (theme ??
                ThemeData(
                    useMaterial3: true,
                    colorScheme: ColorScheme.fromSeed(
                        seedColor: seedColor ?? Colors.deepPurple)))
            .copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: ZoomPageTransitionsBuilder(
                allowEnterRouteSnapshotting: false, // This solves your issue
              ),
            },
          ),
        ),
        home: Builder(builder: (context) {
          lastContext = context;
          return UI(child: _mainForm);
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (useSafeArea) {
      return SafeArea(child: _build1(context));
    } else {
      return _build1(context);
    }
  }
}

enum TModalMode { fullScreen, dialog }

enum TDialogVerticalPosition { top, center, bottom, expand }

enum TDialogHorizontalPosition { left, start, center, right, end, expand }

abstract class TForm extends TUI {
  Route? _route;
  dynamic modalResult;
  BorderSide? dialogBorderSide;
  BorderRadiusGeometry? dialogBorderRadius;
  TDialogHorizontalPosition dialogHorizontalPosition =
      TDialogHorizontalPosition.center;
  TDialogVerticalPosition dialogVerticalPosition =
      TDialogVerticalPosition.center;

  EdgeInsets? dialogPadding;
  bool get visible {
    try {
      return ModalRoute.of(lastContext)!.isActive;
    } catch (e) {
      return false;
    }
  }

  bool get isFirst {
    try {
      return ModalRoute.of(lastContext)!.isFirst;
    } catch (e) {
      return false;
    }
  }

  TForm() {
    if (!application._mainFormSet) {
      application._mainFormSet = true;
      application._mainForm = this;
    }
  }

  TModalMode modalMode = TModalMode.fullScreen;
  bool clickOutWillPop = false;
  Color barrierColor = Colors.black54;

  Future Function()? onShow;
  Future<bool> Function()? onCanBackClose;
  Future<void> Function()? onClosed;

  Future<void> show() async {
    if (visible) return;
    modalResult = null;
    if (onShow != null) onShow!();
    _route = MaterialPageRoute(
      builder: (context) {
        return UI(child: this);
      },
    );
    application._navigatorKey.currentState!.pushReplacement(_route!);
  }

  Future<void> showOnly() async {
    modalResult = null;
    if (onShow != null) onShow!();
    _route = MaterialPageRoute(
      builder: (context) {
        return UI(child: this);
      },
    );
    application._navigatorKey.currentState!.pushAndRemoveUntil(
      _route!,
      (route) {
        return false;
      },
    );
  }

  Future<dynamic> showModal() async {
    if (visible) return null;
    modalResult = null;
    if (onShow != null) onShow!();
    if (modalMode == TModalMode.dialog) {
      _route = DialogRoute(
        barrierDismissible: clickOutWillPop,
        barrierColor: barrierColor,
        context: application._navigatorKey.currentState!.context,
        builder: (context) {
          Widget dlg = Dialog(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
                side: dialogBorderSide ?? BorderSide.none,
                borderRadius: dialogBorderRadius ?? BorderRadius.zero),
            insetPadding: dialogPadding,
            child: UI(child: this),
          );
          if (dialogHorizontalPosition != TDialogHorizontalPosition.expand) {
            var mal = MainAxisAlignment.center;
            if (dialogHorizontalPosition == TDialogHorizontalPosition.start ||
                dialogHorizontalPosition == TDialogHorizontalPosition.left) {
              mal = MainAxisAlignment.start;
            } else if (dialogHorizontalPosition ==
                    TDialogHorizontalPosition.end ||
                dialogHorizontalPosition == TDialogHorizontalPosition.right) {
              mal = MainAxisAlignment.end;
            }
            dlg = Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: mal,
              children: [dlg],
            );
            if (dialogHorizontalPosition == TDialogHorizontalPosition.right ||
                dialogHorizontalPosition == TDialogHorizontalPosition.left) {
              dlg =
                  Directionality(textDirection: TextDirection.ltr, child: dlg);
            }
          }
          if (dialogVerticalPosition != TDialogVerticalPosition.expand) {
            var mal = MainAxisAlignment.center;
            if (dialogVerticalPosition == TDialogVerticalPosition.top) {
              mal = MainAxisAlignment.start;
            } else if (dialogVerticalPosition ==
                TDialogVerticalPosition.bottom) {
              mal = MainAxisAlignment.end;
            }
            dlg = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: mal,
              children: [dlg],
            );
          }
          return dlg;
        },
      );
    } else {
      _route = MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) {
          return UI(child: this);
        },
      );
    }
    Future f = application._navigatorKey.currentState!.push(_route!);
    return await f;
  }

  Future<void> close([dynamic modalResult]) async {
    if (!visible) return;
    if (isFirst) application.terminate();
    application._navigatorKey.currentState!
        .popUntil((route) => route == _route);
    application._navigatorKey.currentState!.pop(modalResult);
  }

  Future<void> closeNext([dynamic modalResult]) async {
    if (!visible) return;
    application._navigatorKey.currentState!
        .popUntil((route) => route == _route);
  }

  @override
  Widget preBuild(BuildContext context, Widget child) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onWillPop,
      child: Material(child: child),
    );
  }

  void _onWillPop(bool didPop, dynamic result) async {
    if (didPop) {
      if (onClosed != null) await onClosed!();
      return;
    }
    if (onCanBackClose != null) if (!(await onCanBackClose!())) return;

    if (!isFirst) {
      close(modalResult);
      return;
    }

    if (application.onCanBackExit != null) {
      if (!(await application.onCanBackExit!())) {
        return;
      }
    }
    application.terminate();
  }
}

TApplication application = TApplication();
