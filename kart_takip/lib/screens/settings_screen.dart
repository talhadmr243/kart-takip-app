import 'package:flutter/material.dart';

import '../data/database.dart';
import '../services/export_service.dart';
import '../services/notification_service.dart';
import '../services/premium_service.dart';
import '../services/settings_service.dart';
import 'premium_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.database,
    required this.notificationService,
    required this.settingsService,
    required this.premiumService,
  });

  final AppDatabase database;
  final NotificationService notificationService;
  final SettingsService settingsService;
  final PremiumService premiumService;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _yedekleniyor = false;

  Future<void> _bildirimleriDegistir(bool acik) async {
    await widget.settingsService.setBildirimlerAcik(acik);
    if (acik) {
      await widget.notificationService.rescheduleAll(widget.database);
    } else {
      await widget.notificationService.cancelAll();
    }
  }

  Future<void> _verileriYedekle() async {
    setState(() => _yedekleniyor = true);
    try {
      await ExportService(widget.database).disaAktarVePaylas();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Yedekleme sırasında bir hata oluştu.')),
        );
      }
    } finally {
      if (mounted) setState(() => _yedekleniyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FutureBuilder<bool>(
            future: widget.notificationService.bildirimIzniVarMi(),
            builder: (context, snapshot) {
              final izinVar = snapshot.data ?? true;
              if (izinVar) return const SizedBox.shrink();
              final colorScheme = Theme.of(context).colorScheme;
              return Card(
                color: colorScheme.errorContainer,
                child: ListTile(
                  leading: Icon(
                    Icons.notifications_off_outlined,
                    color: colorScheme.onErrorContainer,
                  ),
                  title: Text(
                    'Bildirim izni kapalı',
                    style: TextStyle(color: colorScheme.onErrorContainer),
                  ),
                  subtitle: Text(
                    'Hatırlatmaların gelmesi için telefonun ayarlarından '
                    'Kart Takip uygulamasına bildirim izni ver.',
                    style: TextStyle(color: colorScheme.onErrorContainer),
                  ),
                ),
              );
            },
          ),
          Card(
            child: ValueListenableBuilder<bool>(
              valueListenable: widget.settingsService.bildirimlerAcik,
              builder: (context, acik, _) => SwitchListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                secondary: const Icon(Icons.notifications_outlined),
                title: const Text('Bildirimler'),
                subtitle: const Text(
                  'Kesim, aidat ve abonelik yenilenme hatırlatmaları',
                ),
                value: acik,
                onChanged: _bildirimleriDegistir,
              ),
            ),
          ),
          Card(
            child: ValueListenableBuilder<bool>(
              valueListenable: widget.premiumService.premiumAktif,
              builder: (context, premiumAktif, _) => ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: const Icon(Icons.workspace_premium_outlined),
                title: const Text('Premium'),
                subtitle: Text(
                  premiumAktif
                      ? 'Aktif — sınırsız kart ve abonelik'
                      : 'Ücretsiz sürüm — yükselt',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        PremiumScreen(premiumService: widget.premiumService),
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              leading: const Icon(Icons.backup_outlined),
              title: const Text('Verilerimi yedekle'),
              subtitle: const Text(
                'Tüm kart, abonelik ve ödeme kayıtlarını JSON olarak dışa aktar',
              ),
              trailing: _yedekleniyor
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.chevron_right),
              onTap: _yedekleniyor ? null : _verileriYedekle,
            ),
          ),
        ],
      ),
    );
  }
}
