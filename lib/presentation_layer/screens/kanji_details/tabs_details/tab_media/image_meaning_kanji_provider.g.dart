// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_meaning_kanji_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$imageMeaningKanjiHash() => r'a97ec3f58dbf14f15939cab53c8ddd4eca3e2c48';

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

/// See also [imageMeaningKanji].
@ProviderFor(imageMeaningKanji)
const imageMeaningKanjiProvider = ImageMeaningKanjiFamily();

/// See also [imageMeaningKanji].
class ImageMeaningKanjiFamily extends Family<AsyncValue<ImageDetailsLinkData>> {
  /// See also [imageMeaningKanji].
  const ImageMeaningKanjiFamily();

  /// See also [imageMeaningKanji].
  ImageMeaningKanjiProvider call({
    required String kanjiCharacter,
  }) {
    return ImageMeaningKanjiProvider(
      kanjiCharacter: kanjiCharacter,
    );
  }

  @override
  ImageMeaningKanjiProvider getProviderOverride(
    covariant ImageMeaningKanjiProvider provider,
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
  String? get name => r'imageMeaningKanjiProvider';
}

/// See also [imageMeaningKanji].
class ImageMeaningKanjiProvider
    extends AutoDisposeFutureProvider<ImageDetailsLinkData> {
  /// See also [imageMeaningKanji].
  ImageMeaningKanjiProvider({
    required String kanjiCharacter,
  }) : this._internal(
          (ref) => imageMeaningKanji(
            ref as ImageMeaningKanjiRef,
            kanjiCharacter: kanjiCharacter,
          ),
          from: imageMeaningKanjiProvider,
          name: r'imageMeaningKanjiProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$imageMeaningKanjiHash,
          dependencies: ImageMeaningKanjiFamily._dependencies,
          allTransitiveDependencies:
              ImageMeaningKanjiFamily._allTransitiveDependencies,
          kanjiCharacter: kanjiCharacter,
        );

  ImageMeaningKanjiProvider._internal(
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
  Override overrideWith(
    FutureOr<ImageDetailsLinkData> Function(ImageMeaningKanjiRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ImageMeaningKanjiProvider._internal(
        (ref) => create(ref as ImageMeaningKanjiRef),
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
  AutoDisposeFutureProviderElement<ImageDetailsLinkData> createElement() {
    return _ImageMeaningKanjiProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ImageMeaningKanjiProvider &&
        other.kanjiCharacter == kanjiCharacter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, kanjiCharacter.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ImageMeaningKanjiRef
    on AutoDisposeFutureProviderRef<ImageDetailsLinkData> {
  /// The parameter `kanjiCharacter` of this provider.
  String get kanjiCharacter;
}

class _ImageMeaningKanjiProviderElement
    extends AutoDisposeFutureProviderElement<ImageDetailsLinkData>
    with ImageMeaningKanjiRef {
  _ImageMeaningKanjiProviderElement(super.provider);

  @override
  String get kanjiCharacter =>
      (origin as ImageMeaningKanjiProvider).kanjiCharacter;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
