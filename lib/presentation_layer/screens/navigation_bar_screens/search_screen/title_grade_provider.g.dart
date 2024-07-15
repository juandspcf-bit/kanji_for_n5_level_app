// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'title_grade_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$titleGradeHash() => r'767c0f5ea19a5ced1de3567d83589bad9b850114';

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

abstract class _$TitleGrade extends BuildlessAutoDisposeNotifier<String> {
  late final String initText;

  String build({
    required String initText,
  });
}

/// See also [TitleGrade].
@ProviderFor(TitleGrade)
const titleGradeProvider = TitleGradeFamily();

/// See also [TitleGrade].
class TitleGradeFamily extends Family<String> {
  /// See also [TitleGrade].
  const TitleGradeFamily();

  /// See also [TitleGrade].
  TitleGradeProvider call({
    required String initText,
  }) {
    return TitleGradeProvider(
      initText: initText,
    );
  }

  @override
  TitleGradeProvider getProviderOverride(
    covariant TitleGradeProvider provider,
  ) {
    return call(
      initText: provider.initText,
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
  String? get name => r'titleGradeProvider';
}

/// See also [TitleGrade].
class TitleGradeProvider
    extends AutoDisposeNotifierProviderImpl<TitleGrade, String> {
  /// See also [TitleGrade].
  TitleGradeProvider({
    required String initText,
  }) : this._internal(
          () => TitleGrade()..initText = initText,
          from: titleGradeProvider,
          name: r'titleGradeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$titleGradeHash,
          dependencies: TitleGradeFamily._dependencies,
          allTransitiveDependencies:
              TitleGradeFamily._allTransitiveDependencies,
          initText: initText,
        );

  TitleGradeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.initText,
  }) : super.internal();

  final String initText;

  @override
  String runNotifierBuild(
    covariant TitleGrade notifier,
  ) {
    return notifier.build(
      initText: initText,
    );
  }

  @override
  Override overrideWith(TitleGrade Function() create) {
    return ProviderOverride(
      origin: this,
      override: TitleGradeProvider._internal(
        () => create()..initText = initText,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        initText: initText,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TitleGrade, String> createElement() {
    return _TitleGradeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TitleGradeProvider && other.initText == initText;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initText.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TitleGradeRef on AutoDisposeNotifierProviderRef<String> {
  /// The parameter `initText` of this provider.
  String get initText;
}

class _TitleGradeProviderElement
    extends AutoDisposeNotifierProviderElement<TitleGrade, String>
    with TitleGradeRef {
  _TitleGradeProviderElement(super.provider);

  @override
  String get initText => (origin as TitleGradeProvider).initText;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
