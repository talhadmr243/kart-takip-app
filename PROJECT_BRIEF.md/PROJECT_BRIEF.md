# Proje: Kart Ekstre + Abonelik Takip Uygulaması (Türkiye pazarı)

## Ürün özeti
Türk kredi kartı kullanıcıları için: kart ekstre/kesim tarihi takibi,
abonelik yenilenme takibi ve kart aidatı iade hatırlatıcısını tek
ekranda birleştiren mobil uygulama. Hedef: "bu ay kartından ne kadar
çıkacak" sorusuna tek bakışta cevap vermek.

## Fark yaratan özellik
Rakiplerin (Kredi Kartı Takip Uygulaması vb.) hiçbiri abonelik takibini
kapsamıyor. Bu ikisini birleştirmek + kart aidatı iade hatırlatıcısı
asıl farkımız.

## Veri modeli
- Card: banka_adi, kesim_gunu (int 1-31), son_odeme_gunu, limit,
  aidat_tutari, aidat_tarihi
- Subscription: hizmet_adi, tutar, bagli_kart_id, baslangic_tarihi,
  periyot (aylik/yillik)
- Notification: tip (kesim/yenilenme/aidat), tetiklenme_tarihi,
  ilgili_id, gonderildi_mi (bool)

## Algoritma kuralları
- Kesim tarihine 3 gün kala bildirim
- Abonelik yenilenmesine 1 gün kala bildirim
- Aidat tarihine 7 gün kala bildirim
- Ana ekran: SUM(bu ay kesilecek kart tutarları) + SUM(bu ay yenilenecek abonelik tutarları)

## MVP kapsamı (SADECE bunlar, fazlası yok)
1. Kart ekleme ekranı (manuel giriş, banka senkronizasyonu YOK)
2. Abonelik ekleme ekranı (önceden tanımlı 15-20 popüler hizmet + manuel ekleme)
3. Ana ekran: toplam özet kartı + yaklaşan ekstreler listesi + yaklaşan abonelikler listesi
4. Yerel push bildirim (backend gerektirmez)
5. Basit ayarlar ekranı (bildirim açma/kapama)

## Teknoloji tercihi
Flutter (tek kod tabanı, iOS+Android). Yerel veritabanı: SQLite/Drift.
Backend YOK ilk versiyonda — tüm veri cihazda.

## Fiyatlandırma
Ücretsiz: 3 kart + 3 abonelik. Premium: 39 TL/ay veya 299 TL/yıl
(sınırsız + gelişmiş bildirimler).

## Şimdi yapılacak ilk iş
Flutter proje iskeletini kur, yukarıdaki veri modelini SQLite şeması
olarak oluştur, tarih hesaplama fonksiyonlarını (kesim/yenilenme/aidat)
yaz ve unit test ile doğrula. Arayüze geçmeden önce bu mantığın doğru
çalıştığından emin ol.
