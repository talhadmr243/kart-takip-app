import 'package:flutter/material.dart';

import '../data/database.dart';
import '../services/notification_service.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.database,
    required this.notificationService,
    required this.settingsService,
  });

  final AppDatabase database;
  final NotificationService notificationService;
  final SettingsService settingsService;

  Future<void> _bildirimleriDegistir(bool acik) async {
    await settingsService.setBildirimlerAcik(acik);
    if (acik) {
      await notificationService.rescheduleAll(database);
    } else {
      await notificationService.cancelAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          FutureBuilder<bool>(
            future: notificationService.bildirimIzniVarMi(),
            builder: (context, snapshot) {
              final izinVar = snapshot.data ?? true;
              if (izinVar) return const SizedBox.shrink();
              final colorScheme = Theme.of(context).colorScheme;
              return Card(
                margin: const EdgeInsets.all(16),
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
          ValueListenableBuilder<bool>(
            valueListenable: settingsService.bildirimlerAcik,
            builder: (context, acik, _) => SwitchListTile(
              title: const Text('Bildirimler'),
              subtitle: const Text(
                'Kesim, aidat ve abonelik yenilenme hatırlatmaları',
              ),
              value: acik,
              onChanged: _bildirimleriDegistir,
            ),
          ),
        ],
      ),
    );
  }
}
