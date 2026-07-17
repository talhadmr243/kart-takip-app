import 'package:flutter/material.dart';

import '../data/database.dart';
import '../data/popular_subscriptions.dart';
import '../services/notification_service.dart';

class AddSubscriptionScreen extends StatefulWidget {
  const AddSubscriptionScreen({
    super.key,
    required this.database,
    required this.notificationService,
  });

  final AppDatabase database;
  final NotificationService notificationService;

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hizmetAdiController = TextEditingController();
  final _tutarController = TextEditingController();
  DateTime _baslangicTarihi = DateTime.now();
  SubscriptionPeriod _periyot = SubscriptionPeriod.aylik;
  int? _seciliKartId;
  bool _manuelGiris = false;
  bool _kaydediliyor = false;

  @override
  void dispose() {
    _hizmetAdiController.dispose();
    _tutarController.dispose();
    super.dispose();
  }

  Future<void> _baslangicTarihiSec() async {
    final now = DateTime.now();
    final secilen = await showDatePicker(
      context: context,
      initialDate: _baslangicTarihi,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (secilen != null) {
      setState(() => _baslangicTarihi = secilen);
    }
  }

  Future<void> _kaydet() async {
    if (!_formKey.currentState!.validate() || _seciliKartId == null) return;
    setState(() => _kaydediliyor = true);
    try {
      final hizmetAdi = _hizmetAdiController.text.trim();
      final tutar = double.parse(_tutarController.text.replaceAll(',', '.'));
      final id = await widget.database.insertSubscription(
        SubscriptionsCompanion.insert(
          hizmetAdi: hizmetAdi,
          tutar: tutar,
          bagliKartId: _seciliKartId!,
          baslangicTarihi: _baslangicTarihi,
          periyot: _periyot,
        ),
      );
      await widget.notificationService.scheduleForSubscription(
        widget.database,
        Subscription(
          id: id,
          hizmetAdi: hizmetAdi,
          tutar: tutar,
          bagliKartId: _seciliKartId!,
          baslangicTarihi: _baslangicTarihi,
          periyot: _periyot,
        ),
      );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _kaydediliyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Abonelik Ekle')),
      body: StreamBuilder<List<CardItem>>(
        stream: widget.database.watchAllCards(),
        builder: (context, snapshot) {
          final cards = snapshot.data ?? const <CardItem>[];
          if (cards.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Abonelik ekleyebilmek için önce bir kart eklemelisiniz.',
              ),
            );
          }
          _seciliKartId ??= cards.first.id;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (!_manuelGiris)
                  DropdownButtonFormField<String>(
                    value: _hizmetAdiController.text.isEmpty
                        ? null
                        : _hizmetAdiController.text,
                    decoration: const InputDecoration(labelText: 'Hizmet'),
                    items: popularSubscriptionServices
                        .map(
                          (hizmet) => DropdownMenuItem(
                            value: hizmet,
                            child: Text(hizmet),
                          ),
                        )
                        .toList(),
                    validator: (value) =>
                        (value == null || value.isEmpty)
                            ? 'Zorunlu alan'
                            : null,
                    onChanged: (value) =>
                        setState(() => _hizmetAdiController.text = value ?? ''),
                  )
                else
                  TextFormField(
                    controller: _hizmetAdiController,
                    decoration: const InputDecoration(labelText: 'Hizmet Adı'),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Zorunlu alan'
                            : null,
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => setState(() {
                      _manuelGiris = !_manuelGiris;
                      _hizmetAdiController.clear();
                    }),
                    child: Text(
                      _manuelGiris
                          ? 'Listeden seç'
                          : 'Listede yok, elle gireceğim',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _tutarController,
                  decoration: const InputDecoration(labelText: 'Tutar (₺)'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Zorunlu alan';
                    }
                    if (double.tryParse(value.replaceAll(',', '.')) == null) {
                      return 'Geçerli bir sayı girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _seciliKartId,
                  decoration: const InputDecoration(labelText: 'Bağlı Kart'),
                  items: cards
                      .map(
                        (card) => DropdownMenuItem(
                          value: card.id,
                          child: Text(card.bankaAdi),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _seciliKartId = value),
                ),
                const SizedBox(height: 16),
                SegmentedButton<SubscriptionPeriod>(
                  segments: const [
                    ButtonSegment(
                      value: SubscriptionPeriod.aylik,
                      label: Text('Aylık'),
                    ),
                    ButtonSegment(
                      value: SubscriptionPeriod.yillik,
                      label: Text('Yıllık'),
                    ),
                  ],
                  selected: {_periyot},
                  onSelectionChanged: (secilenler) =>
                      setState(() => _periyot = secilenler.first),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Başlangıç Tarihi'),
                  subtitle: Text(
                    '${_baslangicTarihi.day}.${_baslangicTarihi.month}.${_baslangicTarihi.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _baslangicTarihiSec,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _kaydediliyor ? null : _kaydet,
                  child: _kaydediliyor
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Kaydet'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
