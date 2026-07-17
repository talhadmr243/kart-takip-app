// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CardsTable extends Cards with TableInfo<$CardsTable, CardItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bankaAdiMeta =
      const VerificationMeta('bankaAdi');
  @override
  late final GeneratedColumn<String> bankaAdi = GeneratedColumn<String>(
      'banka_adi', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kesimGunuMeta =
      const VerificationMeta('kesimGunu');
  @override
  late final GeneratedColumn<int> kesimGunu = GeneratedColumn<int>(
      'kesim_gunu', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sonOdemeGunuMeta =
      const VerificationMeta('sonOdemeGunu');
  @override
  late final GeneratedColumn<int> sonOdemeGunu = GeneratedColumn<int>(
      'son_odeme_gunu', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _limitMeta = const VerificationMeta('limit');
  @override
  late final GeneratedColumn<double> limit = GeneratedColumn<double>(
      'limit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _aidatTutariMeta =
      const VerificationMeta('aidatTutari');
  @override
  late final GeneratedColumn<double> aidatTutari = GeneratedColumn<double>(
      'aidat_tutari', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _aidatTarihiMeta =
      const VerificationMeta('aidatTarihi');
  @override
  late final GeneratedColumn<DateTime> aidatTarihi = GeneratedColumn<DateTime>(
      'aidat_tarihi', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, bankaAdi, kesimGunu, sonOdemeGunu, limit, aidatTutari, aidatTarihi];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(Insertable<CardItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('banka_adi')) {
      context.handle(_bankaAdiMeta,
          bankaAdi.isAcceptableOrUnknown(data['banka_adi']!, _bankaAdiMeta));
    } else if (isInserting) {
      context.missing(_bankaAdiMeta);
    }
    if (data.containsKey('kesim_gunu')) {
      context.handle(_kesimGunuMeta,
          kesimGunu.isAcceptableOrUnknown(data['kesim_gunu']!, _kesimGunuMeta));
    } else if (isInserting) {
      context.missing(_kesimGunuMeta);
    }
    if (data.containsKey('son_odeme_gunu')) {
      context.handle(
          _sonOdemeGunuMeta,
          sonOdemeGunu.isAcceptableOrUnknown(
              data['son_odeme_gunu']!, _sonOdemeGunuMeta));
    } else if (isInserting) {
      context.missing(_sonOdemeGunuMeta);
    }
    if (data.containsKey('limit')) {
      context.handle(
          _limitMeta, limit.isAcceptableOrUnknown(data['limit']!, _limitMeta));
    } else if (isInserting) {
      context.missing(_limitMeta);
    }
    if (data.containsKey('aidat_tutari')) {
      context.handle(
          _aidatTutariMeta,
          aidatTutari.isAcceptableOrUnknown(
              data['aidat_tutari']!, _aidatTutariMeta));
    }
    if (data.containsKey('aidat_tarihi')) {
      context.handle(
          _aidatTarihiMeta,
          aidatTarihi.isAcceptableOrUnknown(
              data['aidat_tarihi']!, _aidatTarihiMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bankaAdi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}banka_adi'])!,
      kesimGunu: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}kesim_gunu'])!,
      sonOdemeGunu: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}son_odeme_gunu'])!,
      limit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}limit'])!,
      aidatTutari: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}aidat_tutari'])!,
      aidatTarihi: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}aidat_tarihi']),
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }
}

