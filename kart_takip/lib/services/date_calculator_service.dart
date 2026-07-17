import 'package:kart_takip/data/database.dart';

/// Kart kesim/aidat ve abonelik yenilenme tarihlerini hesaplar.
///
/// Tüm hesaplamalar gün hassasiyetindedir (saat bileşeni yok sayılır) ve
/// "bugün" hedef günse o gün döndürülür (kapsayıcı/inclusive).
class DateCalculatorService {
  /// Verilen [kesimGunu] (1-31) için [from] tarihinden itibaren (dahil)
  /// bir sonraki kart ekstre kesim tarihini döndürür.
  ///
  /// Ayın o gününden daha kısa olması durumunda (örn. kesimGunu=31 ama
  /// Şubat) ayın son gününe sabitlenir (clamp).
  DateTime nextKesimTarihi(int kesimGunu, {DateTime? from}) {
    assert(kesimGunu >= 1 && kesimGunu <= 31);
    final today = _dateOnly(from ?? DateTime.now());
    var candidate = _clampedDate(today.year, today.month, kesimGunu);
    if (candidate.isBefore(today)) {
      candidate = _clampedDate(today.year, today.month + 1, kesimGunu);
    }
    return candidate;
  }

  /// [aidatTarihi] içindeki ay/gün baz alınarak [from] tarihinden itibaren
  /// (dahil) bir sonraki yıllık kart aidatı tarihini döndürür.
  DateTime nextAidatTarihi(DateTime aidatTarihi, {DateTime? from}) {
    final today = _dateOnly(from ?? DateTime.now());
    var candidate = _clampedDate(today.year, aidatTarihi.month, aidatTarihi.day);
    if (candidate.isBefore(today)) {
      candidate = _clampedDate(today.year + 1, aidatTarihi.month, aidatTarihi.day);
    }
    return candidate;
  }

  /// [baslangicTarihi] ve [periyot] (aylık/yıllık) baz alınarak [from]
  /// tarihinden itibaren (dahil) bir sonraki abonelik yenilenme tarihini
  /// döndürür. Başlangıç tarihi henüz gelmediyse başlangıç tarihinin
  /// kendisi döndürülür.
  DateTime nextYenilenmeTarihi({
    required DateTime baslangicTarihi,
    required SubscriptionPeriod periyot,
    DateTime? from,
  }) {
    final today = _dateOnly(from ?? DateTime.now());
    final start = _dateOnly(baslangicTarihi);
    if (!start.isBefore(today)) {
      return start;
    }

    if (periyot == SubscriptionPeriod.aylik) {
      final monthsSinceStart =
          (today.year - start.year) * 12 + (today.month - start.month);
      var candidate = _addMonths(start, monthsSinceStart);
      if (candidate.isBefore(today)) {
        candidate = _addMonths(start, monthsSinceStart + 1);
      }
      return candidate;
    }

    final yearsSinceStart = today.year - start.year;
    var candidate =
        _clampedDate(start.year + yearsSinceStart, start.month, start.day);
    if (candidate.isBefore(today)) {
      candidate =
          _clampedDate(start.year + yearsSinceStart + 1, start.month, start.day);
    }
    return candidate;
  }

  DateTime _addMonths(DateTime date, int months) {
    final totalMonths = date.month - 1 + months;
    final year = date.year + totalMonths ~/ 12;
    final month = totalMonths % 12 + 1;
    return _clampedDate(year, month, date.day);
  }

  /// [year]/[month]/[day] tarihini oluşturur; [month] 1-12 dışına taşarsa
  /// yıla yansıtılır, [day] o aydaki son güne sabitlenir (clamp).
  DateTime _clampedDate(int year, int month, int day) {
    final normalizedYear = year + (month - 1) ~/ 12;
    final normalizedMonth = (month - 1) % 12 + 1;
    final lastDayOfMonth =
        DateTime(normalizedYear, normalizedMonth + 1, 0).day;
    final clampedDay = day > lastDayOfMonth ? lastDayOfMonth : day;
    return DateTime(normalizedYear, normalizedMonth, clampedDay);
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
