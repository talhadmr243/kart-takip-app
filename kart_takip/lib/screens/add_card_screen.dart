import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../data/database.dart';
import '../services/notification_service.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({
    super.key,
    required this.database,
    required this.notificationService,
  });

  final AppDatabase database;
  final NotificationService notificationService;

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankaAdiController = TextEditingController();
  final _kesimGunuController = TextEditingController();
  final _sonOdemeGunuController = TextEditingController();
  final _limitController = TextEditingController();
  final _aidatTutariController = TextEditingController(text: '0');
  DateTime? _aidatTarihi;
  bool _kaydediliyor = false;

  @override
  void dispose() {
    _bankaAdiController.dispose();
    _kesimGunuController.dispose();
    _sonOdemeGunuController.dispose();
    _limitController.dispose();
    _aidatTutariController.dispose();
    super.dispose();
  }

  Future<void> _aidatTarihiSec() async {
    final now = DateTime.now();
    final secilen = await showDatePicker(
      context: context,
      initialDate: _aidatTarihi ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (secilen != null) {
      setState(() => _aidatTarihi = secilen);
    }
  }

  Future<void> _kaydet() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _kaydediliyor = true);
    try {
      final aidatTutari =
          double.tryParse(_aidatTutariController.text.replaceAll(',', '.')) ??
          0;
      final id = await widget.database.insertCard(
        CardsCompanion.insert(
          bankaAdi: _bankaAdiController.text.trim(),
          kesimGunu: int.parse(_kesimGunuController.text),
          sonOdemeGunu: int.parse(_sonOdemeGunuController.text),
          limit: double.parse(_limitController.text.replaceAll(',', '.')),
          aidatTutari: Value(aidatTutari),
          aidatTarihi: Value(_aidatTarihi),
        ),
      );
      await widget.notificationService.scheduleForCard(
        widget.database,
        CardItem(
          id: id,
          bankaAdi: _bankaAdiController.text.trim(),
          kesimGunu: int.parse(_kesimGunuController.text),
          sonOdemeGunu: int.parse(_sonOdemeGunuController.text),
          limit: double.parse(_limitController.text.replaceAll(',', '.')),
          aidatTutari: aidatTutari,
          aidatTarihi: _aidatTarihi,
        ),
      );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _kaydediliyor = false);
    }
  }

  String? _gunValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Zorunlu alan';
    final gun = int.tryParse(value);
    if (gun == null || gun < 1 || gun > 31) return '1-31 arası bir gün girin';
    return null;
  }

  String? _tutarValidator(String? value, {bool zorunlu = true}) {
    if (value == null || value.trim().isEmpty) {
      return zorunlu ? 'Zorunlu alan' : null;
    }
    if (double.tryParse(value.replaceAll(',', '.')) == null) {
      return 'Geçerli bir sayı girin';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kart Ekle')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _bankaAdiController,
              decoration: const InputDecoration(labelText: 'Banka Adı'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Zorunlu alan'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _kesimGunuController,
              decoration: const InputDecoration(
                labelText: 'Kesim Günü (1-31)',
              ),
              keyboardType: TextInputType.number,
              validator: _gunValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _sonOdemeGunuController,
              decoration: const InputDecoration(
                labelText: 'Son Ödeme Günü (1-31)',
              ),
              keyboardType: TextInputType.number,
              validator: _gunValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _limitController,
              decoration: const InputDecoration(labelText: 'Kart Limiti (₺)'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _tutarValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _aidatTutariController,
              decoration: const InputDecoration(
                labelText: 'Yıllık Aidat Tutarı (₺)',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) => _tutarValidator(value, zorunlu: false),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Aidat Tarihi'),
              subtitle: Text(
                _aidatTarihi == null
                    ? 'Seçilmedi (opsiyonel)'
                    : '${_aidatTarihi!.day}.${_aidatTarihi!.month}.${_aidatTarihi!.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _aidatTarihiSec,
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
      ),
    );
  }
}
