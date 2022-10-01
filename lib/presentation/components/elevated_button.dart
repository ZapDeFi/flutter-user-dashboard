import 'package:flutter/material.dart';
import 'package:zapdefiapp/common/constants/border_radius.dart';
import 'package:zapdefiapp/common/constants/dimensions.dart';
import 'package:zapdefiapp/presentation/themes/theme_colors.dart';

class AppElevatedButton extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? child;
  final Animation<double>? enableFraction;
  final Color? backgroundColor;
  final Color? borderColor;

  final ButtonType buttonType;
  final StyleType styleType;
  final bool isLoading;
  final double? height;

  /// only wraps child with a GestureDetector
  final bool raw;

  const AppElevatedButton({
    super.key,
    required this.onTap,
    this.onLongPress,
    required this.child,
    this.buttonType = ButtonType.primary,
    this.styleType = StyleType.primary,
    this.isLoading = false,
    this.enableFraction,
    this.backgroundColor,
    this.borderColor,
    this.raw = false,
    this.height,
  });

  Color _backgroundColor(Set<MaterialState> states) {
    if (backgroundColor != null) return backgroundColor!;
    if (states.contains(MaterialState.disabled)) {
      switch (buttonType) {
        case ButtonType.primary:
          return AppColorDark.primaryButtonDisabledColor;
        case ButtonType.secondary:
          return Colors.transparent;
      }
    }
    switch (buttonType) {
      case ButtonType.primary:
        switch (styleType) {
          case StyleType.primary:
            return AppColorDark.primaryButtonPrimaryStyleColor;
          case StyleType.secondary:
            return AppColorDark.primaryButtonSecondaryStyleColor;
          case StyleType.destructive:
            return AppColorDark.primaryButtonDestructiveStyleColor;
          case StyleType.special:
            return AppColorDark.primaryButtonSpecialStyleGradientColors.first;
        }
      case ButtonType.secondary:
        return Colors.transparent;
    }
  }

  Color overlayColor(Set<MaterialState> states) {
    switch (buttonType) {
      case ButtonType.primary:
        switch (styleType) {
          case StyleType.primary:
            return AppColorDark.primaryButtonPrimaryStylePressedColor;
          case StyleType.secondary:
            return AppColorDark.primaryButtonSecondaryStylePressedColor;
          case StyleType.destructive:
            return AppColorDark.primaryButtonDestructiveStylePressedColor;
          case StyleType.special:
            return AppColorDark.primaryButtonSpecialStylePressedColor;
        }
      case ButtonType.secondary:
        switch (styleType) {
          case StyleType.primary:
            return AppColorDark.secondaryButtonPrimaryStylePressedColor;
          case StyleType.secondary:
            return AppColorDark.secondaryButtonSecondaryStylePressedColor;
          case StyleType.destructive:
            return AppColorDark.secondaryButtonDestructiveStylePressedColor;
          default:
            throw UnsupportedError(
              'Style:$styleType for Type:${ButtonType.secondary.name} is not supported',
            );
        }
    }
  }

  Color foregroundColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      switch (buttonType) {
        case ButtonType.primary:
          return AppColorDark.primaryButtonDisabledTitleColor;
        case ButtonType.secondary:
          return AppColorDark.secondaryButtonDisabledTitleColor;
      }
    }
    switch (buttonType) {
      case ButtonType.primary:
        switch (styleType) {
          case StyleType.primary:
            return AppColorDark.primaryButtonPrimaryStyleTitleColor;
          case StyleType.secondary:
            return AppColorDark.primaryButtonSecondaryStyleTitleColor;
          case StyleType.destructive:
            return AppColorDark.primaryButtonDestructiveStyleTitleColor;
          case StyleType.special:
            return AppColorDark.primaryButtonSpecialStyleTitleColor;
        }
      case ButtonType.secondary:
        switch (styleType) {
          case StyleType.primary:
            return AppColorDark.secondaryButtonPrimaryStyleTitleColor;
          case StyleType.secondary:
            return AppColorDark.secondaryButtonSecondaryStyleTitleColor;
          case StyleType.destructive:
            return AppColorDark.secondaryButtonDestructiveStyleTitleColor;
          default:
            throw UnsupportedError(
              'Style:$styleType for Type:${ButtonType.secondary.name} is not supported',
            );
        }
    }
  }

  TextStyle textStyle({
    required Set<MaterialState> states,
    final String? fontFamily,
  }) {
    return TextStyle(
      fontSize: 17,
      fontFamily: fontFamily,
      fontWeight: FontWeight.bold,
      color: foregroundColor(states),
    );
  }

  Size fixedSize(Set<MaterialState> states) {
    final double height;
    if (buttonType == ButtonType.secondary &&
        styleType == StyleType.secondary) {
      height = AppDimensions.elevatedButtonHeightCollapsed;
    } else {
      height = AppDimensions.elevatedButtonHeight;
    }
    return Size.fromHeight(this.height ?? height);
  }

  OutlinedBorder shape(Set<MaterialState> states) {
    final BorderSide borderSide;
    if (buttonType == ButtonType.secondary &&
        styleType != StyleType.secondary) {
      borderSide = BorderSide(
        width: 2,
        color: borderColor ?? AppColorDark.secondaryButtonBorderColor,
      );
    } else {
      borderSide = BorderSide.none;
    }
    return RoundedRectangleBorder(
      side: borderSide,
      borderRadius: AppBorderRadius.normal.asBorderRadius(),
    );
  }

  ButtonStyle style({final String? fontFamily}) {
    return ButtonStyle(
      splashFactory: InkSplash.splashFactory,
      elevation: MaterialStateProperty.all(0),
      backgroundColor: MaterialStateColor.resolveWith(_backgroundColor),
      overlayColor: MaterialStateColor.resolveWith(overlayColor),
      foregroundColor: MaterialStateColor.resolveWith(foregroundColor),
      textStyle: MaterialStateProperty.resolveWith(
        (states) => textStyle(
          states: states,
          fontFamily: fontFamily,
        ),
      ),
      fixedSize: MaterialStateProperty.resolveWith(fixedSize),
      shape: MaterialStateProperty.resolveWith(shape),
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
        horizontal: VisualDensity.minimumDensity,
      ),
    );
  }

  Widget get _loadingChild {
    final Color dotColor;
    if (buttonType == ButtonType.primary && styleType == StyleType.secondary) {
      dotColor = AppColorDark.buttonLoadingDotsSecondaryColor;
    } else {
      dotColor = AppColorDark.buttonLoadingDotsPrimaryColor;
    }
    return const Text('loading ...');
  }

  Gradient? _backgroundGradient() {
    if (buttonType == ButtonType.primary && styleType == StyleType.special) {
      return const LinearGradient(
        colors: AppColorDark.primaryButtonSpecialStyleGradientColors,
      );
    }

    return null;
  }

  void Function()? get onPressed {
    if (isLoading && onTap != null) {
      return () {};
    } else {
      return onTap;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (raw) {
      return GestureDetector(
        onTap: onPressed,
        onLongPress: onLongPress,
        behavior: HitTestBehavior.opaque,
        child: this.child,
      );
    }

    final fontFamily = DefaultTextStyle.of(context).style.fontFamily;

    final enableFraction = this.enableFraction;
    Widget? child = isLoading ? _loadingChild : this.child;
    if (enableFraction != null) {
      child = AnimatedBuilder(
        animation: enableFraction,
        builder: (context, child) {
          final enableFractionValue = enableFraction.value;
          return DefaultTextStyle(
            style: TextStyle.lerp(
              textStyle(
                states: {MaterialState.disabled},
                fontFamily: fontFamily,
              ),
              textStyle(
                states: {},
                fontFamily: fontFamily,
              ),
              enableFractionValue,
            )!,
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: enableFractionValue < .5
                      ? [0, enableFractionValue * 2]
                      : [(enableFractionValue - .5) * 2, 1],
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                  colors: [
                    _backgroundColor({}),
                    _backgroundColor({MaterialState.disabled}),
                  ],
                ),
              ),
              child: child,
            ),
          );
        },
        child: Center(child: isLoading ? _loadingChild : child),
      );
    } else {
      final backgroundGradient = _backgroundGradient();
      if (backgroundGradient != null) {
        child = Ink(
          decoration: BoxDecoration(gradient: backgroundGradient),
          child: SizedBox.expand(child: Center(child: child)),
        );
      }
    }
    return ElevatedButton(
      style: style(fontFamily: fontFamily),
      onPressed: onPressed,
      onLongPress: onLongPress,
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }
}

enum ButtonType { primary, secondary }

enum StyleType { primary, secondary, destructive, special }
