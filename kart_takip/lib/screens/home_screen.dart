import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/database.dart';
import '../services/date_calculator_service.dart';
import '../services/notification_service.dart';
import 'add_card_screen.dart';
import 'add_subscription_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.database,
    required this.notificationService,
  });

  final AppDatabase database;
  final NotificationService notificationService;

  void _ekleMenusunuGoster(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Kart Ekle'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => AddCardScreen(
                      database: database,
                      notificationService: notificationService,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.subscriptions),
              title: const Text('Abonelik Ekle'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => AddSubscriptionScreen(
                      database: database,
                      notificationService: notificationService,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kart Takip')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _ekleMenusunuGoster(context),
        icon: const Icon(Icons.add),
        label: const Text('Ekle'),
      ),
      body: StreamBuilder<List<CardItem>>(
        stream: database.watchAllCards(),
        builder: (context, cardSnapshot) {
          final cards = cardSnapshot.data ?? const <CardItem>[];
          return StreamBuilder<List<Subscription>>(
            stream: database.watchAllSubscriptions(),
            builder: (context, subscriptionSnapshot) {
              final subscriptions =
                  subscriptionSnapshot.data ?? const <Subscription>[];
              return _HomeContent(cards: cards, subscriptions: subscriptions);
            },
          );
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  _HomeContent({required this.cards, required this.subscriptions});

  final List<CardItem> cards;
  final List<Subscription> subscriptions;
  final _dateCalculator = DateCalculatorService();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final upcomingKesimler =
        cards
            .map(
              (card) => (
                card: card,
                tarih: _dateCalculator.nextKesimTarihi(
                  card.kesimGunu,
                  from: now,
                ),
              ),
            )
            .toList()
          ..sort((a, b) => a.tarih.compareTo(b.tarih));

    final upcomingYenilenmeler =
        subscriptions
            .map(
              (sub) => (
                subscription: sub,
                tarih: _dateCalculator.nextYenilenmeTarihi(
                  baslangicTarihi: sub.baslangicTarihi,
                  periyot: sub.periyot,
                  from: now,
                ),
              ),
            )
            .toList()
          ..sort((a, b) => a.tarih.compareTo(b.tarih));

    // Kart veri modelinde gerçek harcama tutarı tutulmuyor (banka
    // senkronizasyonu yok), bu yüzden "bu ay çıkacak tutar" bu ay vadesi
    // gelen kart aidatları ile bu ay yenilenecek abonelik tutarlarının
    // toplamı olarak hesaplanır.
    final buAyKartAidatlari = cards.where(
      (card) =>
          card.aidatTarihi != null &&
          _isSameMonth(
            _dateCalculator.nextAidatTarihi(card.aidatTarihi!, from: now),
            now,
          ),
    );
    final buAyYenilenenler = upcomingYenilenmeler.where(
      (item) => _isSameMonth(item.tarih, now),
    );
    final buAyToplam =
        buAyKartAidatlari.fold<double>(
          0,
          (sum, card) => sum + card.aidatTutari,
        ) +
        buAyYenilenenler.fold<double>(
          0,
          (sum, item) => sum + item.subscription.tutar,
        );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SummaryCard(toplam: buAyToplam),
        const SizedBox(height: 24),
        const _SectionTitle('Yaklaşan Ekstreler'),
        if (upcomingKesimler.isEmpty)
          const _EmptyHint('Henüz kart eklenmedi.')
        else
          ...upcomingKesimler.map(
            (item) => _KesimTile(card: item.card, tarih: item.tarih),
          ),
        const SizedBox(height: 24),
        const _SectionTitle('Yaklaşan Abonelikler'),
        if (upcomingYenilenmeler.isEmpty)
          const _EmptyHint('Henüz abonelik eklenmedi.')
        else
          ...upcomingYenilenmeler.map(
            (item) => _YenilenmeTile(
              subscription: item.subscription,
              tarih: item.tarih,
            ),
          ),
      ],
    );
  }

  bool _isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.toplam});

  final double toplam;

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bu Ay Toplam', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              format.format(toplam),
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outline),
      ),
    );
  }
}

class _KesimTile extends StatelessWidget {
  const _KesimTile({required this.card, required this.tarih});

  final CardItem card;
  final DateTime tarih;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final kalanGun = tarih
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.credit_card),
        title: Text(card.bankaAdi),
        subtitle: Text(DateFormat('d MMMM y', 'tr_TR').format(tarih)),
        trailing: Text(
          kalanGun == 0 ? 'Bugün' : '$kalanGun gün',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}

class _YenilenmeTile extends StatelessWidget {
  const _YenilenmeTile({required this.subscription, required this.tarih});

  final Subscription subscription;
  final DateTime tarih;

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');
    return Card(
      child: ListTile(
        leading: const Icon(Icons.subscriptions),
        title: Text(subscription.hizmetAdi),
        subtitle: Text(DateFormat('d MMMM y', 'tr_TR').format(tarih)),
        trailing: Text(format.format(subscription.tutar)),
      ),
    );
  }
}
