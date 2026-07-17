import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'data/database.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR');

  final database = AppDatabase();
  final notificationService = NotificationService();
  await notificationService.init();
  unawaited(notificationService.rescheduleAll(database));

  runApp(
    KartTakipApp(database: database, notificationService: notificationService),
  );
}

class KartTakipApp extends StatelessWidget {
  const KartTakipApp({
    super.key,
    required this.database,
    required this.notificationService,
  });

  final AppDatabase database;
  final NotificationService notificationService;

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
      ),
    );
  }
}
