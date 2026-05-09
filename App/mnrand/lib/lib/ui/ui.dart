import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  Rect? get globalPaintBounds {
    final renderObject = findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}

class InkImage extends StatelessWidget {
  final ImageProvider image;
  final BorderRadiusGeometry? borderRadius;

  const InkImage({super.key, required this.image, this.borderRadius});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0,
          child: Image(
            image: image,
          ),
        ),
        Positioned.fill(
          child: Ink(
            decoration: BoxDecoration(
                borderRadius: borderRadius,
                image: DecorationImage(image: image)),
          ),
        ),
      ],
    );
  }
}

typedef TEvent = Function(dynamic sender);

class UI extends StatelessWidget {
  late final BoxConstraints? _constraints;
  late final EdgeInsetsGeometry? _padding;
  late final EdgeInsetsGeometry? _ipadding;
  late final Decoration? _decoration;
  //params
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final double? paddingLeft;
  final double? paddingRight;
  final double? paddingBottom;
  final double? paddingTop;
  final double? paddingStart;
  final double? paddingEnd;
  final double? paddingHorz;
  final double? paddingVert;
  final double? paddingAll;
  final EdgeInsetsGeometry? ipadding;
  final double? ipaddingLeft;
  final double? ipaddingRight;
  final double? ipaddingBottom;
  final double? ipaddingTop;
  final double? ipaddingStart;
  final double? ipaddingEnd;
  final double? ipaddingHorz;
  final double? ipaddingVert;
  final double? ipaddingAll;
  final double? maxWidth;
  final double? minWidth;
  final double? maxHeight;
  final double? minHeight;
  final double? width;
  final double? height;
  final dynamic child;
  final Color? color;
  final DecorationImage? image;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final BlendMode? backgroundBlendMode;
  final DecorationPosition decorationPosition;
  final BoxShape shape;
  final Function()? onClick;
  final bool ripple;
  final AlignmentGeometry? alignment;
  final AlignmentGeometry? ialignment;
  final bool isInky;
  final bool useMaterial;
  UI({
    super.key,
    this.constraints,
    this.padding,
    this.paddingLeft,
    this.paddingRight,
    this.paddingBottom,
    this.paddingTop,
    this.paddingStart,
    this.paddingEnd,
    this.paddingHorz,
    this.paddingVert,
    this.paddingAll,
    this.ipadding,
    this.ipaddingLeft,
    this.ipaddingRight,
    this.ipaddingBottom,
    this.ipaddingTop,
    this.ipaddingStart,
    this.ipaddingEnd,
    this.ipaddingHorz,
    this.ipaddingVert,
    this.ipaddingAll,
    this.maxWidth,
    this.minWidth,
    this.maxHeight,
    this.minHeight,
    this.width,
    this.height,
    this.color,
    this.image,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.backgroundBlendMode,
    this.shape = BoxShape.rectangle,
    this.decorationPosition = DecorationPosition.background,
    this.onClick,
    this.ripple = true,
    this.alignment = Alignment.topCenter,
    this.ialignment,
    this.child,
    this.isInky = false,
    this.useMaterial = false,
  }) {
    if (constraints != null) {
      _constraints = constraints;
    } else if (minHeight != null ||
        minWidth != null ||
        maxHeight != null ||
        maxWidth != null) {
      _constraints = BoxConstraints(
          minHeight: minHeight ?? 0,
          minWidth: minWidth ?? 0,
          maxHeight: maxHeight ?? double.infinity,
          maxWidth: maxWidth ?? double.infinity);
    } else {
      _constraints = null;
    }

    double? paddingLeft = this.paddingLeft;
    double? paddingRight = this.paddingRight;
    double? paddingBottom = this.paddingBottom;
    double? paddingTop = this.paddingTop;
    double? paddingStart = this.paddingStart;
    double? paddingEnd = this.paddingEnd;

    double? ipaddingLeft = this.ipaddingLeft;
    double? ipaddingRight = this.ipaddingRight;
    double? ipaddingBottom = this.ipaddingBottom;
    double? ipaddingTop = this.ipaddingTop;
    double? ipaddingStart = this.ipaddingStart;
    double? ipaddingEnd = this.ipaddingEnd;

    if (padding != null) {
      _padding = padding;
    } else if (this.paddingLeft == null &&
        this.paddingRight == null &&
        this.paddingBottom == null &&
        this.paddingTop == null &&
        this.paddingStart == null &&
        this.paddingEnd == null &&
        paddingHorz == null &&
        paddingVert == null &&
        paddingAll == null) {
      _padding = null;
    } else {
      if (paddingVert != null) {
        paddingTop ??= paddingVert;
        paddingBottom ??= paddingVert;
      }

      if (paddingHorz != null) {
        if (paddingStart != null || paddingEnd != null) {
          paddingStart ??= paddingHorz;
          paddingEnd ??= paddingHorz;
        }
        paddingLeft ??= paddingHorz;
        paddingRight ??= paddingHorz;
      }

      if (paddingAll != null) {
        if (paddingStart != null || paddingEnd != null) {
          paddingStart ??= paddingAll;
          paddingEnd ??= paddingAll;
        }
        paddingLeft ??= paddingAll;
        paddingRight ??= paddingAll;
        paddingTop ??= paddingAll;
        paddingBottom ??= paddingAll;
      }

      if (paddingStart != null || paddingEnd != null) {
        if (paddingStart != paddingEnd) {
          _padding = EdgeInsetsDirectional.only(
              start: paddingStart ?? 0,
              end: paddingEnd ?? 0,
              top: paddingTop ?? 0,
              bottom: paddingBottom ?? 0);
        } else {
          _padding = EdgeInsets.only(
              left: paddingStart ?? 0,
              right: paddingEnd ?? 0,
              top: paddingTop ?? 0,
              bottom: paddingBottom ?? 0);
        }
      } else {
        _padding = EdgeInsets.only(
            left: paddingLeft ?? 0,
            right: paddingRight ?? 0,
            top: paddingTop ?? 0,
            bottom: paddingBottom ?? 0);
      }
    }

    //inner padding
    if (ipadding != null) {
      _ipadding = ipadding;
    } else if (this.ipaddingLeft == null &&
        this.ipaddingRight == null &&
        this.ipaddingBottom == null &&
        this.ipaddingTop == null &&
        this.ipaddingStart == null &&
        this.ipaddingEnd == null &&
        ipaddingHorz == null &&
        ipaddingVert == null &&
        ipaddingAll == null) {
      _ipadding = null;
    } else {
      if (ipaddingVert != null) {
        ipaddingTop ??= ipaddingVert;
        ipaddingBottom ??= ipaddingVert;
      }

      if (ipaddingHorz != null) {
        if (ipaddingStart != null || ipaddingEnd != null) {
          ipaddingStart ??= ipaddingHorz;
          ipaddingEnd ??= ipaddingHorz;
        }
        ipaddingLeft ??= ipaddingHorz;
        ipaddingRight ??= ipaddingHorz;
      }

      if (ipaddingAll != null) {
        if (ipaddingStart != null || ipaddingEnd != null) {
          ipaddingStart ??= ipaddingAll;
          ipaddingEnd ??= ipaddingAll;
        }
        ipaddingLeft ??= ipaddingAll;
        ipaddingRight ??= ipaddingAll;
        ipaddingTop ??= ipaddingAll;
        ipaddingBottom ??= ipaddingAll;
      }

      if (ipaddingStart != null || ipaddingEnd != null) {
        if (ipaddingStart != ipaddingEnd) {
          _ipadding = EdgeInsetsDirectional.only(
              start: ipaddingStart ?? 0,
              end: ipaddingEnd ?? 0,
              top: ipaddingTop ?? 0,
              bottom: ipaddingBottom ?? 0);
        } else {
          _ipadding = EdgeInsets.only(
              left: ipaddingStart ?? 0,
              right: ipaddingEnd ?? 0,
              top: ipaddingTop ?? 0,
              bottom: ipaddingBottom ?? 0);
        }
      } else {
        _ipadding = EdgeInsets.only(
            left: ipaddingLeft ?? 0,
            right: ipaddingRight ?? 0,
            top: ipaddingTop ?? 0,
            bottom: ipaddingBottom ?? 0);
      }
    }

    if ((color != null && (!useMaterial)) ||
        image != null ||
        border != null ||
        (borderRadius != null && (!useMaterial)) ||
        boxShadow != null ||
        gradient != null ||
        backgroundBlendMode != null) {
      _decoration = BoxDecoration(
          backgroundBlendMode: backgroundBlendMode,
          border: border,
          borderRadius: borderRadius,
          boxShadow: boxShadow,
          color: useMaterial ? null : color,
          gradient: gradient,
          image: image,
          shape: shape);
    } else {
      _decoration = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? c;
    late TUI ui;
    if (child is TUI) {
      ui = child;
      c = ValueListenableBuilder(
        valueListenable: ui._vl,
        builder: (BuildContext context, dynamic value, Widget? child) {
          ui.lastContext = context;
          return ui._build(context);
        },
      );
    } else if (child is Widget) {
      c = child;
    }

    if (ialignment != null) {
      c = Align(
        alignment: ialignment!,
        child: c,
      );
    }

    if (_ipadding != null) {
      c = Padding(
        padding: _ipadding!,
        child: c,
      );
    }

    if (_decoration != null) {
      if (isInky) {
        c = Ink(
          decoration: _decoration,
          child: c,
        );
      } else {
        c = Container(
          decoration: _decoration,
          child: c,
        );
      }
    }

    if (onClick != null && ripple) {
      c = InkWell(
        borderRadius: borderRadius,
        onTap: onClick,
        child: c,
      );
    }
    if (useMaterial) {
      c = Material(
        borderRadius: borderRadius,
        color: color,
        child: c,
      );
    }

    if (width != null || height != null) {
      c = SizedBox(
        width: width,
        height: height,
        child: c,
      );
    }
    if (_constraints != null) {
      c = ConstrainedBox(
        constraints: _constraints!,
        child: c,
      );
    }
    if (onClick != null && !ripple) {
      c = GestureDetector(
        onTap: onClick,
        child: c,
      );
    }

    if (_padding != null) {
      c = Padding(
        padding: _padding!,
        child: c,
      );
    }

    if (alignment != null) {
      c = Align(
        alignment: alignment!,
        child: c,
      );
    }

    return c ?? Container();
  }
}

//remember: this class is designed to get instance from not to inherit it
class TUIPart {
  late BuildContext lastContext;
  Rect? get globalPaintBounds => lastContext.globalPaintBounds;
  final ValueNotifier<bool> _vl = ValueNotifier(false);
  bool needRefresh = false;
  bool isStoringUpdates = false;

  refresh() {
    _vl.value = !_vl.value;
    needRefresh = false;
  }

  notify() {
    if (isStoringUpdates) {
      needRefresh = true;
    } else {
      refresh();
    }
  }

  startUpdate() {
    isStoringUpdates = true;
  }

  endUpdates({bool refreshIfNotNeeded = false}) {
    isStoringUpdates = false;
    if (needRefresh || refreshIfNotNeeded) {
      refresh();
    }
  }
}

abstract class TUI extends TUIPart {
  Widget preBuild(BuildContext context, Widget child) {
    return child;
  }

  Widget build(BuildContext context);

  Widget _build(BuildContext context) {
    lastContext = context;
    return preBuild(context, build(context));
  }
}

class UIPart extends StatelessWidget {
  final TUIPart uiPart;
  final Widget Function(BuildContext context) buildFun;
  const UIPart(this.uiPart, this.buildFun, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: uiPart._vl,
      builder: (BuildContext context, dynamic value, Widget? child) {
        uiPart.lastContext = context;
        return buildFun(context);
      },
    );
  }
}
