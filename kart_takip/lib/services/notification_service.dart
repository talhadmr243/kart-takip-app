import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../data/database.dart';
import 'date_calculator_service.dart';

/// Kart kesim/aidat ve abonelik yenilenme tarihleri için yerel bildirim
/// zamanlar. Bildirim ofsetleri: kesim -3 gün, yenilenme -1 gün, aidat -7 gün.
class NotificationService {
  NotificationService({
    FlutterLocalNotificationsPlugin? plugin,
    DateCalculatorService? dateCalculator,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
       _dateCalculator = dateCalculator ?? DateCalculatorService();

  final FlutterLocalNotificationsPlugin _plugin;
  final DateCalculatorService _dateCalculator;

  static const _kesimGunOnce = 3;
  static const _yenilenmeGunOnce = 1;
  static const _aidatGunOnce = 7;

  static const _reminderChannel = AndroidNotificationDetails(
    'kart_takip_reminders',
    'Kart ve Abonelik Hatırlatmaları',
    channelDescription:
        'Kart ekstre kesimi, kart aidatı ve abonelik yenilenmesi hatırlatmaları',
    importance: Importance.high,
    priority: Priority.high,
  );

  /// Bildirim eklentisini ve saat dilimini başlatır, izin ister.
  /// Türkiye pazarına özel bir uygulama olduğundan saat dilimi sabit olarak
  /// Europe/Istanbul kullanılır.
  Future<void> init() async {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Sistem tarafında bildirim izninin verilip verilmediğini sorgular.
  /// Platform desteklenmiyorsa (örn. testler) izin var kabul edilir.
  Future<bool> bildirimIzniVarMi() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.areNotificationsEnabled() ?? true;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      final options = await ios.checkPermissions();
      return options?.isEnabled ?? true;
    }
    return true;
  }

  /// Uygulama açılışında tüm kartlar ve abonelikler için bildirimleri
  /// güncel tarihlere göre yeniden zamanlar.
  Future<void> rescheduleAll(AppDatabase database) async {
    final cards = await database.getAllCards();
    for (final card in cards) {
      await scheduleForCard(database, card);
    }
    final subscriptions = await database.getAllSubscriptions();
    for (final subscription in subscriptions) {
      await scheduleForSubscription(database, subscription);
    }
  }

  Future<void> scheduleForCard(AppDatabase database, CardItem card) async {
    final now = DateTime.now();

    final kesimTarihi = _dateCalculator.nextKesimTarihi(
      card.kesimGunu,
      from: now,
    );
    final kesimBildirimTarihi = kesimTarihi.subtract(
      const Duration(days: _kesimGunOnce),
    );
    await database.deleteNotificationsFor(card.id, NotificationType.kesim);
    final kesimPlanlandi = await _scheduleIfFuture(
      id: _kesimNotificationId(card.id),
      title: 'Ekstre Kesim Tarihi Yaklaşıyor',
      body:
          '${card.bankaAdi} kartınızın ekstresi $_kesimGunOnce gün içinde kesilecek.',
      tetiklenmeTarihi: kesimBildirimTarihi,
    );
    if (kesimPlanlandi) {
      await database.insertNotification(
        NotificationsCompanion.insert(
          tip: NotificationType.kesim,
          tetiklenmeTarihi: kesimBildirimTarihi,
          ilgiliId: card.id,
        ),
      );
    }

    await database.deleteNotificationsFor(card.id, NotificationType.aidat);
    final aidatTarihiKaynagi = card.aidatTarihi;
    if (aidatTarihiKaynagi != null) {
      final aidatTarihi = _dateCalculator.nextAidatTarihi(
        aidatTarihiKaynagi,
        from: now,
      );
      final aidatBildirimTarihi = aidatTarihi.subtract(
        const Duration(days: _aidatGunOnce),
      );
      final aidatPlanlandi = await _scheduleIfFuture(
        id: _aidatNotificationId(card.id),
        title: 'Kart Aidatı Yaklaşıyor',
        body:
            '${card.bankaAdi} kartınızın yıllık aidatı $_aidatGunOnce gün içinde tahsil edilecek.',
        tetiklenmeTarihi: aidatBildirimTarihi,
      );
      if (aidatPlanlandi) {
        await database.insertNotification(
          NotificationsCompanion.insert(
            tip: NotificationType.aidat,
            tetiklenmeTarihi: aidatBildirimTarihi,
            ilgiliId: card.id,
          ),
        );
      }
    } else {
      await _plugin.cancel(_aidatNotificationId(card.id));
    }
  }

  Future<void> scheduleForSubscription(
    AppDatabase database,
    Subscription subscription,
  ) async {
    final now = DateTime.now();
    final yenilenmeTarihi = _dateCalculator.nextYenilenmeTarihi(
      baslangicTarihi: subscription.baslangicTarihi,
      periyot: subscription.periyot,
      from: now,
    );
    final bildirimTarihi = yenilenmeTarihi.subtract(
      const Duration(days: _yenilenmeGunOnce),
    );

    await database.deleteNotificationsFor(
      subscription.id,
      NotificationType.yenilenme,
    );
    final planlandi = await _scheduleIfFuture(
      id: _yenilenmeNotificationId(subscription.id),
      title: 'Abonelik Yenilenmesi Yaklaşıyor',
      body:
          '${subscription.hizmetAdi} aboneliğiniz $_yenilenmeGunOnce gün içinde yenilenecek.',
      tetiklenmeTarihi: bildirimTarihi,
    );
    if (planlandi) {
      await database.insertNotification(
        NotificationsCompanion.insert(
          tip: NotificationType.yenilenme,
          tetiklenmeTarihi: bildirimTarihi,
          ilgiliId: subscription.id,
        ),
      );
    }
  }

  /// Zamanlanmış tüm bildirimleri iptal eder (ayarlardan kapatıldığında).
  Future<void> cancelAll() => _plugin.cancelAll();

  Future<void> cancelForCard(int cardId) async {
    await _plugin.cancel(_kesimNotificationId(cardId));
    await _plugin.cancel(_aidatNotificationId(cardId));
  }

  Future<void> cancelForSubscription(int subscriptionId) async {
    await _plugin.cancel(_yenilenmeNotificationId(subscriptionId));
  }

  /// Bildirim tarihi geçmişte kalmadıysa zamanlar; [true] planlandığını
  /// belirtir.
  Future<bool> _scheduleIfFuture({
    required int id,
    required String title,
    required String body,
    required DateTime tetiklenmeTarihi,
  }) async {
    await _plugin.cancel(id);
    if (!tetiklenmeTarihi.isAfter(DateTime.now())) {
      return false;
    }
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(tetiklenmeTarihi, tz.local),
      const NotificationDetails(android: _reminderChannel, iOS: DarwinNotificationDetails()),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    return true;
  }

  int _kesimNotificationId(int cardId) => cardId * 3 + 1;
  int _aidatNotificationId(int cardId) => cardId * 3 + 2;
  int _yenilenmeNotificationId(int subscriptionId) => 1000000 + subscriptionId;
}
