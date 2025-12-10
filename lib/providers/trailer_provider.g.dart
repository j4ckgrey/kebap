// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trailer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trailerUrlHash() => r'18be5ab65d027724f69f837ef988dd4a64f0974d';

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

/// Provider that fetches and caches trailer URLs for items.
/// Uses the item's ID to fetch full details which include remoteTrailers.
///
/// Copied from [trailerUrl].
@ProviderFor(trailerUrl)
const trailerUrlProvider = TrailerUrlFamily();

/// Provider that fetches and caches trailer URLs for items.
/// Uses the item's ID to fetch full details which include remoteTrailers.
///
/// Copied from [trailerUrl].
class TrailerUrlFamily extends Family<AsyncValue<String?>> {
  /// Provider that fetches and caches trailer URLs for items.
  /// Uses the item's ID to fetch full details which include remoteTrailers.
  ///
  /// Copied from [trailerUrl].
  const TrailerUrlFamily();

  /// Provider that fetches and caches trailer URLs for items.
  /// Uses the item's ID to fetch full details which include remoteTrailers.
  ///
  /// Copied from [trailerUrl].
  TrailerUrlProvider call(
    String itemId,
  ) {
    return TrailerUrlProvider(
      itemId,
    );
  }

  @override
  TrailerUrlProvider getProviderOverride(
    covariant TrailerUrlProvider provider,
  ) {
    return call(
      provider.itemId,
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
  String? get name => r'trailerUrlProvider';
}

/// Provider that fetches and caches trailer URLs for items.
/// Uses the item's ID to fetch full details which include remoteTrailers.
///
/// Copied from [trailerUrl].
class TrailerUrlProvider extends AutoDisposeFutureProvider<String?> {
  /// Provider that fetches and caches trailer URLs for items.
  /// Uses the item's ID to fetch full details which include remoteTrailers.
  ///
  /// Copied from [trailerUrl].
  TrailerUrlProvider(
    String itemId,
  ) : this._internal(
          (ref) => trailerUrl(
            ref as TrailerUrlRef,
            itemId,
          ),
          from: trailerUrlProvider,
          name: r'trailerUrlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$trailerUrlHash,
          dependencies: TrailerUrlFamily._dependencies,
          allTransitiveDependencies:
              TrailerUrlFamily._allTransitiveDependencies,
          itemId: itemId,
        );

  TrailerUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemId,
  }) : super.internal();

  final String itemId;

  @override
  Override overrideWith(
    FutureOr<String?> Function(TrailerUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TrailerUrlProvider._internal(
        (ref) => create(ref as TrailerUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemId: itemId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _TrailerUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TrailerUrlProvider && other.itemId == itemId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TrailerUrlRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `itemId` of this provider.
  String get itemId;
}

class _TrailerUrlProviderElement
    extends AutoDisposeFutureProviderElement<String?> with TrailerUrlRef {
  _TrailerUrlProviderElement(super.provider);

  @override
  String get itemId => (origin as TrailerUrlProvider).itemId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
