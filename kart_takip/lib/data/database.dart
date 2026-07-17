import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

enum SubscriptionPeriod { aylik, yillik }

enum NotificationType { kesim, yenilenme, aidat }

@DataClassName('CardItem')
class Cards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bankaAdi => text()();
  IntColumn get kesimGunu => integer()();
  IntColumn get sonOdemeGunu => integer()();
  RealColumn get limit => real()();
  RealColumn get aidatTutari => real().withDefault(const Constant(0))();
  DateTimeColumn get aidatTarihi => dateTime().nullable()();
}

class Subscriptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get hizmetAdi => text()();
  RealColumn get tutar => real()();
  IntColumn get bagliKartId =>
      integer().references(Cards, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get baslangicTarihi => dateTime()();
  TextColumn get periyot => textEnum<SubscriptionPeriod>()();
}

@DataClassName('NotificationItem')
class Notifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tip => textEnum<NotificationType>()();
  DateTimeColumn get tetiklenmeTarihi => dateTime()();
  IntColumn get ilgiliId => integer()();
  BoolColumn get gonderildiMi =>
      boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Cards, Subscriptions, Notifications])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.withExecutor(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      // Abonelikler karta cascade ile bağlı; SQLite'ta foreign key
      // desteği bağlantı başına açıkça etkinleştirilmek zorunda.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  // Cards
  Future<List<CardItem>> getAllCards() => select(cards).get();
  Stream<List<CardItem>> watchAllCards() => select(cards).watch();
  Future<int> insertCard(CardsCompanion card) => into(cards).insert(card);
  Future<bool> updateCard(CardItem card) => update(cards).replace(card);
  Future<int> deleteCard(int id) =>
      (delete(cards)..where((tbl) => tbl.id.equals(id))).go();

  // Subscriptions
  Future<List<Subscription>> getAllSubscriptions() =>
      select(subscriptions).get();
  Stream<List<Subscription>> watchAllSubscriptions() =>
      select(subscriptions).watch();
  Future<List<Subscription>> getSubscriptionsForCard(int cardId) =>
      (select(subscriptions)..where((tbl) => tbl.bagliKartId.equals(cardId)))
          .get();
  Future<int> insertSubscription(SubscriptionsCompanion subscription) =>
      into(subscriptions).insert(subscription);
  Future<bool> updateSubscription(Subscription subscription) =>
      update(subscriptions).replace(subscription);
  Future<int> deleteSubscription(int id) =>
      (delete(subscriptions)..where((tbl) => tbl.id.equals(id))).go();

  // Notifications
  Future<List<NotificationItem>> getAllNotifications() =>
      select(notifications).get();
  Future<int> insertNotification(NotificationsCompanion notification) =>
      into(notifications).insert(notification);
  Future<int> markNotificationSent(int id) =>
      (update(notifications)..where((tbl) => tbl.id.equals(id))).write(
        const NotificationsCompanion(gonderildiMi: Value(true)),
      );
  Future<int> deleteNotificationsFor(int ilgiliId, NotificationType tip) =>
      (delete(notifications)..where(
            (tbl) => tbl.ilgiliId.equals(ilgiliId) & tbl.tip.equalsValue(tip),
          ))
          .go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'kart_takip.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
