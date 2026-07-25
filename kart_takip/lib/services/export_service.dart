import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import '../data/database.dart';

/// Tüm kullanıcı verisini (kart, abonelik ve bildirim/ödeme kayıtları) JSON
/// olarak dışa aktarıp cihazın paylaşım sayfasına gönderir.
class ExportService {
  ExportService(this._database);

  final AppDatabase _database;

  static const int _formatSurumu = 1;

  /// Tüm veriyi JSON metnine dönüştürür.
  Future<String> toplaJson() async {
    final cards = await _database.getAllCards();
    final subscriptions = await _database.getAllSubscriptions();
    final notifications = await _database.getAllNotifications();

    final data = {
      'format_surumu': _formatSurumu,
      'disa_aktarma_tarihi': DateTime.now().toIso8601String(),
      'kartlar': cards
          .map(
            (c) => {
              'id': c.id,
              'banka_adi': c.bankaAdi,
              'kesim_gunu': c.kesimGunu,
              'son_odeme_gunu': c.sonOdemeGunu,
              'limit': c.limit,
              'aidat_tutari': c.aidatTutari,
              'aidat_tarihi': c.aidatTarihi?.toIso8601String(),
            },
          )
          .toList(),
      'abonelikler': subscriptions
          .map(
            (s) => {
              'id': s.id,
              'hizmet_adi': s.hizmetAdi,
              'tutar': s.tutar,
              'bagli_kart_id': s.bagliKartId,
              'baslangic_tarihi': s.baslangicTarihi.toIso8601String(),
              'periyot': s.periyot.name,
            },
          )
          .toList(),
      'odeme_kayitlari': notifications
          .map(
            (n) => {
              'id': n.id,
              'tip': n.tip.name,
              'tetiklenme_tarihi': n.tetiklenmeTarihi.toIso8601String(),
              'ilgili_id': n.ilgiliId,
              'gonderildi_mi': n.gonderildiMi,
            },
          )
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Veriyi JSON dosyasına yazıp paylaşım sayfasını açar.
  Future<void> disaAktarVePaylas() async {
    final json = await toplaJson();
    final dir = await getTemporaryDirectory();
    final tarih = DateTime.now();
    final dosyaAdi =
        'kart_takip_yedek_${tarih.year}'
        '${tarih.month.toString().padLeft(2, '0')}'
        '${tarih.day.toString().padLeft(2, '0')}.json';
    final dosya = File(p.join(dir.path, dosyaAdi));
    await dosya.writeAsString(json);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(dosya.path, mimeType: 'application/json')],
        subject: 'Kart Takip yedeği',
        text: 'Kart Takip verilerinin JSON yedeği.',
      ),
    );
  }
}
