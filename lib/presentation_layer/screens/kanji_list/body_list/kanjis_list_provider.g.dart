// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kanjis_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$kanjiListHash() => r'3eb993b13204f829c105955d27efbe37174b540f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$KanjiList
    extends BuildlessAutoDisposeAsyncNotifier<List<KanjiFromApi>> {
  late final List<String> kanjisCharacters;
  late final int sectionNumber;

  FutureOr<List<KanjiFromApi>> build({
    required List<String> kanjisCharacters,
    required int sectionNumber,
  });
}

/// See also [KanjiList].
@ProviderFor(KanjiList)
const kanjiListProvider = KanjiListFamily();

/// See also [KanjiList].
class KanjiListFamily extends Family<AsyncValue<List<KanjiFromApi>>> {
  /// See also [KanjiList].
  const KanjiListFamily();

  /// See also [KanjiList].
  KanjiListProvider call({
    required List<String> kanjisCharacters,
    required int sectionNumber,
  }) {
    return KanjiListProvider(
      kanjisCharacters: kanjisCharacters,
      sectionNumber: sectionNumber,
    );
  }

  @override
  KanjiListProvider getProviderOverride(
    covariant KanjiListProvider provider,
  ) {
    return call(
      kanjisCharacters: provider.kanjisCharacters,
      sectionNumber: provider.sectionNumber,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'kanjiListProvider';
}

/// See also [KanjiList].
class KanjiListProvider extends AutoDisposeAsyncNotifierProviderImpl<KanjiList,
    List<KanjiFromApi>> {
  /// See also [KanjiList].
  KanjiListProvider({
    required List<String> kanjisCharacters,
    required int sectionNumber,
  }) : this._internal(
          () => KanjiList()
            ..kanjisCharacters = kanjisCharacters
            ..sectionNumber = sectionNumber,
          from: kanjiListProvider,
          name: r'kanjiListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$kanjiListHash,
          dependencies: KanjiListFamily._dependencies,
          allTransitiveDependencies: KanjiListFamily._allTransitiveDependencies,
          kanjisCharacters: kanjisCharacters,
          sectionNumber: sectionNumber,
        );

  KanjiListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.kanjisCharacters,
    required this.sectionNumber,
  }) : super.internal();

  final List<String> kanjisCharacters;
  final int sectionNumber;

  @override
  FutureOr<List<KanjiFromApi>> runNotifierBuild(
    covariant KanjiList notifier,
  ) {
    return notifier.build(
      kanjisCharacters: kanjisCharacters,
      sectionNumber: sectionNumber,
    );
  }

  @override
  Override overrideWith(KanjiList Function() create) {
    return ProviderOverride(
      origin: this,
      override: KanjiListProvider._internal(
        () => create()
          ..kanjisCharacters = kanjisCharacters
          ..sectionNumber = sectionNumber,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        kanjisCharacters: kanjisCharacters,
        sectionNumber: sectionNumber,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<KanjiList, List<KanjiFromApi>>
      createElement() {
    return _KanjiListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is KanjiListProvider &&
        other.kanjisCharacters == kanjisCharacters &&
        other.sectionNumber == sectionNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, kanjisCharacters.hashCode);
    hash = _SystemHash.combine(hash, sectionNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin KanjiListRef on AutoDisposeAsyncNotifierProviderRef<List<KanjiFromApi>> {
  /// The parameter `kanjisCharacters` of this provider.
  List<String> get kanjisCharacters;

  /// The parameter `sectionNumber` of this provider.
  int get sectionNumber;
}

class _KanjiListProviderElement extends AutoDisposeAsyncNotifierProviderElement<
    KanjiList, List<KanjiFromApi>> with KanjiListRef {
  _KanjiListProviderElement(super.provider);

  @override
  List<String> get kanjisCharacters =>
      (origin as KanjiListProvider).kanjisCharacters;
  @override
  int get sectionNumber => (origin as KanjiListProvider).sectionNumber;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
