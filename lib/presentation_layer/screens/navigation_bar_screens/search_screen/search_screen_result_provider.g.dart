// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_screen_result_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchScreenResultHash() =>
    r'bebceeb45611969b7f42e1b330e5c1dfa67329fa';

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

abstract class _$SearchScreenResult
    extends BuildlessAutoDisposeAsyncNotifier<KanjiFromApi?> {
  late final String word;

  FutureOr<KanjiFromApi?> build({
    required String word,
  });
}

/// See also [SearchScreenResult].
@ProviderFor(SearchScreenResult)
const searchScreenResultProvider = SearchScreenResultFamily();

/// See also [SearchScreenResult].
class SearchScreenResultFamily extends Family<AsyncValue<KanjiFromApi?>> {
  /// See also [SearchScreenResult].
  const SearchScreenResultFamily();

  /// See also [SearchScreenResult].
  SearchScreenResultProvider call({
    required String word,
  }) {
    return SearchScreenResultProvider(
      word: word,
    );
  }

  @override
  SearchScreenResultProvider getProviderOverride(
    covariant SearchScreenResultProvider provider,
  ) {
    return call(
      word: provider.word,
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
  String? get name => r'searchScreenResultProvider';
}

/// See also [SearchScreenResult].
class SearchScreenResultProvider extends AutoDisposeAsyncNotifierProviderImpl<
    SearchScreenResult, KanjiFromApi?> {
  /// See also [SearchScreenResult].
  SearchScreenResultProvider({
    required String word,
  }) : this._internal(
          () => SearchScreenResult()..word = word,
          from: searchScreenResultProvider,
          name: r'searchScreenResultProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchScreenResultHash,
          dependencies: SearchScreenResultFamily._dependencies,
          allTransitiveDependencies:
              SearchScreenResultFamily._allTransitiveDependencies,
          word: word,
        );

  SearchScreenResultProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.word,
  }) : super.internal();

  final String word;

  @override
  FutureOr<KanjiFromApi?> runNotifierBuild(
    covariant SearchScreenResult notifier,
  ) {
    return notifier.build(
      word: word,
    );
  }

  @override
  Override overrideWith(SearchScreenResult Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchScreenResultProvider._internal(
        () => create()..word = word,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        word: word,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SearchScreenResult, KanjiFromApi?>
      createElement() {
    return _SearchScreenResultProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchScreenResultProvider && other.word == word;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, word.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchScreenResultRef
    on AutoDisposeAsyncNotifierProviderRef<KanjiFromApi?> {
  /// The parameter `word` of this provider.
  String get word;
}

class _SearchScreenResultProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SearchScreenResult,
        KanjiFromApi?> with SearchScreenResultRef {
  _SearchScreenResultProviderElement(super.provider);

  @override
  String get word => (origin as SearchScreenResultProvider).word;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
