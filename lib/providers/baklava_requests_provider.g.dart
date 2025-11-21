// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baklava_requests_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$baklavaServiceHash() => r'ada17555677dbb305d92b3971a8ed8fa7473a37a';

/// See also [baklavaService].
@ProviderFor(baklavaService)
final baklavaServiceProvider = AutoDisposeProvider<BaklavaService>.internal(
  baklavaService,
  name: r'baklavaServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$baklavaServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BaklavaServiceRef = AutoDisposeProviderRef<BaklavaService>;
String _$baklavaRequestsHash() => r'c20b71222146909999cd0ca39755ad12d2b8c41d';

/// See also [BaklavaRequests].
@ProviderFor(BaklavaRequests)
final baklavaRequestsProvider =
    AutoDisposeNotifierProvider<BaklavaRequests, RequestsState>.internal(
  BaklavaRequests.new,
  name: r'baklavaRequestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$baklavaRequestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BaklavaRequests = AutoDisposeNotifier<RequestsState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
