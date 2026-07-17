import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/database.dart';
import '../services/notification_service.dart';
import '../services/settings_service.dart';
import '../theme/app_theme.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({
    super.key,
    required this.database,
    required this.notificationService,
    required this.settingsService,
    this.existing,
  });

  final AppDatabase database;
  final NotificationService notificationService;
  final SettingsService settingsService;

  /// Doluysa ekran düzenleme modunda çalışır ve bu kaydı günceller.
  final CardItem? existing;

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _bankaAdiController = TextEditingController(
    text: widget.existing?.bankaAdi ?? '',
  );
  late final _kesimGunuController = TextEditingController(
    text: widget.existing?.kesimGunu.toString() ?? '',
  );
  late final _sonOdemeGunuController = TextEditingController(
    text: widget.existing?.sonOdemeGunu.toString() ?? '',
  );
  late final _limitController = TextEditingController(
    text: widget.existing == null
        ? ''
        : _formatTutar(widget.existing!.limit),
  );
  late final _aidatTutariController = TextEditingController(
    text: widget.existing == null
        ? '0'
        : _formatTutar(widget.existing!.aidatTutari),
  );
  late DateTime? _aidatTarihi = widget.existing?.aidatTarihi;
  bool _kaydediliyor = false;

  static String _formatTutar(double tutar) => tutar == tutar.roundToDouble()
      ? tutar.toStringAsFixed(0)
      : tutar.toString();

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
      final existing = widget.existing;
      final int id;
      if (existing == null) {
        id = await widget.database.insertCard(
          CardsCompanion.insert(
            bankaAdi: _bankaAdiController.text.trim(),
            kesimGunu: int.parse(_kesimGunuController.text),
            sonOdemeGunu: int.parse(_sonOdemeGunuController.text),
            limit: double.parse(_limitController.text.replaceAll(',', '.')),
            aidatTutari: Value(aidatTutari),
            aidatTarihi: Value(_aidatTarihi),
          ),
        );
      } else {
        id = existing.id;
      }
      final card = CardItem(
        id: id,
        bankaAdi: _bankaAdiController.text.trim(),
        kesimGunu: int.parse(_kesimGunuController.text),
        sonOdemeGunu: int.parse(_sonOdemeGunuController.text),
        limit: double.parse(_limitController.text.replaceAll(',', '.')),
        aidatTutari: aidatTutari,
        aidatTarihi: _aidatTarihi,
      );
      if (existing != null) {
        await widget.database.updateCard(card);
      }
      if (widget.settingsService.bildirimlerAcikMi) {
        await widget.notificationService.scheduleForCard(widget.database, card);
      }
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _kaydediliyor = false);
    }
  }

  String? _gunValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bu alan boş bırakılamaz';
    }
    final gun = int.tryParse(value.trim());
    if (gun == null) return 'Sayı girin (örn. 15)';
    if (gun < 1 || gun > 31) return 'Gün 1 ile 31 arasında olmalı';
    return null;
  }

  /// [sifirOlabilir] true ise 0 kabul edilir (örn. aidatsız kart),
  /// negatif tutar hiçbir durumda kabul edilmez.
  String? _tutarValidator(
    String? value, {
    bool zorunlu = true,
    bool sifirOlabilir = false,
  }) {
    if (value == null || value.trim().isEmpty) {
      return zorunlu ? 'Bu alan boş bırakılamaz' : null;
    }
    final tutar = double.tryParse(value.trim().replaceAll(',', '.'));
    if (tutar == null) return 'Geçerli bir tutar girin (örn. 149,99)';
    if (tutar < 0) return 'Tutar negatif olamaz';
    if (!sifirOlabilir && tutar == 0) return 'Tutar sıfırdan büyük olmalı';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Kart Ekle' : 'Kartı Düzenle'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _bankaAdiController,
              decoration: const InputDecoration(labelText: 'Banka Adı'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Banka adı boş bırakılamaz'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _kesimGunuController,
              decoration: const InputDecoration(
                labelText: 'Kesim Günü (1-31)',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _gunValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _sonOdemeGunuController,
              decoration: const InputDecoration(
                labelText: 'Son Ödeme Günü (1-31)',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _gunValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _limitController,
              decoration: const InputDecoration(labelText: 'Kart Limiti (₺)'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: AppTheme.para(context),
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
              style: AppTheme.para(context),
              validator: (value) =>
                  _tutarValidator(value, zorunlu: false, sifirOlabilir: true),
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
              trailing: const Icon(Icons.calendar_today_outlined),
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
                  : Text(widget.existing == null ? 'Kaydet' : 'Güncelle'),
            ),
          ],
        ),
      ),
    );
  }
}
