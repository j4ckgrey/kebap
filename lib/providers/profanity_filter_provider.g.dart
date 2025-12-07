// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profanity_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profanityFilterServiceHash() =>
    r'39f39e53f4df22071ca78ba3f3750809a757671f';

/// Provider for the profanity filter service
///
/// Copied from [profanityFilterService].
@ProviderFor(profanityFilterService)
final profanityFilterServiceProvider =
    AutoDisposeProvider<ProfanityFilterService>.internal(
  profanityFilterService,
  name: r'profanityFilterServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profanityFilterServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfanityFilterServiceRef
    = AutoDisposeProviderRef<ProfanityFilterService>;
String _$profanityMetadataHash() => r'fc4e7a1b29cf519c76dcbb5a2acdb47ce867254f';

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

/// Provider for profanity metadata of a specific item
///
/// Copied from [profanityMetadata].
@ProviderFor(profanityMetadata)
const profanityMetadataProvider = ProfanityMetadataFamily();

/// Provider for profanity metadata of a specific item
///
/// Copied from [profanityMetadata].
class ProfanityMetadataFamily extends Family<AsyncValue<ProfanityMetadata?>> {
  /// Provider for profanity metadata of a specific item
  ///
  /// Copied from [profanityMetadata].
  const ProfanityMetadataFamily();

  /// Provider for profanity metadata of a specific item
  ///
  /// Copied from [profanityMetadata].
  ProfanityMetadataProvider call(
    String itemId,
  ) {
    return ProfanityMetadataProvider(
      itemId,
    );
  }

  @override
  ProfanityMetadataProvider getProviderOverride(
    covariant ProfanityMetadataProvider provider,
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
  String? get name => r'profanityMetadataProvider';
}

/// Provider for profanity metadata of a specific item
///
/// Copied from [profanityMetadata].
class ProfanityMetadataProvider
    extends AutoDisposeFutureProvider<ProfanityMetadata?> {
  /// Provider for profanity metadata of a specific item
  ///
  /// Copied from [profanityMetadata].
  ProfanityMetadataProvider(
    String itemId,
  ) : this._internal(
          (ref) => profanityMetadata(
            ref as ProfanityMetadataRef,
            itemId,
          ),
          from: profanityMetadataProvider,
          name: r'profanityMetadataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profanityMetadataHash,
          dependencies: ProfanityMetadataFamily._dependencies,
          allTransitiveDependencies:
              ProfanityMetadataFamily._allTransitiveDependencies,
          itemId: itemId,
        );

  ProfanityMetadataProvider._internal(
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
    FutureOr<ProfanityMetadata?> Function(ProfanityMetadataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProfanityMetadataProvider._internal(
        (ref) => create(ref as ProfanityMetadataRef),
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
  AutoDisposeFutureProviderElement<ProfanityMetadata?> createElement() {
    return _ProfanityMetadataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfanityMetadataProvider && other.itemId == itemId;
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
mixin ProfanityMetadataRef on AutoDisposeFutureProviderRef<ProfanityMetadata?> {
  /// The parameter `itemId` of this provider.
  String get itemId;
}

class _ProfanityMetadataProviderElement
    extends AutoDisposeFutureProviderElement<ProfanityMetadata?>
    with ProfanityMetadataRef {
  _ProfanityMetadataProviderElement(super.provider);

  @override
  String get itemId => (origin as ProfanityMetadataProvider).itemId;
}

String _$profanityFilterActiveHash() =>
    r'230679d5e661567071dd5930a0edf77615cf395a';

/// Convenience provider to check if filter is currently active for the user
///
/// Copied from [profanityFilterActive].
@ProviderFor(profanityFilterActive)
final profanityFilterActiveProvider = AutoDisposeFutureProvider<bool>.internal(
  profanityFilterActive,
  name: r'profanityFilterActiveProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profanityFilterActiveHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfanityFilterActiveRef = AutoDisposeFutureProviderRef<bool>;
String _$profanityPluginAvailableHash() =>
    r'1ac1a4dcd514b5b5d6b5e1ad7cd25ecc983a447c';

/// Provider to check if the profanity filter plugin is available on the server
///
/// Copied from [ProfanityPluginAvailable].
@ProviderFor(ProfanityPluginAvailable)
final profanityPluginAvailableProvider =
    AutoDisposeAsyncNotifierProvider<ProfanityPluginAvailable, bool>.internal(
  ProfanityPluginAvailable.new,
  name: r'profanityPluginAvailableProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profanityPluginAvailableHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfanityPluginAvailable = AutoDisposeAsyncNotifier<bool>;
String _$profanityUserPrefsHash() =>
    r'c1258fe4698894d1b47dd68155af835a25eb152d';

/// Provider for the current user's profanity filter preferences
///
/// Copied from [ProfanityUserPrefs].
@ProviderFor(ProfanityUserPrefs)
final profanityUserPrefsProvider = AutoDisposeAsyncNotifierProvider<
    ProfanityUserPrefs, ProfanityUserPreferences>.internal(
  ProfanityUserPrefs.new,
  name: r'profanityUserPrefsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profanityUserPrefsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfanityUserPrefs
    = AutoDisposeAsyncNotifier<ProfanityUserPreferences>;
String _$profanityConfigHash() => r'5993cdbe38b508ee3f1e59dafb793fd29916b4ae';

/// Provider for the plugin configuration (admin only)
///
/// Copied from [ProfanityConfig].
@ProviderFor(ProfanityConfig)
final profanityConfigProvider = AutoDisposeAsyncNotifierProvider<
    ProfanityConfig, ProfanityPluginConfig>.internal(
  ProfanityConfig.new,
  name: r'profanityConfigProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profanityConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfanityConfig = AutoDisposeAsyncNotifier<ProfanityPluginConfig>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
