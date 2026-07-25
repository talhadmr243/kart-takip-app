import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../services/premium_service.dart';
import '../theme/app_theme.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key, required this.premiumService});

  final PremiumService premiumService;

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _islemde = false;

  Future<void> _satinAl(ProductDetails urun) async {
    setState(() => _islemde = true);
    try {
      await widget.premiumService.satinAl(urun);
    } finally {
      if (mounted) setState(() => _islemde = false);
    }
  }

  Future<void> _geriYukle() async {
    setState(() => _islemde = true);
    try {
      await widget.premiumService.satinAlmalariGeriYukle();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Satın almalar geri yüklendi.')),
        );
      }
    } finally {
      if (mounted) setState(() => _islemde = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Premium')),
      body: ValueListenableBuilder<bool>(
        valueListenable: widget.premiumService.premiumAktif,
        builder: (context, premiumAktif, _) {
          if (premiumAktif) {
            return _PremiumAktifGorunum(colorScheme: colorScheme);
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _BaslikBolum(colorScheme: colorScheme),
              const SizedBox(height: 8),
              const _OzellikSatiri(metin: 'Sınırsız kart ve abonelik'),
              const _OzellikSatiri(metin: 'Gelişmiş bildirimler'),
              const _OzellikSatiri(metin: 'Reklamsız deneyim'),
              const SizedBox(height: 24),
              ValueListenableBuilder<bool>(
                valueListenable: widget.premiumService.magazaHazir,
                builder: (context, magazaHazir, _) {
                  if (!magazaHazir) {
                    return Card(
                      color: colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Mağaza şu an kullanılamıyor. Satın alma, Play Store '
                          'üzerinden yayınlandıktan sonra etkinleşecek.',
                          style: TextStyle(color: colorScheme.onErrorContainer),
                        ),
                      ),
                    );
                  }
                  return ValueListenableBuilder<List<ProductDetails>>(
                    valueListenable: widget.premiumService.urunler,
                    builder: (context, urunler, _) {
                      if (urunler.isEmpty) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Ürünler yükleniyor veya henüz Play Console\'da '
                              'tanımlanmadı.',
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: urunler
                            .map(
                              (urun) => _UrunKarti(
                                urun: urun,
                                islemde: _islemde,
                                onSatinAl: () => _satinAl(urun),
                              ),
                            )
                            .toList(),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _islemde ? null : _geriYukle,
                child: const Text('Satın almaları geri yükle'),
              ),
              if (kDebugMode) _DebugToggle(premiumService: widget.premiumService),
            ],
          );
        },
      ),
    );
  }
}

class _PremiumAktifGorunum extends StatelessWidget {
  const _PremiumAktifGorunum({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspace_premium_outlined, size: 72, color: colorScheme.secondary),
            const SizedBox(height: 16),
            Text(
              'Premium aktif',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tüm premium özellikler açık. Teşekkürler!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BaslikBolum extends StatelessWidget {
  const _BaslikBolum({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.workspace_premium_outlined, size: 48, color: colorScheme.secondary),
        const SizedBox(height: 12),
        Text('Kart Takip Premium', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          'Ücretsiz sürüm 3 kart ve 3 abonelikle sınırlıdır. Premium ile '
          'sınırsız ekle ve gelişmiş bildirimlere eriş.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _OzellikSatiri extends StatelessWidget {
  const _OzellikSatiri({required this.metin});

  final String metin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check, size: 18, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 8),
          Text(metin),
        ],
      ),
    );
  }
}

class _UrunKarti extends StatelessWidget {
  const _UrunKarti({
    required this.urun,
    required this.islemde,
    required this.onSatinAl,
  });

  final ProductDetails urun;
  final bool islemde;
  final VoidCallback onSatinAl;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(urun.title),
        subtitle: Text(urun.description),
        trailing: FilledButton(
          onPressed: islemde ? null : onSatinAl,
          child: Text(
            urun.price,
            style: AppTheme.para(
              context,
              fontSize: 14,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _DebugToggle extends StatelessWidget {
  const _DebugToggle({required this.premiumService});

  final PremiumService premiumService;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12),
      child: ValueListenableBuilder<bool>(
        valueListenable: premiumService.premiumAktif,
        builder: (context, _, __) => SwitchListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          secondary: const Icon(Icons.bug_report_outlined),
          title: const Text('Debug: Premium override'),
          subtitle: const Text(
            'Yalnızca geliştirme derlemesinde görünür. Satın alma olmadan '
            'premium\'u açar.',
          ),
          value: premiumService.debugPremiumAcik,
          onChanged: (acik) => premiumService.setDebugPremium(acik),
        ),
      ),
    );
  }
}
