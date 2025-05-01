import 'package:flutter/material.dart';
import 'package:medzo/theme/text_theme.dart';


ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: TTextTheme.lightTextTheme,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF9FAFB),
    scrolledUnderElevation: 0,
  ),
  drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFFF9FAFB)),
  datePickerTheme: const DatePickerThemeData(
    backgroundColor: Color(0xFFF9FAFB),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Color(0xFFD1D5DB)),
      foregroundColor: WidgetStatePropertyAll(Color(0xFF2563EB)),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFFF9FAFB),
  ),
  timePickerTheme: const TimePickerThemeData(
    backgroundColor: Color(0xFFF9FAFB),
    dayPeriodColor: Color(0xFF2563EB),
  ),
  outlinedButtonTheme: const OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
    ),
  ),
  dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,

    //PRIMARY
    primary: Color(0xFF2563EB),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFBBCFF9),
    onPrimaryContainer: Color(0xFF102A63),
    primaryFixed: Color(0xFF6D96F2),
    primaryFixedDim: Color(0xFFE9EFFD),

    //SECONDARY
    secondary: Color(0xFF6B7280),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFF3F4F6),
    onSecondaryContainer: Color(0xFF111827),
    secondaryFixed: Color(0xFFD1D5DB),
    secondaryFixedDim: Color(0xFFF9FAFB),
    onSecondaryFixed: Color.fromARGB(255, 242, 245, 255),

    //ERROR
    error: Color(0xFFEF4444),
    onError: Color(0xFFFEE2E2),
    errorContainer: Color(0xFFFCA5A5),
    onErrorContainer: Color(0xFFFEF2F2),

    //SUCCESS
    tertiary: Color(0xFF22C55E),
    onTertiary: Color(0xFFDCFCE7),
    tertiaryContainer: Color(0xFF86EFAC),
    onTertiaryContainer: Color(0xFFF0FDF4),

    //WARNING
    tertiaryFixed: Color(0xFFF59E0B),
    onTertiaryFixed: Color(0xFFFEF3C7),
    tertiaryFixedDim: Color(0xFFFCD34D),
    onTertiaryFixedVariant: Color(0xFFFFFBEB),

    //BUTTON GRADIENT
    surfaceContainerHigh: Color(0xFF271FE0),
    surfaceContainerLow: Color(0xFF8C87FF),

    //SURFACE
    surface: Color(0xFFF9FAFB),
    onSurface: Colors.black,
  ),
);