class CardItem extends DataClass implements Insertable<CardItem> {
  final int id;
  final String bankaAdi;
  final int kesimGunu;
  final int sonOdemeGunu;
  final double limit;
  final double aidatTutari;
  final DateTime? aidatTarihi;
  const CardItem(
      {required this.id,
      required this.bankaAdi,
      required this.kesimGunu,
      required this.sonOdemeGunu,
      required this.limit,
      required this.aidatTutari,
      this.aidatTarihi});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['banka_adi'] = Variable<String>(bankaAdi);
    map['kesim_gunu'] = Variable<int>(kesimGunu);
    map['son_odeme_gunu'] = Variable<int>(sonOdemeGunu);
    map['limit'] = Variable<double>(limit);
    map['aidat_tutari'] = Variable<double>(aidatTutari);
    if (!nullToAbsent || aidatTarihi != null) {
      map['aidat_tarihi'] = Variable<DateTime>(aidatTarihi);
    }
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      bankaAdi: Value(bankaAdi),
      kesimGunu: Value(kesimGunu),
      sonOdemeGunu: Value(sonOdemeGunu),
      limit: Value(limit),
      aidatTutari: Value(aidatTutari),
      aidatTarihi: aidatTarihi == null && nullToAbsent
          ? const Value.absent()
          : Value(aidatTarihi),
    );
  }

  factory CardItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardItem(
      id: serializer.fromJson<int>(json['id']),
      bankaAdi: serializer.fromJson<String>(json['bankaAdi']),
      kesimGunu: serializer.fromJson<int>(json['kesimGunu']),
      sonOdemeGunu: serializer.fromJson<int>(json['sonOdemeGunu']),
      limit: serializer.fromJson<double>(json['limit']),
      aidatTutari: serializer.fromJson<double>(json['aidatTutari']),
      aidatTarihi: serializer.fromJson<DateTime?>(json['aidatTarihi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bankaAdi': serializer.toJson<String>(bankaAdi),
      'kesimGunu': serializer.toJson<int>(kesimGunu),
      'sonOdemeGunu': serializer.toJson<int>(sonOdemeGunu),
      'limit': serializer.toJson<double>(limit),
      'aidatTutari': serializer.toJson<double>(aidatTutari),
      'aidatTarihi': serializer.toJson<DateTime?>(aidatTarihi),
    };
  }

  CardItem copyWith(
          {int? id,
          String? bankaAdi,
          int? kesimGunu,
          int? sonOdemeGunu,
          double? limit,
          double? aidatTutari,
          Value<DateTime?> aidatTarihi = const Value.absent()}) =>
      CardItem(
        id: id ?? this.id,
        bankaAdi: bankaAdi ?? this.bankaAdi,
        kesimGunu: kesimGunu ?? this.kesimGunu,
        sonOdemeGunu: sonOdemeGunu ?? this.sonOdemeGunu,
        limit: limit ?? this.limit,
        aidatTutari: aidatTutari ?? this.aidatTutari,
        aidatTarihi: aidatTarihi.present ? aidatTarihi.value : this.aidatTarihi,
      );
  CardItem copyWithCompanion(CardsCompanion data) {
    return CardItem(
      id: data.id.present ? data.id.value : this.id,
      bankaAdi: data.bankaAdi.present ? data.bankaAdi.value : this.bankaAdi,
      kesimGunu: data.kesimGunu.present ? data.kesimGunu.value : this.kesimGunu,
      sonOdemeGunu: data.sonOdemeGunu.present
          ? data.sonOdemeGunu.value
          : this.sonOdemeGunu,
      limit: data.limit.present ? data.limit.value : this.limit,
      aidatTutari:
          data.aidatTutari.present ? data.aidatTutari.value : this.aidatTutari,
      aidatTarihi:
          data.aidatTarihi.present ? data.aidatTarihi.value : this.aidatTarihi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardItem(')
          ..write('id: $id, ')
          ..write('bankaAdi: $bankaAdi, ')
          ..write('kesimGunu: $kesimGunu, ')
          ..write('sonOdemeGunu: $sonOdemeGunu, ')
          ..write('limit: $limit, ')
          ..write('aidatTutari: $aidatTutari, ')
          ..write('aidatTarihi: $aidatTarihi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, bankaAdi, kesimGunu, sonOdemeGunu, limit, aidatTutari, aidatTarihi);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardItem &&
          other.id == this.id &&
          other.bankaAdi == this.bankaAdi &&
          other.kesimGunu == this.kesimGunu &&
          other.sonOdemeGunu == this.sonOdemeGunu &&
          other.limit == this.limit &&
          other.aidatTutari == this.aidatTutari &&
          other.aidatTarihi == this.aidatTarihi);
}

class CardsCompanion extends UpdateCompanion<CardItem> {
  final Value<int> id;
  final Value<String> bankaAdi;
  final Value<int> kesimGunu;
  final Value<int> sonOdemeGunu;
  final Value<double> limit;
  final Value<double> aidatTutari;
  final Value<DateTime?> aidatTarihi;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.bankaAdi = const Value.absent(),
    this.kesimGunu = const Value.absent(),
    this.sonOdemeGunu = const Value.absent(),
    this.limit = const Value.absent(),
    this.aidatTutari = const Value.absent(),
    this.aidatTarihi = const Value.absent(),
  });
  CardsCompanion.insert({
    this.id = const Value.absent(),
    required String bankaAdi,
    required int kesimGunu,
    required int sonOdemeGunu,
    required double limit,
    this.aidatTutari = const Value.absent(),
    this.aidatTarihi = const Value.absent(),
  })  : bankaAdi = Value(bankaAdi),
        kesimGunu = Value(kesimGunu),
        sonOdemeGunu = Value(sonOdemeGunu),
        limit = Value(limit);
  static Insertable<CardItem> custom({
    Expression<int>? id,
    Expression<String>? bankaAdi,
    Expression<int>? kesimGunu,
    Expression<int>? sonOdemeGunu,
    Expression<double>? limit,
    Expression<double>? aidatTutari,
    Expression<DateTime>? aidatTarihi,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bankaAdi != null) 'banka_adi': bankaAdi,
      if (kesimGunu != null) 'kesim_gunu': kesimGunu,
      if (sonOdemeGunu != null) 'son_odeme_gunu': sonOdemeGunu,
      if (limit != null) 'limit': limit,
      if (aidatTutari != null) 'aidat_tutari': aidatTutari,
      if (aidatTarihi != null) 'aidat_tarihi': aidatTarihi,
    });
  }

  CardsCompanion copyWith(
      {Value<int>? id,
      Value<String>? bankaAdi,
      Value<int>? kesimGunu,
      Value<int>? sonOdemeGunu,
      Value<double>? limit,
      Value<double>? aidatTutari,
      Value<DateTime?>? aidatTarihi}) {
    return CardsCompanion(
      id: id ?? this.id,
      bankaAdi: bankaAdi ?? this.bankaAdi,
      kesimGunu: kesimGunu ?? this.kesimGunu,
      sonOdemeGunu: sonOdemeGunu ?? this.sonOdemeGunu,
      limit: limit ?? this.limit,
      aidatTutari: aidatTutari ?? this.aidatTutari,
      aidatTarihi: aidatTarihi ?? this.aidatTarihi,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bankaAdi.present) {
      map['banka_adi'] = Variable<String>(bankaAdi.value);
    }
    if (kesimGunu.present) {
      map['kesim_gunu'] = Variable<int>(kesimGunu.value);
    }
    if (sonOdemeGunu.present) {
      map['son_odeme_gunu'] = Variable<int>(sonOdemeGunu.value);
    }
    if (limit.present) {
      map['limit'] = Variable<double>(limit.value);
    }
    if (aidatTutari.present) {
      map['aidat_tutari'] = Variable<double>(aidatTutari.value);
    }
    if (aidatTarihi.present) {
      map['aidat_tarihi'] = Variable<DateTime>(aidatTarihi.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('bankaAdi: $bankaAdi, ')
          ..write('kesimGunu: $kesimGunu, ')
          ..write('sonOdemeGunu: $sonOdemeGunu, ')
          ..write('limit: $limit, ')
          ..write('aidatTutari: $aidatTutari, ')
          ..write('aidatTarihi: $aidatTarihi')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionsTable extends Subscriptions
    with TableInfo<$SubscriptionsTable, Subscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _hizmetAdiMeta =
      const VerificationMeta('hizmetAdi');
  @override
  late final GeneratedColumn<String> hizmetAdi = GeneratedColumn<String>(
      'hizmet_adi', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tutarMeta = const VerificationMeta('tutar');
  @override
  late final GeneratedColumn<double> tutar = GeneratedColumn<double>(
      'tutar', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _bagliKartIdMeta =
      const VerificationMeta('bagliKartId');
  @override
  late final GeneratedColumn<int> bagliKartId = GeneratedColumn<int>(
      'bagli_kart_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cards (id) ON DELETE CASCADE'));
  static const VerificationMeta _baslangicTarihiMeta =
      const VerificationMeta('baslangicTarihi');
  @override
  late final GeneratedColumn<DateTime> baslangicTarihi =
      GeneratedColumn<DateTime>('baslangic_tarihi', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<SubscriptionPeriod, String>
      periyot = GeneratedColumn<String>('periyot', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SubscriptionPeriod>(
              $SubscriptionsTable.$converterperiyot);
  @override
  List<GeneratedColumn> get $columns =>
      [id, hizmetAdi, tutar, bagliKartId, baslangicTarihi, periyot];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(Insertable<Subscription> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hizmet_adi')) {
      context.handle(_hizmetAdiMeta,
          hizmetAdi.isAcceptableOrUnknown(data['hizmet_adi']!, _hizmetAdiMeta));
    } else if (isInserting) {
      context.missing(_hizmetAdiMeta);
    }
    if (data.containsKey('tutar')) {
      context.handle(
          _tutarMeta, tutar.isAcceptableOrUnknown(data['tutar']!, _tutarMeta));
    } else if (isInserting) {
      context.missing(_tutarMeta);
    }
    if (data.containsKey('bagli_kart_id')) {
      context.handle(
          _bagliKartIdMeta,
          bagliKartId.isAcceptableOrUnknown(
              data['bagli_kart_id']!, _bagliKartIdMeta));
    } else if (isInserting) {
      context.missing(_bagliKartIdMeta);
    }
    if (data.containsKey('baslangic_tarihi')) {
      context.handle(
          _baslangicTarihiMeta,
          baslangicTarihi.isAcceptableOrUnknown(
              data['baslangic_tarihi']!, _baslangicTarihiMeta));
    } else if (isInserting) {
      context.missing(_baslangicTarihiMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subscription(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      hizmetAdi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hizmet_adi'])!,
      tutar: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tutar'])!,
      bagliKartId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bagli_kart_id'])!,
      baslangicTarihi: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}baslangic_tarihi'])!,
      periyot: $SubscriptionsTable.$converterperiyot.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}periyot'])!),
    );
  }

  @override
  $SubscriptionsTable createAlias(String alias) {
    return $SubscriptionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SubscriptionPeriod, String, String>
      $converterperiyot =
      const EnumNameConverter<SubscriptionPeriod>(SubscriptionPeriod.values);
}

class Subscription extends DataClass implements Insertable<Subscription> {
  final int id;
  final String hizmetAdi;
  final double tutar;
  final int bagliKartId;
  final DateTime baslangicTarihi;
  final SubscriptionPeriod periyot;
  const Subscription(
      {required this.id,
      required this.hizmetAdi,
      required this.tutar,
      required this.bagliKartId,
      required this.baslangicTarihi,
      required this.periyot});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['hizmet_adi'] = Variable<String>(hizmetAdi);
    map['tutar'] = Variable<double>(tutar);
    map['bagli_kart_id'] = Variable<int>(bagliKartId);
    map['baslangic_tarihi'] = Variable<DateTime>(baslangicTarihi);
    {
      map['periyot'] = Variable<String>(
          $SubscriptionsTable.$converterperiyot.toSql(periyot));
    }
    return map;
  }

  SubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsCompanion(
      id: Value(id),
      hizmetAdi: Value(hizmetAdi),
      tutar: Value(tutar),
      bagliKartId: Value(bagliKartId),
      baslangicTarihi: Value(baslangicTarihi),
      periyot: Value(periyot),
    );
  }

  factory Subscription.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subscription(
      id: serializer.fromJson<int>(json['id']),
      hizmetAdi: serializer.fromJson<String>(json['hizmetAdi']),
      tutar: serializer.fromJson<double>(json['tutar']),
      bagliKartId: serializer.fromJson<int>(json['bagliKartId']),
      baslangicTarihi: serializer.fromJson<DateTime>(json['baslangicTarihi']),
      periyot: $SubscriptionsTable.$converterperiyot
          .fromJson(serializer.fromJson<String>(json['periyot'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hizmetAdi': serializer.toJson<String>(hizmetAdi),
      'tutar': serializer.toJson<double>(tutar),
      'bagliKartId': serializer.toJson<int>(bagliKartId),
      'baslangicTarihi': serializer.toJson<DateTime>(baslangicTarihi),
      'periyot': serializer.toJson<String>(
          $SubscriptionsTable.$converterperiyot.toJson(periyot)),
    };
  }

  Subscription copyWith(
          {int? id,
          String? hizmetAdi,
          double? tutar,
          int? bagliKartId,
          DateTime? baslangicTarihi,
          SubscriptionPeriod? periyot}) =>
      Subscription(
        id: id ?? this.id,
        hizmetAdi: hizmetAdi ?? this.hizmetAdi,
        tutar: tutar ?? this.tutar,
        bagliKartId: bagliKartId ?? this.bagliKartId,
        baslangicTarihi: baslangicTarihi ?? this.baslangicTarihi,
        periyot: periyot ?? this.periyot,
      );
  Subscription copyWithCompanion(SubscriptionsCompanion data) {
    return Subscription(
      id: data.id.present ? data.id.value : this.id,
      hizmetAdi: data.hizmetAdi.present ? data.hizmetAdi.value : this.hizmetAdi,
      tutar: data.tutar.present ? data.tutar.value : this.tutar,
      bagliKartId:
          data.bagliKartId.present ? data.bagliKartId.value : this.bagliKartId,
      baslangicTarihi: data.baslangicTarihi.present
          ? data.baslangicTarihi.value
          : this.baslangicTarihi,
      periyot: data.periyot.present ? data.periyot.value : this.periyot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subscription(')
          ..write('id: $id, ')
          ..write('hizmetAdi: $hizmetAdi, ')
          ..write('tutar: $tutar, ')
          ..write('bagliKartId: $bagliKartId, ')
          ..write('baslangicTarihi: $baslangicTarihi, ')
          ..write('periyot: $periyot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, hizmetAdi, tutar, bagliKartId, baslangicTarihi, periyot);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subscription &&
          other.id == this.id &&
          other.hizmetAdi == this.hizmetAdi &&
          other.tutar == this.tutar &&
          other.bagliKartId == this.bagliKartId &&
          other.baslangicTarihi == this.baslangicTarihi &&
          other.periyot == this.periyot);
}

class SubscriptionsCompanion extends UpdateCompanion<Subscription> {
  final Value<int> id;
  final Value<String> hizmetAdi;
  final Value<double> tutar;
  final Value<int> bagliKartId;
  final Value<DateTime> baslangicTarihi;
  final Value<SubscriptionPeriod> periyot;
  const SubscriptionsCompanion({
    this.id = const Value.absent(),
    this.hizmetAdi = const Value.absent(),
    this.tutar = const Value.absent(),
    this.bagliKartId = const Value.absent(),
    this.baslangicTarihi = const Value.absent(),
    this.periyot = const Value.absent(),
  });
  SubscriptionsCompanion.insert({
    this.id = const Value.absent(),
    required String hizmetAdi,
    required double tutar,
    required int bagliKartId,
    required DateTime baslangicTarihi,
    required SubscriptionPeriod periyot,
  })  : hizmetAdi = Value(hizmetAdi),
        tutar = Value(tutar),
        bagliKartId = Value(bagliKartId),
        baslangicTarihi = Value(baslangicTarihi),
        periyot = Value(periyot);
  static Insertable<Subscription> custom({
    Expression<int>? id,
    Expression<String>? hizmetAdi,
    Expression<double>? tutar,
    Expression<int>? bagliKartId,
    Expression<DateTime>? baslangicTarihi,
    Expression<String>? periyot,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hizmetAdi != null) 'hizmet_adi': hizmetAdi,
      if (tutar != null) 'tutar': tutar,
      if (bagliKartId != null) 'bagli_kart_id': bagliKartId,
      if (baslangicTarihi != null) 'baslangic_tarihi': baslangicTarihi,
      if (periyot != null) 'periyot': periyot,
    });
  }

  SubscriptionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? hizmetAdi,
      Value<double>? tutar,
      Value<int>? bagliKartId,
      Value<DateTime>? baslangicTarihi,
      Value<SubscriptionPeriod>? periyot}) {
    return SubscriptionsCompanion(
      id: id ?? this.id,
      hizmetAdi: hizmetAdi ?? this.hizmetAdi,
      tutar: tutar ?? this.tutar,
      bagliKartId: bagliKartId ?? this.bagliKartId,
      baslangicTarihi: baslangicTarihi ?? this.baslangicTarihi,
      periyot: periyot ?? this.periyot,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hizmetAdi.present) {
      map['hizmet_adi'] = Variable<String>(hizmetAdi.value);
    }
    if (tutar.present) {
      map['tutar'] = Variable<double>(tutar.value);
    }
    if (bagliKartId.present) {
      map['bagli_kart_id'] = Variable<int>(bagliKartId.value);
    }
    if (baslangicTarihi.present) {
      map['baslangic_tarihi'] = Variable<DateTime>(baslangicTarihi.value);
    }
    if (periyot.present) {
      map['periyot'] = Variable<String>(
          $SubscriptionsTable.$converterperiyot.toSql(periyot.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('hizmetAdi: $hizmetAdi, ')
          ..write('tutar: $tutar, ')
          ..write('bagliKartId: $bagliKartId, ')
          ..write('baslangicTarihi: $baslangicTarihi, ')
          ..write('periyot: $periyot')
          ..write(')'))
        .toString();
  }
}

class $NotificationsTable extends Notifications
    with TableInfo<$NotificationsTable, NotificationItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumnWithTypeConverter<NotificationType, String> tip =
      GeneratedColumn<String>('tip', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<NotificationType>($NotificationsTable.$convertertip);
  static const VerificationMeta _tetiklenmeTarihiMeta =
      const VerificationMeta('tetiklenmeTarihi');
  @override
  late final GeneratedColumn<DateTime> tetiklenmeTarihi =
      GeneratedColumn<DateTime>('tetiklenme_tarihi', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _ilgiliIdMeta =
      const VerificationMeta('ilgiliId');
  @override
  late final GeneratedColumn<int> ilgiliId = GeneratedColumn<int>(
      'ilgili_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _gonderildiMiMeta =
      const VerificationMeta('gonderildiMi');
  @override
  late final GeneratedColumn<bool> gonderildiMi = GeneratedColumn<bool>(
      'gonderildi_mi', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("gonderildi_mi" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, tip, tetiklenmeTarihi, ilgiliId, gonderildiMi];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notifications';
  @override
  VerificationContext validateIntegrity(Insertable<NotificationItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tetiklenme_tarihi')) {
      context.handle(
          _tetiklenmeTarihiMeta,
          tetiklenmeTarihi.isAcceptableOrUnknown(
              data['tetiklenme_tarihi']!, _tetiklenmeTarihiMeta));
    } else if (isInserting) {
      context.missing(_tetiklenmeTarihiMeta);
    }
    if (data.containsKey('ilgili_id')) {
      context.handle(_ilgiliIdMeta,
          ilgiliId.isAcceptableOrUnknown(data['ilgili_id']!, _ilgiliIdMeta));
    } else if (isInserting) {
      context.missing(_ilgiliIdMeta);
    }
    if (data.containsKey('gonderildi_mi')) {
      context.handle(
          _gonderildiMiMeta,
          gonderildiMi.isAcceptableOrUnknown(
              data['gonderildi_mi']!, _gonderildiMiMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tip: $NotificationsTable.$convertertip.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tip'])!),
      tetiklenmeTarihi: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}tetiklenme_tarihi'])!,
      ilgiliId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ilgili_id'])!,
      gonderildiMi: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}gonderildi_mi'])!,
    );
  }

  @override
  $NotificationsTable createAlias(String alias) {
    return $NotificationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<NotificationType, String, String> $convertertip =
      const EnumNameConverter<NotificationType>(NotificationType.values);
}

class NotificationItem extends DataClass
    implements Insertable<NotificationItem> {
  final int id;
  final NotificationType tip;
  final DateTime tetiklenmeTarihi;
  final int ilgiliId;
  final bool gonderildiMi;
  const NotificationItem(
      {required this.id,
      required this.tip,
      required this.tetiklenmeTarihi,
      required this.ilgiliId,
      required this.gonderildiMi});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['tip'] =
          Variable<String>($NotificationsTable.$convertertip.toSql(tip));
    }
    map['tetiklenme_tarihi'] = Variable<DateTime>(tetiklenmeTarihi);
    map['ilgili_id'] = Variable<int>(ilgiliId);
    map['gonderildi_mi'] = Variable<bool>(gonderildiMi);
    return map;
  }

  NotificationsCompanion toCompanion(bool nullToAbsent) {
    return NotificationsCompanion(
      id: Value(id),
      tip: Value(tip),
      tetiklenmeTarihi: Value(tetiklenmeTarihi),
      ilgiliId: Value(ilgiliId),
      gonderildiMi: Value(gonderildiMi),
    );
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationItem(
      id: serializer.fromJson<int>(json['id']),
      tip: $NotificationsTable.$convertertip
          .fromJson(serializer.fromJson<String>(json['tip'])),
      tetiklenmeTarihi: serializer.fromJson<DateTime>(json['tetiklenmeTarihi']),
      ilgiliId: serializer.fromJson<int>(json['ilgiliId']),
      gonderildiMi: serializer.fromJson<bool>(json['gonderildiMi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tip': serializer
          .toJson<String>($NotificationsTable.$convertertip.toJson(tip)),
      'tetiklenmeTarihi': serializer.toJson<DateTime>(tetiklenmeTarihi),
      'ilgiliId': serializer.toJson<int>(ilgiliId),
      'gonderildiMi': serializer.toJson<bool>(gonderildiMi),
    };
  }

  NotificationItem copyWith(
          {int? id,
          NotificationType? tip,
          DateTime? tetiklenmeTarihi,
          int? ilgiliId,
          bool? gonderildiMi}) =>
      NotificationItem(
        id: id ?? this.id,
        tip: tip ?? this.tip,
        tetiklenmeTarihi: tetiklenmeTarihi ?? this.tetiklenmeTarihi,
        ilgiliId: ilgiliId ?? this.ilgiliId,
        gonderildiMi: gonderildiMi ?? this.gonderildiMi,
      );
  NotificationItem copyWithCompanion(NotificationsCompanion data) {
    return NotificationItem(
      id: data.id.present ? data.id.value : this.id,
      tip: data.tip.present ? data.tip.value : this.tip,
      tetiklenmeTarihi: data.tetiklenmeTarihi.present
          ? data.tetiklenmeTarihi.value
          : this.tetiklenmeTarihi,
      ilgiliId: data.ilgiliId.present ? data.ilgiliId.value : this.ilgiliId,
      gonderildiMi: data.gonderildiMi.present
          ? data.gonderildiMi.value
          : this.gonderildiMi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationItem(')
          ..write('id: $id, ')
          ..write('tip: $tip, ')
          ..write('tetiklenmeTarihi: $tetiklenmeTarihi, ')
          ..write('ilgiliId: $ilgiliId, ')
          ..write('gonderildiMi: $gonderildiMi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tip, tetiklenmeTarihi, ilgiliId, gonderildiMi);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationItem &&
          other.id == this.id &&
          other.tip == this.tip &&
          other.tetiklenmeTarihi == this.tetiklenmeTarihi &&
          other.ilgiliId == this.ilgiliId &&
          other.gonderildiMi == this.gonderildiMi);
}

class NotificationsCompanion extends UpdateCompanion<NotificationItem> {
  final Value<int> id;
  final Value<NotificationType> tip;
  final Value<DateTime> tetiklenmeTarihi;
  final Value<int> ilgiliId;
  final Value<bool> gonderildiMi;
  const NotificationsCompanion({
    this.id = const Value.absent(),
    this.tip = const Value.absent(),
    this.tetiklenmeTarihi = const Value.absent(),
    this.ilgiliId = const Value.absent(),
    this.gonderildiMi = const Value.absent(),
  });
  NotificationsCompanion.insert({
    this.id = const Value.absent(),
    required NotificationType tip,
    required DateTime tetiklenmeTarihi,
    required int ilgiliId,
    this.gonderildiMi = const Value.absent(),
  })  : tip = Value(tip),
        tetiklenmeTarihi = Value(tetiklenmeTarihi),
        ilgiliId = Value(ilgiliId);
  static Insertable<NotificationItem> custom({
    Expression<int>? id,
    Expression<String>? tip,
    Expression<DateTime>? tetiklenmeTarihi,
    Expression<int>? ilgiliId,
    Expression<bool>? gonderildiMi,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tip != null) 'tip': tip,
      if (tetiklenmeTarihi != null) 'tetiklenme_tarihi': tetiklenmeTarihi,
      if (ilgiliId != null) 'ilgili_id': ilgiliId,
      if (gonderildiMi != null) 'gonderildi_mi': gonderildiMi,
    });
  }

  NotificationsCompanion copyWith(
      {Value<int>? id,
      Value<NotificationType>? tip,
      Value<DateTime>? tetiklenmeTarihi,
      Value<int>? ilgiliId,
      Value<bool>? gonderildiMi}) {
    return NotificationsCompanion(
      id: id ?? this.id,
      tip: tip ?? this.tip,
      tetiklenmeTarihi: tetiklenmeTarihi ?? this.tetiklenmeTarihi,
      ilgiliId: ilgiliId ?? this.ilgiliId,
      gonderildiMi: gonderildiMi ?? this.gonderildiMi,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tip.present) {
      map['tip'] =
          Variable<String>($NotificationsTable.$convertertip.toSql(tip.value));
    }
    if (tetiklenmeTarihi.present) {
      map['tetiklenme_tarihi'] = Variable<DateTime>(tetiklenmeTarihi.value);
    }
    if (ilgiliId.present) {
      map['ilgili_id'] = Variable<int>(ilgiliId.value);
    }
    if (gonderildiMi.present) {
      map['gonderildi_mi'] = Variable<bool>(gonderildiMi.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsCompanion(')
          ..write('id: $id, ')
          ..write('tip: $tip, ')
          ..write('tetiklenmeTarihi: $tetiklenmeTarihi, ')
          ..write('ilgiliId: $ilgiliId, ')
          ..write('gonderildiMi: $gonderildiMi')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CardsTable cards = $CardsTable(this);
  late final $SubscriptionsTable subscriptions = $SubscriptionsTable(this);
  late final $NotificationsTable notifications = $NotificationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [cards, subscriptions, notifications];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('cards',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('subscriptions', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$CardsTableCreateCompanionBuilder = CardsCompanion Function({
  Value<int> id,
  required String bankaAdi,
  required int kesimGunu,
  required int sonOdemeGunu,
  required double limit,
  Value<double> aidatTutari,
  Value<DateTime?> aidatTarihi,
});
typedef $$CardsTableUpdateCompanionBuilder = CardsCompanion Function({
  Value<int> id,
  Value<String> bankaAdi,
  Value<int> kesimGunu,
  Value<int> sonOdemeGunu,
  Value<double> limit,
  Value<double> aidatTutari,
  Value<DateTime?> aidatTarihi,
});

final class $$CardsTableReferences
    extends BaseReferences<_$AppDatabase, $CardsTable, CardItem> {
  $$CardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SubscriptionsTable, List<Subscription>>
      _subscriptionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.subscriptions,
              aliasName: $_aliasNameGenerator(
                  db.cards.id, db.subscriptions.bagliKartId));

  $$SubscriptionsTableProcessedTableManager get subscriptionsRefs {
    final manager = $$SubscriptionsTableTableManager($_db, $_db.subscriptions)
        .filter((f) => f.bagliKartId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_subscriptionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bankaAdi => $composableBuilder(
      column: $table.bankaAdi, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kesimGunu => $composableBuilder(
      column: $table.kesimGunu, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sonOdemeGunu => $composableBuilder(
      column: $table.sonOdemeGunu, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get limit => $composableBuilder(
      column: $table.limit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get aidatTutari => $composableBuilder(
      column: $table.aidatTutari, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get aidatTarihi => $composableBuilder(
      column: $table.aidatTarihi, builder: (column) => ColumnFilters(column));

  Expression<bool> subscriptionsRefs(
      Expression<bool> Function($$SubscriptionsTableFilterComposer f) f) {
    final $$SubscriptionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.subscriptions,
        getReferencedColumn: (t) => t.bagliKartId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubscriptionsTableFilterComposer(
              $db: $db,
              $table: $db.subscriptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bankaAdi => $composableBuilder(
      column: $table.bankaAdi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kesimGunu => $composableBuilder(
      column: $table.kesimGunu, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sonOdemeGunu => $composableBuilder(
      column: $table.sonOdemeGunu,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get limit => $composableBuilder(
      column: $table.limit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get aidatTutari => $composableBuilder(
      column: $table.aidatTutari, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get aidatTarihi => $composableBuilder(
      column: $table.aidatTarihi, builder: (column) => ColumnOrderings(column));
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bankaAdi =>
      $composableBuilder(column: $table.bankaAdi, builder: (column) => column);

  GeneratedColumn<int> get kesimGunu =>
      $composableBuilder(column: $table.kesimGunu, builder: (column) => column);

  GeneratedColumn<int> get sonOdemeGunu => $composableBuilder(
      column: $table.sonOdemeGunu, builder: (column) => column);

  GeneratedColumn<double> get limit =>
      $composableBuilder(column: $table.limit, builder: (column) => column);

  GeneratedColumn<double> get aidatTutari => $composableBuilder(
      column: $table.aidatTutari, builder: (column) => column);

  GeneratedColumn<DateTime> get aidatTarihi => $composableBuilder(
      column: $table.aidatTarihi, builder: (column) => column);

  Expression<T> subscriptionsRefs<T extends Object>(
      Expression<T> Function($$SubscriptionsTableAnnotationComposer a) f) {
    final $$SubscriptionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.subscriptions,
        getReferencedColumn: (t) => t.bagliKartId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubscriptionsTableAnnotationComposer(
              $db: $db,
              $table: $db.subscriptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CardsTable,
    CardItem,
    $$CardsTableFilterComposer,
    $$CardsTableOrderingComposer,
    $$CardsTableAnnotationComposer,
    $$CardsTableCreateCompanionBuilder,
    $$CardsTableUpdateCompanionBuilder,
    (CardItem, $$CardsTableReferences),
    CardItem,
    PrefetchHooks Function({bool subscriptionsRefs})> {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> bankaAdi = const Value.absent(),
            Value<int> kesimGunu = const Value.absent(),
            Value<int> sonOdemeGunu = const Value.absent(),
            Value<double> limit = const Value.absent(),
            Value<double> aidatTutari = const Value.absent(),
            Value<DateTime?> aidatTarihi = const Value.absent(),
          }) =>
              CardsCompanion(
            id: id,
            bankaAdi: bankaAdi,
            kesimGunu: kesimGunu,
            sonOdemeGunu: sonOdemeGunu,
            limit: limit,
            aidatTutari: aidatTutari,
            aidatTarihi: aidatTarihi,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String bankaAdi,
            required int kesimGunu,
            required int sonOdemeGunu,
            required double limit,
            Value<double> aidatTutari = const Value.absent(),
            Value<DateTime?> aidatTarihi = const Value.absent(),
          }) =>
              CardsCompanion.insert(
            id: id,
            bankaAdi: bankaAdi,
            kesimGunu: kesimGunu,
            sonOdemeGunu: sonOdemeGunu,
            limit: limit,
            aidatTutari: aidatTutari,
            aidatTarihi: aidatTarihi,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$CardsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({subscriptionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (subscriptionsRefs) db.subscriptions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (subscriptionsRefs)
                    await $_getPrefetchedData<CardItem, $CardsTable,
                            Subscription>(
                        currentTable: table,
                        referencedTable:
                            $$CardsTableReferences._subscriptionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CardsTableReferences(db, table, p0)
                                .subscriptionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.bagliKartId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CardsTable,
    CardItem,
    $$CardsTableFilterComposer,
    $$CardsTableOrderingComposer,
    $$CardsTableAnnotationComposer,
    $$CardsTableCreateCompanionBuilder,
    $$CardsTableUpdateCompanionBuilder,
    (CardItem, $$CardsTableReferences),
    CardItem,
    PrefetchHooks Function({bool subscriptionsRefs})>;
typedef $$SubscriptionsTableCreateCompanionBuilder = SubscriptionsCompanion
    Function({
  Value<int> id,
  required String hizmetAdi,
  required double tutar,
  required int bagliKartId,
  required DateTime baslangicTarihi,
  required SubscriptionPeriod periyot,
});
typedef $$SubscriptionsTableUpdateCompanionBuilder = SubscriptionsCompanion
    Function({
  Value<int> id,
  Value<String> hizmetAdi,
  Value<double> tutar,
  Value<int> bagliKartId,
  Value<DateTime> baslangicTarihi,
  Value<SubscriptionPeriod> periyot,
});

final class $$SubscriptionsTableReferences
    extends BaseReferences<_$AppDatabase, $SubscriptionsTable, Subscription> {
  $$SubscriptionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CardsTable _bagliKartIdTable(_$AppDatabase db) =>
      db.cards.createAlias(
          $_aliasNameGenerator(db.subscriptions.bagliKartId, db.cards.id));

  $$CardsTableProcessedTableManager get bagliKartId {
    final $_column = $_itemColumn<int>('bagli_kart_id')!;

    final manager = $$CardsTableTableManager($_db, $_db.cards)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bagliKartIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hizmetAdi => $composableBuilder(
      column: $table.hizmetAdi, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tutar => $composableBuilder(
      column: $table.tutar, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get baslangicTarihi => $composableBuilder(
      column: $table.baslangicTarihi,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SubscriptionPeriod, SubscriptionPeriod, String>
      get periyot => $composableBuilder(
          column: $table.periyot,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$CardsTableFilterComposer get bagliKartId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bagliKartId,
        referencedTable: $db.cards,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CardsTableFilterComposer(
              $db: $db,
              $table: $db.cards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hizmetAdi => $composableBuilder(
      column: $table.hizmetAdi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tutar => $composableBuilder(
      column: $table.tutar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get baslangicTarihi => $composableBuilder(
      column: $table.baslangicTarihi,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get periyot => $composableBuilder(
      column: $table.periyot, builder: (column) => ColumnOrderings(column));

  $$CardsTableOrderingComposer get bagliKartId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bagliKartId,
        referencedTable: $db.cards,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CardsTableOrderingComposer(
              $db: $db,
              $table: $db.cards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get hizmetAdi =>
      $composableBuilder(column: $table.hizmetAdi, builder: (column) => column);

  GeneratedColumn<double> get tutar =>
      $composableBuilder(column: $table.tutar, builder: (column) => column);

  GeneratedColumn<DateTime> get baslangicTarihi => $composableBuilder(
      column: $table.baslangicTarihi, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SubscriptionPeriod, String> get periyot =>
      $composableBuilder(column: $table.periyot, builder: (column) => column);

  $$CardsTableAnnotationComposer get bagliKartId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bagliKartId,
        referencedTable: $db.cards,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CardsTableAnnotationComposer(
              $db: $db,
              $table: $db.cards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubscriptionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubscriptionsTable,
    Subscription,
    $$SubscriptionsTableFilterComposer,
    $$SubscriptionsTableOrderingComposer,
    $$SubscriptionsTableAnnotationComposer,
    $$SubscriptionsTableCreateCompanionBuilder,
    $$SubscriptionsTableUpdateCompanionBuilder,
    (Subscription, $$SubscriptionsTableReferences),
    Subscription,
    PrefetchHooks Function({bool bagliKartId})> {
  $$SubscriptionsTableTableManager(_$AppDatabase db, $SubscriptionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> hizmetAdi = const Value.absent(),
            Value<double> tutar = const Value.absent(),
            Value<int> bagliKartId = const Value.absent(),
            Value<DateTime> baslangicTarihi = const Value.absent(),
            Value<SubscriptionPeriod> periyot = const Value.absent(),
          }) =>
              SubscriptionsCompanion(
            id: id,
            hizmetAdi: hizmetAdi,
            tutar: tutar,
            bagliKartId: bagliKartId,
            baslangicTarihi: baslangicTarihi,
            periyot: periyot,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String hizmetAdi,
            required double tutar,
            required int bagliKartId,
            required DateTime baslangicTarihi,
            required SubscriptionPeriod periyot,
          }) =>
              SubscriptionsCompanion.insert(
            id: id,
            hizmetAdi: hizmetAdi,
            tutar: tutar,
            bagliKartId: bagliKartId,
            baslangicTarihi: baslangicTarihi,
            periyot: periyot,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SubscriptionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({bagliKartId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (bagliKartId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.bagliKartId,
                    referencedTable:
                        $$SubscriptionsTableReferences._bagliKartIdTable(db),
                    referencedColumn:
                        $$SubscriptionsTableReferences._bagliKartIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SubscriptionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubscriptionsTable,
    Subscription,
    $$SubscriptionsTableFilterComposer,
    $$SubscriptionsTableOrderingComposer,
    $$SubscriptionsTableAnnotationComposer,
    $$SubscriptionsTableCreateCompanionBuilder,
    $$SubscriptionsTableUpdateCompanionBuilder,
    (Subscription, $$SubscriptionsTableReferences),
    Subscription,
    PrefetchHooks Function({bool bagliKartId})>;
typedef $$NotificationsTableCreateCompanionBuilder = NotificationsCompanion
    Function({
  Value<int> id,
  required NotificationType tip,
  required DateTime tetiklenmeTarihi,
  required int ilgiliId,
  Value<bool> gonderildiMi,
});
typedef $$NotificationsTableUpdateCompanionBuilder = NotificationsCompanion
    Function({
  Value<int> id,
  Value<NotificationType> tip,
  Value<DateTime> tetiklenmeTarihi,
  Value<int> ilgiliId,
  Value<bool> gonderildiMi,
});

class $$NotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<NotificationType, NotificationType, String>
      get tip => $composableBuilder(
          column: $table.tip,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get tetiklenmeTarihi => $composableBuilder(
      column: $table.tetiklenmeTarihi,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ilgiliId => $composableBuilder(
      column: $table.ilgiliId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get gonderildiMi => $composableBuilder(
      column: $table.gonderildiMi, builder: (column) => ColumnFilters(column));
}

class $$NotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tip => $composableBuilder(
      column: $table.tip, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get tetiklenmeTarihi => $composableBuilder(
      column: $table.tetiklenmeTarihi,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ilgiliId => $composableBuilder(
      column: $table.ilgiliId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get gonderildiMi => $composableBuilder(
      column: $table.gonderildiMi,
      builder: (column) => ColumnOrderings(column));
}

class $$NotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NotificationType, String> get tip =>
      $composableBuilder(column: $table.tip, builder: (column) => column);

  GeneratedColumn<DateTime> get tetiklenmeTarihi => $composableBuilder(
      column: $table.tetiklenmeTarihi, builder: (column) => column);

  GeneratedColumn<int> get ilgiliId =>
      $composableBuilder(column: $table.ilgiliId, builder: (column) => column);

  GeneratedColumn<bool> get gonderildiMi => $composableBuilder(
      column: $table.gonderildiMi, builder: (column) => column);
}

class $$NotificationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotificationsTable,
    NotificationItem,
    $$NotificationsTableFilterComposer,
    $$NotificationsTableOrderingComposer,
    $$NotificationsTableAnnotationComposer,
    $$NotificationsTableCreateCompanionBuilder,
    $$NotificationsTableUpdateCompanionBuilder,
    (
      NotificationItem,
      BaseReferences<_$AppDatabase, $NotificationsTable, NotificationItem>
    ),
    NotificationItem,
    PrefetchHooks Function()> {
  $$NotificationsTableTableManager(_$AppDatabase db, $NotificationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<NotificationType> tip = const Value.absent(),
            Value<DateTime> tetiklenmeTarihi = const Value.absent(),
            Value<int> ilgiliId = const Value.absent(),
            Value<bool> gonderildiMi = const Value.absent(),
          }) =>
              NotificationsCompanion(
            id: id,
            tip: tip,
            tetiklenmeTarihi: tetiklenmeTarihi,
            ilgiliId: ilgiliId,
            gonderildiMi: gonderildiMi,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required NotificationType tip,
            required DateTime tetiklenmeTarihi,
            required int ilgiliId,
            Value<bool> gonderildiMi = const Value.absent(),
          }) =>
              NotificationsCompanion.insert(
            id: id,
            tip: tip,
            tetiklenmeTarihi: tetiklenmeTarihi,
            ilgiliId: ilgiliId,
            gonderildiMi: gonderildiMi,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotificationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotificationsTable,
    NotificationItem,
    $$NotificationsTableFilterComposer,
    $$NotificationsTableOrderingComposer,
    $$NotificationsTableAnnotationComposer,
    $$NotificationsTableCreateCompanionBuilder,
    $$NotificationsTableUpdateCompanionBuilder,
    (
      NotificationItem,
      BaseReferences<_$AppDatabase, $NotificationsTable, NotificationItem>
    ),
    NotificationItem,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db, _db.subscriptions);
  $$NotificationsTableTableManager get notifications =>
      $$NotificationsTableTableManager(_db, _db.notifications);
}
