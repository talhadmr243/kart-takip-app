import 'package:flutter/material.dart';

/// Uygulamanın renk paleti. Material varsayılanları yerine bu palet
/// kullanılır; her rengin koyu tema karşılığı da burada tanımlıdır.
abstract final class AppColors {
  // Aydınlık tema
  /// Yumuşak adaçayı-beyazı sayfa arka planı.
  static const background = Color(0xFFF0F4F1);

  /// Koyu petrol-lacivert; ana metin ve vurgu rengi (ink).
  static const ink = Color(0xFF1F3A3D);

  /// Hardal-altın; tasarruf/pozitif göstergeler.
  static const positive = Color(0xFFC9A227);

  /// Kirli mercan-kırmızı; aidat/uyarı göstergeleri.
  static const danger = Color(0xFFC1483C);

  /// Kart arka planı.
  static const surface = Color(0xFFFFFFFF);

  // Koyu tema
  /// Koyu petrol sayfa arka planı.
  static const backgroundDark = Color(0xFF102224);

  /// Açık adaçayı; koyu temada ana metin ve vurgu.
  static const inkDark = Color(0xFFD7E4DC);

  /// Koyu temada okunurluğu korunan hardal-altın.
  static const positiveDark = Color(0xFFD8B94E);

  /// Koyu temada okunurluğu korunan mercan.
  static const dangerDark = Color(0xFFDA7268);

  /// Koyu temada kart arka planı; arka plandan bir tık açık petrol.
  static const surfaceDark = Color(0xFF1A3134);
}
