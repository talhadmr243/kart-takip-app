import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Uygulama ayarlarını SharedPreferences ile kalıcı olarak saklar.
///
/// [bildirimlerAcik] bir [ValueListenable] olarak sunulur; ayarlar ekranı
/// anahtarı değiştirdiğinde dinleyen ekranlar otomatik güncellenir.
class SettingsService {
  SettingsService(this._prefs);

  static const _bildirimlerAcikKey = 'bildirimler_acik';

  final SharedPreferences _prefs;

  late final ValueNotifier<bool> _bildirimlerAcik = ValueNotifier(
    _prefs.getBool(_bildirimlerAcikKey) ?? true,
  );

  static Future<SettingsService> load() async {
    return SettingsService(await SharedPreferences.getInstance());
  }

  ValueListenable<bool> get bildirimlerAcik => _bildirimlerAcik;

  bool get bildirimlerAcikMi => _bildirimlerAcik.value;

  Future<void> setBildirimlerAcik(bool acik) async {
    _bildirimlerAcik.value = acik;
    await _prefs.setBool(_bildirimlerAcikKey, acik);
  }
}
