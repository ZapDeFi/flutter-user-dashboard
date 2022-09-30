import 'package:zapdefiapp/presentation/themes/text/theme_text_dark.dart';
import 'package:zapdefiapp/presentation/themes/theme_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final _instance = AppTheme._();

  factory AppTheme() => _instance;

  AppTheme._();

  ThemeData get darkTheme => ThemeData(
        fontFamily: 'MDPrimer',
        primaryColor: AppColorDark.primaryColor,
        colorScheme: const ColorScheme.dark(
          primaryContainer: AppColorDark.primaryVariantColor,
          secondaryContainer: AppColorDark.secondaryVariantColor,
        ),
        dividerColor: AppColorDark.borderColor,
        cardColor: AppColorDark.card,
        textTheme: ThemeTextDark.getDefaultTextTheme(),
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          elevation: 0.0,
          backgroundColor: AppColorDark.background,
          iconTheme: IconThemeData(color: AppColorDark.appBarIconColorLight),
        ),
        buttonTheme: const ButtonThemeData(
          disabledColor: AppColorDark.primaryButtonDisabledColor,
          buttonColor: AppColorDark.primaryButtonPrimaryStyleColor,
          splashColor: AppColorDark.primaryButtonPrimaryStylePressedColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        canvasColor: AppColorDark.canvas,
        scaffoldBackgroundColor: AppColorDark.background,
        toggleableActiveColor: AppColorDark.primaryColor,
        indicatorColor: AppColorDark.indicatorColor,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColorDark.secondaryVariantColor,
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColorDark.tagBlueLight,
        ),
        checkboxTheme: CheckboxThemeData(
          shape: const CircleBorder(),
          visualDensity: VisualDensity.compact,
          side: const BorderSide(
            width: 2,
            color: AppColorDark.checkBoxBorderColor,
          ),
          checkColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppColorDark.checkBoxCheckColor;
            } else {
              return Colors.transparent;
            }
          }),
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppColorDark.checkBoxFillColor;
            } else {
              return Colors.transparent;
            }
          }),
        ),
      );
}
