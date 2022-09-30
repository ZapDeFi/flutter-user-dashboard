import 'package:flutter/material.dart';
import 'package:zapdefiapp/presentation/themes/theme_colors.dart';

class ThemeTextDark {
  // Default Text Style Following Guideline
  static const headline1 = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    color: AppColorDark.title,
  );
  static const headline2 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColorDark.title,
  );
  static const headline3 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColorDark.title,
  );
  static const headline4 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.normal,
    color: AppColorDark.title,
    height: 25 / 17,
  );
  static const headline5 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    color: AppColorDark.title,
  );
  static const headline6 = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.normal,
    color: AppColorDark.title,
  );
  static const bodyText2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColorDark.title,
  );
  static const bodyText1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColorDark.title,
  );
  static const subtitle1 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.normal,
    color: AppColorDark.title,
    height: 25 / 17,
  );
  static const subtitle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    color: AppColorDark.subtitle2,
    height: 25 / 17,
  );
  static const caption = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: AppColorDark.title,
  );
  static const overline = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    color: AppColorDark.overline,
  );

  static const button = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.normal,
    color: AppColorDark.title,
  );

  static TextTheme getDefaultTextTheme() => const TextTheme(
        headline1: ThemeTextDark.headline1,
        headline2: ThemeTextDark.headline2,
        headline3: ThemeTextDark.headline3,
        headline4: ThemeTextDark.headline4,
        headline5: ThemeTextDark.headline5,
        headline6: ThemeTextDark.headline6,
        bodyText2: ThemeTextDark.bodyText2,
        bodyText1: ThemeTextDark.bodyText1,
        subtitle1: ThemeTextDark.subtitle1,
        subtitle2: ThemeTextDark.subtitle2,
        caption: ThemeTextDark.caption,
        overline: ThemeTextDark.overline,
        button: ThemeTextDark.button,
      );
}
