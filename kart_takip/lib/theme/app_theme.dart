import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Uygulama temaları: düz yüzeyler (gölge/gradyan yok), kartlarda 16px,
/// butonlarda 8px köşe yuvarlaklığı.
///
/// Tipografi: başlıklar Space Grotesk, gövde Inter; parasal değerler her
/// yerde [para] ile IBM Plex Mono (tabular figures) kullanır.
abstract final class AppTheme {
  static ThemeData get light => _tema(
    parlaklik: Brightness.light,
    arkaPlan: AppColors.background,
    yuzey: AppColors.surface,
    murekkep: AppColors.ink,
    vurgu: AppColors.positive,
    tehlike: AppColors.danger,
    murekkepUstu: AppColors.background,
  );

  static ThemeData get dark => _tema(
    parlaklik: Brightness.dark,
    arkaPlan: AppColors.backgroundDark,
    yuzey: AppColors.surfaceDark,
    murekkep: AppColors.inkDark,
    vurgu: AppColors.positiveDark,
    tehlike: AppColors.dangerDark,
    murekkepUstu: AppColors.backgroundDark,
  );

  /// Parasal değerler için IBM Plex Mono, tabular figures.
  static TextStyle para(
    BuildContext context, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w500,
    Color? color,
  }) {
    return GoogleFonts.ibmPlexMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static ThemeData _tema({
    required Brightness parlaklik,
    required Color arkaPlan,
    required Color yuzey,
    required Color murekkep,
    required Color vurgu,
    required Color tehlike,
    required Color murekkepUstu,
  }) {
    final ikincilMetin = murekkep.withValues(alpha: 0.65);

    final colorScheme = ColorScheme(
      brightness: parlaklik,
      primary: murekkep,
      onPrimary: murekkepUstu,
      secondary: vurgu,
      onSecondary: parlaklik == Brightness.light
          ? AppColors.ink
          : AppColors.backgroundDark,
      error: tehlike,
      onError: Colors.white,
      errorContainer: tehlike.withValues(alpha: 0.14),
      onErrorContainer: tehlike,
      surface: yuzey,
      onSurface: murekkep,
      onSurfaceVariant: ikincilMetin,
      outline: murekkep.withValues(alpha: 0.45),
    );

    final govdeTemasi = GoogleFonts.interTextTheme(
      parlaklik == Brightness.light
          ? Typography.blackMountainView
          : Typography.whiteMountainView,
    ).apply(bodyColor: murekkep, displayColor: murekkep);

    TextStyle baslik(double fontSize, FontWeight fontWeight) =>
        GoogleFonts.spaceGrotesk(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: murekkep,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: parlaklik,
      scaffoldBackgroundColor: arkaPlan,
      colorScheme: colorScheme,
      textTheme: govdeTemasi.copyWith(
        headlineMedium: baslik(28, FontWeight.w600),
        titleLarge: baslik(20, FontWeight.w600),
        titleMedium: baslik(16, FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: arkaPlan,
        foregroundColor: murekkep,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: baslik(20, FontWeight.w600),
      ),
      cardTheme: CardTheme(
        color: yuzey,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: murekkep,
        foregroundColor: murekkepUstu,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: murekkep,
          foregroundColor: murekkepUstu,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: murekkep,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: yuzey,
        labelStyle: TextStyle(color: ikincilMetin),
        floatingLabelStyle: TextStyle(color: murekkep),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: murekkep.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: murekkep.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: murekkep, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: tehlike),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: tehlike, width: 1.5),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: murekkep,
        textColor: murekkep,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStatePropertyAll(yuzey),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? murekkep
              : murekkep.withValues(alpha: 0.25),
        ),
      ),
      dividerColor: murekkep.withValues(alpha: 0.12),
    );
  }
}
