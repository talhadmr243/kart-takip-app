import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Premium (ücretli) durumunu yönetir.
///
/// İki kaynağı birleştirir:
/// 1. Gerçek satın alma durumu — Play Billing üzerinden ([in_app_purchase]).
/// 2. Debug override — geliştirme sırasında premium'u elle açıp kapatmak
///    için ([setDebugPremium]). Yalnızca debug derlemelerde etkilidir.
///
/// [premiumAktif] her ikisinden biri doğruysa true döner; böylece Play
/// Console hesabı henüz açılmadan da premium akışları test edilebilir.
class PremiumService {
  PremiumService(this._prefs, {InAppPurchase? iap}) : _iapOverride = iap;

  static const monthlyId = 'premium_monthly';
  static const yearlyId = 'premium_yearly';
  static const Set<String> productIds = {monthlyId, yearlyId};

  static const _debugPremiumKey = 'debug_premium_override';
  static const _satinAlindiKey = 'premium_satin_alindi';

  final SharedPreferences _prefs;

  // Yalnızca gerçekten satın alma akışına girildiğinde çözümlenir; testlerde
  // sade constructor kullanıldığında platform kanalına (Play Billing) hiç
  // dokunulmaz.
  final InAppPurchase? _iapOverride;
  InAppPurchase? _iapCache;
  InAppPurchase get _iap => _iapOverride ?? (_iapCache ??= InAppPurchase.instance);

  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  final ValueNotifier<bool> _premiumAktif = ValueNotifier(false);
  final ValueNotifier<List<ProductDetails>> _urunler = ValueNotifier(const []);
  final ValueNotifier<bool> _magazaHazir = ValueNotifier(false);

  static Future<PremiumService> load({InAppPurchase? iap}) async {
    final service = PremiumService(
      await SharedPreferences.getInstance(),
      iap: iap,
    );
    await service._init();
    return service;
  }

  /// Gerçek satın alma VEYA debug override premium'u açar.
  ValueListenable<bool> get premiumAktif => _premiumAktif;

  /// Mağazadan çekilen ürün ayrıntıları (fiyat, başlık vb.).
  ValueListenable<List<ProductDetails>> get urunler => _urunler;

  /// Mağaza bağlantısı kurulabildi mi (cihaz/emülatör Play Billing destekliyor
  /// ve hesap yapılandırılmış mı).
  ValueListenable<bool> get magazaHazir => _magazaHazir;

  bool get debugPremiumAcik => _prefs.getBool(_debugPremiumKey) ?? false;

  Future<void> _init() async {
    _guncelleDurum();

    final available = await _iap.isAvailable();
    _magazaHazir.value = available;
    if (!available) {
      // Play Console hesabı açılmadığı veya cihaz desteklemediği için mağaza
      // erişilemez; debug override yine de çalışmaya devam eder.
      return;
    }

    _purchaseSub = _iap.purchaseStream.listen(
      _satinAlmalariIsle,
      onError: (Object _) {},
    );

    await urunleriYukle();
    // Uygulama açılışında geçmiş satın almaları geri yükle (sessiz).
    await _iap.restorePurchases();
  }

  Future<void> urunleriYukle() async {
    final response = await _iap.queryProductDetails(productIds);
    _urunler.value = response.productDetails;
  }

  /// Verilen ürünü satın alma akışını başlatır. Premium abonelik olduğu için
  /// [buyNonConsumable] kullanılır.
  Future<void> satinAl(ProductDetails urun) async {
    final param = PurchaseParam(productDetails: urun);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  /// Kullanıcının daha önce yaptığı satın almaları geri yükler.
  Future<void> satinAlmalariGeriYukle() => _iap.restorePurchases();

  Future<void> _satinAlmalariIsle(List<PurchaseDetails> purchases) async {
    var premiumOldu = false;
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        continue;
      }
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        // NOT: Gerçek üretimde makbuz sunucu tarafında doğrulanmalıdır.
        // Backend olmadığı için burada istemci tarafı temel doğrulama yapılır.
        if (await _dogrula(purchase)) {
          premiumOldu = true;
        }
      }
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
    if (premiumOldu) {
      await _prefs.setBool(_satinAlindiKey, true);
    }
    _guncelleDurum();
  }

  /// Satın alma doğrulama. Backend olmadığından istemci tarafı kontrol:
  /// ürün kimliği beklenen kümede ve doğrulama verisi boş değil.
  Future<bool> _dogrula(PurchaseDetails purchase) async {
    if (!productIds.contains(purchase.productID)) return false;
    return purchase.verificationData.serverVerificationData.isNotEmpty;
  }

  /// Debug override — yalnızca debug derlemede etkilidir.
  Future<void> setDebugPremium(bool acik) async {
    if (!kDebugMode) return;
    await _prefs.setBool(_debugPremiumKey, acik);
    _guncelleDurum();
  }

  void _guncelleDurum() {
    final satinAlindi = _prefs.getBool(_satinAlindiKey) ?? false;
    final debugAcik = kDebugMode && debugPremiumAcik;
    _premiumAktif.value = satinAlindi || debugAcik;
  }

  void dispose() {
    _purchaseSub?.cancel();
    _premiumAktif.dispose();
    _urunler.dispose();
    _magazaHazir.dispose();
  }
}
