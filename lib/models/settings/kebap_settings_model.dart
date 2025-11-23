import 'dart:convert';

class KebapSettingsModel {
  final bool useBaklava;
  final String? tmdbApiKey;
  final bool? enableSearchFilter;
  final bool? forceTVClientLocalSearch;
  final bool disableNonAdminRequests;
  final bool showReviewsCarousel;

  const KebapSettingsModel({
    this.useBaklava = false,
    this.tmdbApiKey,
    this.enableSearchFilter,
    this.forceTVClientLocalSearch,
    this.disableNonAdminRequests = false,
    this.showReviewsCarousel = true,
  });

  KebapSettingsModel copyWith({
    bool? useBaklava,
    String? tmdbApiKey,
    bool? enableSearchFilter,
    bool? forceTVClientLocalSearch,
    bool? disableNonAdminRequests,
    bool? showReviewsCarousel,
  }) {
    return KebapSettingsModel(
      useBaklava: useBaklava ?? this.useBaklava,
      tmdbApiKey: tmdbApiKey ?? this.tmdbApiKey,
      enableSearchFilter: enableSearchFilter ?? this.enableSearchFilter,
      forceTVClientLocalSearch: forceTVClientLocalSearch ?? this.forceTVClientLocalSearch,
      disableNonAdminRequests: disableNonAdminRequests ?? this.disableNonAdminRequests,
      showReviewsCarousel: showReviewsCarousel ?? this.showReviewsCarousel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'useBaklava': useBaklava,
      'tmdbApiKey': tmdbApiKey,
      'enableSearchFilter': enableSearchFilter,
      'forceTVClientLocalSearch': forceTVClientLocalSearch,
      'disableNonAdminRequests': disableNonAdminRequests,
      'showReviewsCarousel': showReviewsCarousel,
    };
  }

  factory KebapSettingsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const KebapSettingsModel();
    return KebapSettingsModel(
      useBaklava: json['useBaklava'] as bool? ?? false,
      tmdbApiKey: json['tmdbApiKey'] as String?,
      enableSearchFilter: json['enableSearchFilter'] as bool?,
      forceTVClientLocalSearch: json['forceTVClientLocalSearch'] as bool?,
      disableNonAdminRequests: json['disableNonAdminRequests'] as bool? ?? false,
      showReviewsCarousel: json['showReviewsCarousel'] as bool? ?? true,
    );
  }

  factory KebapSettingsModel.fromString(String? str) {
    if (str == null || str.isEmpty) return const KebapSettingsModel();
    try {
      final Map<String, dynamic> json = jsonDecode(str) as Map<String, dynamic>;
      return KebapSettingsModel.fromJson(json);
    } catch (_) {
      return const KebapSettingsModel();
    }
  }

  String toStringJson() => jsonEncode(toJson());
}
