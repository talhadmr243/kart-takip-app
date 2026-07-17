import 'package:flutter_test/flutter_test.dart';
import 'package:kart_takip/data/database.dart';
import 'package:kart_takip/services/date_calculator_service.dart';

void main() {
  final service = DateCalculatorService();

  group('nextKesimTarihi', () {
    test('bu ay içinde henüz gelmemiş kesim gününü döndürür', () {
      final result = service.nextKesimTarihi(
        15,
        from: DateTime(2026, 7, 10),
      );
      expect(result, DateTime(2026, 7, 15));
    });

    test('bugün kesim günüyse bugünü döndürür (dahil)', () {
      final result = service.nextKesimTarihi(
        15,
        from: DateTime(2026, 7, 15),
      );
      expect(result, DateTime(2026, 7, 15));
    });

    test('kesim günü geçtiyse bir sonraki ayı döndürür', () {
      final result = service.nextKesimTarihi(
        15,
        from: DateTime(2026, 7, 16),
      );
      expect(result, DateTime(2026, 8, 15));
    });

    test('yıl sonunda bir sonraki yıla taşar', () {
      final result = service.nextKesimTarihi(
        1,
        from: DateTime(2026, 12, 31),
      );
      expect(result, DateTime(2027, 1, 1));
    });

    test('31 gibi büyük bir gün, kısa aylarda ay sonuna sabitlenir', () {
      final result = service.nextKesimTarihi(
        31,
        from: DateTime(2026, 2, 1),
      );
      expect(result, DateTime(2026, 2, 28));
    });

    test('31 gün 31 günlük bir ayda olduğu gibi kalır', () {
      final result = service.nextKesimTarihi(
        31,
        from: DateTime(2026, 3, 1),
      );
      expect(result, DateTime(2026, 3, 31));
    });
  });

  group('nextAidatTarihi', () {
    test('bu yıl içinde henüz gelmemiş aidat tarihini döndürür', () {
      final result = service.nextAidatTarihi(
        DateTime(2020, 3, 10),
        from: DateTime(2026, 1, 1),
      );
      expect(result, DateTime(2026, 3, 10));
    });

    test('bugün aidat tarihiyse bugünü döndürür (dahil)', () {
      final result = service.nextAidatTarihi(
        DateTime(2020, 3, 10),
        from: DateTime(2026, 3, 10),
      );
      expect(result, DateTime(2026, 3, 10));
    });

    test('aidat tarihi geçtiyse bir sonraki yılı döndürür', () {
      final result = service.nextAidatTarihi(
        DateTime(2020, 3, 10),
        from: DateTime(2026, 3, 11),
      );
      expect(result, DateTime(2027, 3, 10));
    });

    test('29 Şubat gibi artık yıl tarihi, artık olmayan yılda 28\'e sabitlenir', () {
      final result = service.nextAidatTarihi(
        DateTime(2024, 2, 29),
        from: DateTime(2026, 1, 1),
      );
      expect(result, DateTime(2026, 2, 28));
    });
  });

  group('nextYenilenmeTarihi - aylık', () {
    test('bu ay içinde henüz gelmemiş yenilenme gününü döndürür', () {
      final result = service.nextYenilenmeTarihi(
        baslangicTarihi: DateTime(2026, 1, 15),
        periyot: SubscriptionPeriod.aylik,
        from: DateTime(2026, 7, 10),
      );
      expect(result, DateTime(2026, 7, 15));
    });

    test('bugün yenilenme günüyse bugünü döndürür (dahil)', () {
      final result = service.nextYenilenmeTarihi(
        baslangicTarihi: DateTime(2026, 1, 15),
        periyot: SubscriptionPeriod.aylik,
        from: DateTime(2026, 7, 15),
      );
      expect(result, DateTime(2026, 7, 15));
    });

    test('yenilenme günü geçtiyse bir sonraki ayı döndürür', () {
      final result = service.nextYenilenmeTarihi(
        baslangicTarihi: DateTime(2026, 1, 15),
        periyot: SubscriptionPeriod.aylik,
        from: DateTime(2026, 7, 16),
      );
      expect(result, DateTime(2026, 8, 15));
    });

    test('31 gibi büyük bir başlangıç günü kısa ayda ay sonuna sabitlenir', () {
      final result = service.nextYenilenmeTarihi(
        baslangicTarihi: DateTime(2026, 1, 31),
        periyot: SubscriptionPeriod.aylik,
        from: DateTime(2026, 2, 1),
      );
      expect(result, DateTime(2026, 2, 28));
    });

    test('başlangıç tarihi henüz gelmediyse başlangıç tarihini döndürür', () {
      final result = service.nextYenilenmeTarihi(
        baslangicTarihi: DateTime(2026, 12, 25),
        periyot: SubscriptionPeriod.aylik,
        from: DateTime(2026, 7, 16),
      );
      expect(result, DateTime(2026, 12, 25));
    });
  });

  group('nextYenilenmeTarihi - yıllık', () {
    test('bu yıl içinde henüz gelmemiş yenilenme gününü döndürür', () {
      final result = service.nextYenilenmeTarihi(
        baslangicTarihi: DateTime(2025, 6, 1),
        periyot: SubscriptionPeriod.yillik,
        from: DateTime(2026, 1, 10),
      );
      expect(result, DateTime(2026, 6, 1));
    });

    test('bugün yenilenme günüyse bugünü döndürür (dahil)', () {
      final result = service.nextYenilenmeTarihi(
        baslangicTarihi: DateTime(2025, 6, 1),
        periyot: SubscriptionPeriod.yillik,
        from: DateTime(2026, 6, 1),
      );
      expect(result, DateTime(2026, 6, 1));
    });

    test('yenilenme günü geçtiyse bir sonraki yılı döndürür', () {
      final result = service.nextYenilenmeTarihi(
        baslangicTarihi: DateTime(2025, 6, 1),
        periyot: SubscriptionPeriod.yillik,
        from: DateTime(2026, 7, 10),
      );
      expect(result, DateTime(2027, 6, 1));
    });
  });
}
