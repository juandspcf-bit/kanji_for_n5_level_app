// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_screen_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$progressTimeLineHash() => r'540f465a32f04873cd7cc0022df2120283ca2bc2';

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

/// See also [progressTimeLine].
@ProviderFor(progressTimeLine)
const progressTimeLineProvider = ProgressTimeLineFamily();

/// See also [progressTimeLine].
class ProgressTimeLineFamily extends Family<AsyncValue<ProgressTimeLineData>> {
  /// See also [progressTimeLine].
  const ProgressTimeLineFamily();

  /// See also [progressTimeLine].
  ProgressTimeLineProvider call({
    required String uuid,
  }) {
    return ProgressTimeLineProvider(
      uuid: uuid,
    );
  }

  @override
  ProgressTimeLineProvider getProviderOverride(
    covariant ProgressTimeLineProvider provider,
  ) {
    return call(
      uuid: provider.uuid,
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
  String? get name => r'progressTimeLineProvider';
}

/// See also [progressTimeLine].
class ProgressTimeLineProvider
    extends AutoDisposeFutureProvider<ProgressTimeLineData> {
  /// See also [progressTimeLine].
  ProgressTimeLineProvider({
    required String uuid,
  }) : this._internal(
          (ref) => progressTimeLine(
            ref as ProgressTimeLineRef,
            uuid: uuid,
          ),
          from: progressTimeLineProvider,
          name: r'progressTimeLineProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$progressTimeLineHash,
          dependencies: ProgressTimeLineFamily._dependencies,
          allTransitiveDependencies:
              ProgressTimeLineFamily._allTransitiveDependencies,
          uuid: uuid,
        );

  ProgressTimeLineProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uuid,
  }) : super.internal();

  final String uuid;

  @override
  Override overrideWith(
    FutureOr<ProgressTimeLineData> Function(ProgressTimeLineRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProgressTimeLineProvider._internal(
        (ref) => create(ref as ProgressTimeLineRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uuid: uuid,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ProgressTimeLineData> createElement() {
    return _ProgressTimeLineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProgressTimeLineProvider && other.uuid == uuid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uuid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProgressTimeLineRef
    on AutoDisposeFutureProviderRef<ProgressTimeLineData> {
  /// The parameter `uuid` of this provider.
  String get uuid;
}

class _ProgressTimeLineProviderElement
    extends AutoDisposeFutureProviderElement<ProgressTimeLineData>
    with ProgressTimeLineRef {
  _ProgressTimeLineProviderElement(super.provider);

  @override
  String get uuid => (origin as ProgressTimeLineProvider).uuid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
