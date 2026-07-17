import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/database.dart';
import '../services/date_calculator_service.dart';
import '../services/notification_service.dart';
import '../services/settings_service.dart';
import '../theme/app_theme.dart';
import 'add_card_screen.dart';
import 'add_subscription_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.database,
    required this.notificationService,
    required this.settingsService,
  });

  final AppDatabase database;
  final NotificationService notificationService;
  final SettingsService settingsService;

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
                      settingsService: settingsService,
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
                      settingsService: settingsService,
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
      appBar: AppBar(
        title: const Text('Kart Takip'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Ayarlar',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => SettingsScreen(
                  database: database,
                  notificationService: notificationService,
                  settingsService: settingsService,
                ),
              ),
            ),
          ),
        ],
      ),
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
              return _HomeContent(
                cards: cards,
                subscriptions: subscriptions,
                onEditCard: (card) => _kartDuzenle(context, card),
                onDeleteCard: _kartSil,
                onEditSubscription: (subscription) =>
                    _abonelikDuzenle(context, subscription),
                onDeleteSubscription: _abonelikSil,
              );
            },
          );
        },
      ),
    );
  }

  void _kartDuzenle(BuildContext context, CardItem card) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddCardScreen(
          database: database,
          notificationService: notificationService,
          settingsService: settingsService,
          existing: card,
        ),
      ),
    );
  }

  Future<void> _kartSil(CardItem card) async {
    // Karta bağlı abonelikler cascade ile silineceği için önce onların
    // zamanlanmış bildirimleri iptal edilir.
    final bagliAbonelikler = await database.getSubscriptionsForCard(card.id);
    for (final abonelik in bagliAbonelikler) {
      await notificationService.cancelForSubscription(abonelik.id);
      await database.deleteNotificationsFor(
        abonelik.id,
        NotificationType.yenilenme,
      );
    }
    await notificationService.cancelForCard(card.id);
    await database.deleteNotificationsFor(card.id, NotificationType.kesim);
    await database.deleteNotificationsFor(card.id, NotificationType.aidat);
    await database.deleteCard(card.id);
  }

  void _abonelikDuzenle(BuildContext context, Subscription subscription) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddSubscriptionScreen(
          database: database,
          notificationService: notificationService,
          settingsService: settingsService,
          existing: subscription,
        ),
      ),
    );
  }

  Future<void> _abonelikSil(Subscription subscription) async {
    await notificationService.cancelForSubscription(subscription.id);
    await database.deleteNotificationsFor(
      subscription.id,
      NotificationType.yenilenme,
    );
    await database.deleteSubscription(subscription.id);
  }
}

class _HomeContent extends StatelessWidget {
  _HomeContent({
    required this.cards,
    required this.subscriptions,
    required this.onEditCard,
    required this.onDeleteCard,
    required this.onEditSubscription,
    required this.onDeleteSubscription,
  });

  final List<CardItem> cards;
  final List<Subscription> subscriptions;
  final void Function(CardItem) onEditCard;
  final Future<void> Function(CardItem) onDeleteCard;
  final void Function(Subscription) onEditSubscription;
  final Future<void> Function(Subscription) onDeleteSubscription;
  final _dateCalculator = DateCalculatorService();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    if (cards.isEmpty && subscriptions.isEmpty) {
      return const _EmptyState();
    }

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

