import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'data/database.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR');

  final database = AppDatabase();
  final settingsService = await SettingsService.load();
  final notificationService = NotificationService();
  await notificationService.init();
  if (settingsService.bildirimlerAcikMi) {
    unawaited(notificationService.rescheduleAll(database));
  }

  runApp(
    KartTakipApp(
      database: database,
      notificationService: notificationService,
      settingsService: settingsService,
    ),
  );
}

class KartTakipApp extends StatelessWidget {
  const KartTakipApp({
    super.key,
    required this.database,
    required this.notificationService,
    required this.settingsService,
  });

  final AppDatabase database;
  final NotificationService notificationService;
  final SettingsService settingsService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kart Takip',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: HomeScreen(
        database: database,
        notificationService: notificationService,
        settingsService: settingsService,
      ),
    );
  }
}
