import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyWhite = Color(0xFFF8F9FA);
  static const Color background = Color(0xFFF0F0F0);
  static const Color darkText = Color(0xFF1A1A2E);
  static const Color lightText = Color(0xFF6B7280);
  static const Color deactivatedText = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color cardBg = Color(0xFFFFFFFF);

  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFFEFF6FF);
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFF0FDF4);
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color gray = Color(0xFF6B7280);
  static const Color grayLight = Color(0xFFF3F4F6);

  static const TextStyle headline = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 22,
    color: darkText,
  );

  static const TextStyle title = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: darkText,
  );

  static const TextStyle subtitle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: lightText,
  );

  static const TextStyle body1 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 13,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: lightText,
  );

  static ButtonStyle get minimalButton => OutlinedButton.styleFrom(
    foregroundColor: gray,
    side: BorderSide(color: border),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    elevation: 0,
  );

  static ButtonStyle get minimalPrimary => ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: white,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    elevation: 0,
  );

  static BoxDecoration get card => BoxDecoration(
    color: cardBg,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: border),
  );

  static BoxDecoration get cardFlat => BoxDecoration(
    color: grayLight,
    borderRadius: BorderRadius.circular(10),
  );

  static ThemeData buildLightTheme() {
    return ThemeData.light().copyWith(
      primaryColor: primary,
      scaffoldBackgroundColor: nearlyWhite,
      canvasColor: white,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: success,
        surface: white,
        error: error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 17, color: darkText),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: border),
        ),
      ),
      dividerTheme: const DividerThemeData(color: border),
      platform: TargetPlatform.iOS,
    );
  }
}
