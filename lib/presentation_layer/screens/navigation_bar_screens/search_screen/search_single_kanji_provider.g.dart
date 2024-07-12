// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_single_kanji_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchSingleKanjiHash() => r'6c6511f8470529312c6a88e52640b7c44679a804';

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

abstract class _$SearchSingleKanji
    extends BuildlessAutoDisposeAsyncNotifier<KanjiFromApi> {
  late final String kanjiCharacter;

  FutureOr<KanjiFromApi> build({
    required String kanjiCharacter,
  });
}

/// See also [SearchSingleKanji].
@ProviderFor(SearchSingleKanji)
const searchSingleKanjiProvider = SearchSingleKanjiFamily();

/// See also [SearchSingleKanji].
class SearchSingleKanjiFamily extends Family<AsyncValue<KanjiFromApi>> {
  /// See also [SearchSingleKanji].
  const SearchSingleKanjiFamily();

  /// See also [SearchSingleKanji].
  SearchSingleKanjiProvider call({
    required String kanjiCharacter,
  }) {
    return SearchSingleKanjiProvider(
      kanjiCharacter: kanjiCharacter,
    );
  }

  @override
  SearchSingleKanjiProvider getProviderOverride(
    covariant SearchSingleKanjiProvider provider,
  ) {
    return call(
      kanjiCharacter: provider.kanjiCharacter,
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
  String? get name => r'searchSingleKanjiProvider';
}

/// See also [SearchSingleKanji].
class SearchSingleKanjiProvider extends AutoDisposeAsyncNotifierProviderImpl<
    SearchSingleKanji, KanjiFromApi> {
  /// See also [SearchSingleKanji].
  SearchSingleKanjiProvider({
    required String kanjiCharacter,
  }) : this._internal(
          () => SearchSingleKanji()..kanjiCharacter = kanjiCharacter,
          from: searchSingleKanjiProvider,
          name: r'searchSingleKanjiProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchSingleKanjiHash,
          dependencies: SearchSingleKanjiFamily._dependencies,
          allTransitiveDependencies:
              SearchSingleKanjiFamily._allTransitiveDependencies,
          kanjiCharacter: kanjiCharacter,
        );

  SearchSingleKanjiProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.kanjiCharacter,
  }) : super.internal();

  final String kanjiCharacter;

  @override
  FutureOr<KanjiFromApi> runNotifierBuild(
    covariant SearchSingleKanji notifier,
  ) {
    return notifier.build(
      kanjiCharacter: kanjiCharacter,
    );
  }

  @override
  Override overrideWith(SearchSingleKanji Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchSingleKanjiProvider._internal(
        () => create()..kanjiCharacter = kanjiCharacter,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        kanjiCharacter: kanjiCharacter,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SearchSingleKanji, KanjiFromApi>
      createElement() {
    return _SearchSingleKanjiProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchSingleKanjiProvider &&
        other.kanjiCharacter == kanjiCharacter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, kanjiCharacter.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchSingleKanjiRef
    on AutoDisposeAsyncNotifierProviderRef<KanjiFromApi> {
  /// The parameter `kanjiCharacter` of this provider.
  String get kanjiCharacter;
}

class _SearchSingleKanjiProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SearchSingleKanji,
        KanjiFromApi> with SearchSingleKanjiRef {
  _SearchSingleKanjiProviderElement(super.provider);

  @override
  String get kanjiCharacter =>
      (origin as SearchSingleKanjiProvider).kanjiCharacter;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
