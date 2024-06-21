// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_progress_section_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fullProgressSectionHash() =>
    r'5df834f146033a50b22dd1cee4edce12d660a950';

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

abstract class _$FullProgressSection
    extends BuildlessAutoDisposeNotifier<FullProgressSectionData> {
  late final int section;

  FullProgressSectionData build({
    required int section,
  });
}

/// See also [FullProgressSection].
@ProviderFor(FullProgressSection)
const fullProgressSectionProvider = FullProgressSectionFamily();

/// See also [FullProgressSection].
class FullProgressSectionFamily extends Family<FullProgressSectionData> {
  /// See also [FullProgressSection].
  const FullProgressSectionFamily();

  /// See also [FullProgressSection].
  FullProgressSectionProvider call({
    required int section,
  }) {
    return FullProgressSectionProvider(
      section: section,
    );
  }

  @override
  FullProgressSectionProvider getProviderOverride(
    covariant FullProgressSectionProvider provider,
  ) {
    return call(
      section: provider.section,
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
  String? get name => r'fullProgressSectionProvider';
}

/// See also [FullProgressSection].
class FullProgressSectionProvider extends AutoDisposeNotifierProviderImpl<
    FullProgressSection, FullProgressSectionData> {
  /// See also [FullProgressSection].
  FullProgressSectionProvider({
    required int section,
  }) : this._internal(
          () => FullProgressSection()..section = section,
          from: fullProgressSectionProvider,
          name: r'fullProgressSectionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fullProgressSectionHash,
          dependencies: FullProgressSectionFamily._dependencies,
          allTransitiveDependencies:
              FullProgressSectionFamily._allTransitiveDependencies,
          section: section,
        );

  FullProgressSectionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.section,
  }) : super.internal();

  final int section;

  @override
  FullProgressSectionData runNotifierBuild(
    covariant FullProgressSection notifier,
  ) {
    return notifier.build(
      section: section,
    );
  }

  @override
  Override overrideWith(FullProgressSection Function() create) {
    return ProviderOverride(
      origin: this,
      override: FullProgressSectionProvider._internal(
        () => create()..section = section,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        section: section,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<FullProgressSection,
      FullProgressSectionData> createElement() {
    return _FullProgressSectionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FullProgressSectionProvider && other.section == section;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, section.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FullProgressSectionRef
    on AutoDisposeNotifierProviderRef<FullProgressSectionData> {
  /// The parameter `section` of this provider.
  int get section;
}

class _FullProgressSectionProviderElement
    extends AutoDisposeNotifierProviderElement<FullProgressSection,
        FullProgressSectionData> with FullProgressSectionRef {
  _FullProgressSectionProviderElement(super.provider);

  @override
  int get section => (origin as FullProgressSectionProvider).section;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
