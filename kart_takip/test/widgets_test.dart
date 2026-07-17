import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kart_takip/data/database.dart';
import 'package:kart_takip/main.dart';
import 'package:kart_takip/screens/add_card_screen.dart';
import 'package:kart_takip/screens/add_subscription_screen.dart';
import 'package:kart_takip/services/notification_service.dart';
import 'package:kart_takip/services/settings_service.dart';

Future<void> main() async {
  await initializeDateFormatting('tr_TR');

  late AppDatabase database;
  late SettingsService settingsService;
  final notificationService = NotificationService();

  setUp(() async {
    database = AppDatabase.withExecutor(NativeDatabase.memory());
    // Test ortamında platform kanalı olmadığından bildirim zamanlaması
    // kapalı tutulur.
    SharedPreferences.setMockInitialValues({'bildirimler_acik': false});
    settingsService = await SettingsService.load();
  });

  tearDown(() async {
    await database.close();
  });

  Future<CardItem> kartEkle({String bankaAdi = 'Test Bankası'}) async {
    final id = await database.insertCard(
      CardsCompanion.insert(
        bankaAdi: bankaAdi,
        kesimGunu: 15,
        sonOdemeGunu: 25,
        limit: 10000,
        aidatTutari: const Value(0),
      ),
    );
    return (await database.getAllCards()).firstWhere((card) => card.id == id);
  }

  group('Ana ekran', () {
    testWidgets('boş durumda yönlendirici mesaj görünür', (tester) async {
      await tester.pumpWidget(
        KartTakipApp(
          database: database,
          notificationService: notificationService,
          settingsService: settingsService,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Kart Takip'), findsOneWidget);
      expect(find.text('Henüz kart veya abonelik eklenmedi'), findsOneWidget);
      expect(find.text('Ekle'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('kart varken özet kartı ve ekstre listesi görünür', (
      tester,
    ) async {
      await kartEkle(bankaAdi: 'Garanti');

      await tester.pumpWidget(
        KartTakipApp(
          database: database,
          notificationService: notificationService,
          settingsService: settingsService,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bu Ay Toplam'), findsOneWidget);
      expect(find.text('Yaklaşan Ekstreler'), findsOneWidget);
      expect(find.text('Garanti'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });

  group('Kart ekleme ekranı', () {
    Widget ekran() => MaterialApp(
      home: AddCardScreen(
        database: database,
        notificationService: notificationService,
        settingsService: settingsService,
      ),
    );

    testWidgets('boş form kaydedilmeye çalışılınca hata mesajları görünür', (
      tester,
    ) async {
      await tester.pumpWidget(ekran());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      expect(find.text('Banka adı boş bırakılamaz'), findsOneWidget);
      expect(find.text('Bu alan boş bırakılamaz'), findsWidgets);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('geçerli form kaydedilince kart veritabanına yazılır', (
      tester,
    ) async {
      await tester.pumpWidget(ekran());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Banka Adı'),
        'İş Bankası',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Kesim Günü (1-31)'),
        '18',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Son Ödeme Günü (1-31)'),
        '28',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Kart Limiti (₺)'),
        '45000',
      );
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      final cards = await database.getAllCards();
      expect(cards, hasLength(1));
      expect(cards.single.bankaAdi, 'İş Bankası');
      expect(cards.single.kesimGunu, 18);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('geçersiz gün değeri hata mesajı üretir', (tester) async {
      await tester.pumpWidget(ekran());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Kesim Günü (1-31)'),
        '45',
      );
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      expect(find.text('Gün 1 ile 31 arasında olmalı'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });

  group('Abonelik ekleme ekranı', () {
    Widget ekran() => MaterialApp(
      home: AddSubscriptionScreen(
        database: database,
        notificationService: notificationService,
        settingsService: settingsService,
      ),
    );

    testWidgets('hiç kart yokken yönlendirme mesajı görünür', (tester) async {
      await tester.pumpWidget(ekran());
      await tester.pumpAndSettle();

      expect(
        find.text('Abonelik ekleyebilmek için önce bir kart eklemelisiniz.'),
        findsOneWidget,
      );

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('manuel girişle abonelik veritabanına yazılır', (tester) async {
      final card = await kartEkle();

      await tester.pumpWidget(ekran());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Listede yok, elle gireceğim'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Hizmet Adı'),
        'Yerel Spor Salonu',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Tutar (₺)'),
        '350',
      );
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      final subscriptions = await database.getAllSubscriptions();
      expect(subscriptions, hasLength(1));
      expect(subscriptions.single.hizmetAdi, 'Yerel Spor Salonu');
      expect(subscriptions.single.bagliKartId, card.id);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}