    final Widget ozetGorunumu;
    if (upcomingKesimler.isEmpty) {
      ozetGorunumu = _ToplamKarti(toplam: buAyToplam);
    } else {
      final sonrakiKesim = upcomingKesimler.first;
      final kalanGun = sonrakiKesim.tarih
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;
      // Döngü uzunluğu için bir önceki kesim tarihi bulunur: sonraki
      // kesimden 40 gün geriden bakınca aradaki tek kesim, önceki
      // döngünün kesimidir.
      final oncekiKesim = _dateCalculator.nextKesimTarihi(
        sonrakiKesim.card.kesimGunu,
        from: sonrakiKesim.tarih.subtract(const Duration(days: 40)),
      );
      final donguGun = sonrakiKesim.tarih.difference(oncekiKesim).inDays;
      final oran = donguGun <= 0
          ? 0.0
          : ((donguGun - kalanGun) / donguGun).clamp(0.0, 1.0);
      ozetGorunumu = _KesimHalkasi(
        toplam: buAyToplam,
        kalanGun: kalanGun,
        oran: oran,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ozetGorunumu,
        const SizedBox(height: 24),
        const _SectionTitle('Yaklaşan Ekstreler'),
        if (upcomingKesimler.isEmpty)
          const _EmptyHint('Henüz kart eklenmedi. "Ekle" ile ilk kartını ekle.')
        else
          ...upcomingKesimler.map(
            (item) => _DismissibleRow(
              dismissKey: ValueKey('card_${item.card.id}'),
              itemName: '${item.card.bankaAdi} kartı',
              onDelete: () => onDeleteCard(item.card),
              child: _KesimTile(
                card: item.card,
                tarih: item.tarih,
                onTap: () => onEditCard(item.card),
              ),
            ),
          ),
        const SizedBox(height: 24),
        const _SectionTitle('Yaklaşan Abonelikler'),
        if (upcomingYenilenmeler.isEmpty)
          const _EmptyHint(
            'Henüz abonelik eklenmedi. "Ekle" ile ilk aboneliğini ekle.',
          )
        else
          ...upcomingYenilenmeler.map(
            (item) => _DismissibleRow(
              dismissKey: ValueKey('subscription_${item.subscription.id}'),
              itemName: '${item.subscription.hizmetAdi} aboneliği',
              onDelete: () => onDeleteSubscription(item.subscription),
              child: _YenilenmeTile(
                subscription: item.subscription,
                tarih: item.tarih,
                onTap: () => onEditSubscription(item.subscription),
              ),
            ),
          ),
      ],
    );
  }

  bool _isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.08),
              ),
              child: Icon(
                Icons.credit_card_off_outlined,
                size: 56,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Henüz kart veya abonelik eklenmedi',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Kartlarını ve aboneliklerini ekleyerek bu ay '
              'kartından ne kadar çıkacağını tek bakışta gör. '
              'Başlamak için aşağıdaki "Ekle" butonuna dokun.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// İmza öğesi: bir sonraki ekstre kesimine kalan süreyi gösteren dairesel
/// ilerleme halkası. Halkanın dolu kısmı döngüde geçen süre oranıdır;
/// ortada bu ayın toplamı (mono font), altında kalan gün yazar.
class _KesimHalkasi extends StatelessWidget {
  const _KesimHalkasi({
    required this.toplam,
    required this.kalanGun,
    required this.oran,
  });

  final double toplam;
  final int kalanGun;
  final double oran;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final halkaRengi = kalanGun <= 3 ? colorScheme.error : colorScheme.primary;
    final format = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');
    return Center(
      child: SizedBox(
        width: 240,
        height: 240,
        child: CustomPaint(
          painter: _HalkaPainter(
            oran: oran,
            renk: halkaRengi,
            izRengi: colorScheme.primary.withValues(alpha: 0.12),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bu Ay Toplam',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  format.format(toplam),
                  style: AppTheme.para(
                    context,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  kalanGun == 0 ? 'kesim bugün' : 'kesime $kalanGun gün',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: kalanGun <= 3
                        ? colorScheme.error
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HalkaPainter extends CustomPainter {
  const _HalkaPainter({
    required this.oran,
    required this.renk,
    required this.izRengi,
  });

  final double oran;
  final Color renk;
  final Color izRengi;

  @override
  void paint(Canvas canvas, Size size) {
    const kalinlik = 12.0;
    final merkez = size.center(Offset.zero);
    final yaricap = (size.shortestSide - kalinlik) / 2;

    final iz = Paint()
      ..color = izRengi
      ..style = PaintingStyle.stroke
      ..strokeWidth = kalinlik;
    canvas.drawCircle(merkez, yaricap, iz);

    final yay = Paint()
      ..color = renk
      ..style = PaintingStyle.stroke
      ..strokeWidth = kalinlik
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: merkez, radius: yaricap),
      -math.pi / 2,
      2 * math.pi * oran,
      false,
      yay,
    );
  }

  @override
  bool shouldRepaint(_HalkaPainter oldDelegate) =>
      oldDelegate.oran != oran ||
      oldDelegate.renk != renk ||
      oldDelegate.izRengi != izRengi;
}

/// Hiç kart yokken (yalnızca abonelik varken) halka yerine gösterilen
/// düz toplam kartı.
class _ToplamKarti extends StatelessWidget {
  const _ToplamKarti({required this.toplam});

  final double toplam;

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bu Ay Toplam', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              format.format(toplam),
              style: AppTheme.para(
                context,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
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

/// Liste satırını kaydırarak silme davranışıyla sarar; silmeden önce
/// onay diyaloğu gösterir.
class _DismissibleRow extends StatelessWidget {
  const _DismissibleRow({
    required this.dismissKey,
    required this.itemName,
    required this.onDelete,
    required this.child,
  });

  final Key dismissKey;
  final String itemName;
  final Future<void> Function() onDelete;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: dismissKey,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.delete_outline,
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Silinsin mi?'),
          content: Text('$itemName silinecek. Bu işlem geri alınamaz.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Sil'),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: child,
    );
  }
}

class _KesimTile extends StatelessWidget {
  const _KesimTile({required this.card, required this.tarih, this.onTap});

  final CardItem card;
  final DateTime tarih;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final kalanGun = tarih
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.credit_card_outlined),
        title: Text(card.bankaAdi),
        subtitle: Text(DateFormat('d MMMM y', 'tr_TR').format(tarih)),
        trailing: Text(
          kalanGun == 0 ? 'Bugün' : '$kalanGun gün',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: kalanGun <= 3 ? colorScheme.error : colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _YenilenmeTile extends StatelessWidget {
  const _YenilenmeTile({
    required this.subscription,
    required this.tarih,
    this.onTap,
  });

  final Subscription subscription;
  final DateTime tarih;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.autorenew),
        title: Text(subscription.hizmetAdi),
        subtitle: Text(DateFormat('d MMMM y', 'tr_TR').format(tarih)),
        trailing: Text(
          format.format(subscription.tutar),
          style: AppTheme.para(context, fontSize: 14),
        ),
      ),
    );
  }
}
