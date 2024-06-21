// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_progress_section_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fullProgressSectionHash() =>
    r'fd02900511cb93a24a0b15dc5947540c5fcedc65';

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

/// See also [fullProgressSection].
@ProviderFor(fullProgressSection)
const fullProgressSectionProvider = FullProgressSectionFamily();

/// See also [fullProgressSection].
class FullProgressSectionFamily
    extends Family<AsyncValue<FullProgressSectionData>> {
  /// See also [fullProgressSection].
  const FullProgressSectionFamily();

  /// See also [fullProgressSection].
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

/// See also [fullProgressSection].
class FullProgressSectionProvider
    extends AutoDisposeFutureProvider<FullProgressSectionData> {
  /// See also [fullProgressSection].
  FullProgressSectionProvider({
    required int section,
  }) : this._internal(
          (ref) => fullProgressSection(
            ref as FullProgressSectionRef,
            section: section,
          ),
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
  Override overrideWith(
    FutureOr<FullProgressSectionData> Function(FullProgressSectionRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FullProgressSectionProvider._internal(
        (ref) => create(ref as FullProgressSectionRef),
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
  AutoDisposeFutureProviderElement<FullProgressSectionData> createElement() {
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
    on AutoDisposeFutureProviderRef<FullProgressSectionData> {
  /// The parameter `section` of this provider.
  int get section;
}

class _FullProgressSectionProviderElement
    extends AutoDisposeFutureProviderElement<FullProgressSectionData>
    with FullProgressSectionRef {
  _FullProgressSectionProviderElement(super.provider);

  @override
  int get section => (origin as FullProgressSectionProvider).section;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
