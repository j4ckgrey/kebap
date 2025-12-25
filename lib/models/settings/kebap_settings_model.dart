import 'dart:convert';

class KebapSettingsModel {
  final bool useBaklava;
  final String? tmdbApiKey;
  final bool? enableSearchFilter;
  final bool? forceTVClientLocalSearch;
  final bool enableAutoImport;
  final bool showReviewsCarousel;
  final double mobileHomepageHeightRatio; // 0.3 to 0.7, controls banner height on phones
  final bool disableModal;

  const KebapSettingsModel({
    this.useBaklava = false,
    this.tmdbApiKey,
    this.enableSearchFilter,
    this.forceTVClientLocalSearch,
    this.enableAutoImport = false,
    this.showReviewsCarousel = true,
    this.mobileHomepageHeightRatio = 0.6,
    this.disableModal = false,
  });

  KebapSettingsModel copyWith({
    bool? useBaklava,
    String? tmdbApiKey,
    bool? enableSearchFilter,
    bool? forceTVClientLocalSearch,
    bool? enableAutoImport,
    bool? showReviewsCarousel,
    double? mobileHomepageHeightRatio,
    bool? disableModal,
  }) {
    return KebapSettingsModel(
      useBaklava: useBaklava ?? this.useBaklava,
      tmdbApiKey: tmdbApiKey ?? this.tmdbApiKey,
      enableSearchFilter: enableSearchFilter ?? this.enableSearchFilter,
      forceTVClientLocalSearch: forceTVClientLocalSearch ?? this.forceTVClientLocalSearch,
      enableAutoImport: enableAutoImport ?? this.enableAutoImport,
      showReviewsCarousel: showReviewsCarousel ?? this.showReviewsCarousel,
      mobileHomepageHeightRatio: mobileHomepageHeightRatio ?? this.mobileHomepageHeightRatio,
      disableModal: disableModal ?? this.disableModal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'useBaklava': useBaklava,
      'tmdbApiKey': tmdbApiKey,
      'enableSearchFilter': enableSearchFilter,
      'forceTVClientLocalSearch': forceTVClientLocalSearch,
      'enableAutoImport': enableAutoImport,
      'showReviewsCarousel': showReviewsCarousel,
      'mobileHomepageHeightRatio': mobileHomepageHeightRatio,
      'disableModal': disableModal,
    };
  }

  factory KebapSettingsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const KebapSettingsModel();
    return KebapSettingsModel(
      useBaklava: json['useBaklava'] as bool? ?? false,
      tmdbApiKey: json['tmdbApiKey'] as String?,
      enableSearchFilter: json['enableSearchFilter'] as bool?,
      forceTVClientLocalSearch: json['forceTVClientLocalSearch'] as bool?,
      enableAutoImport: json['enableAutoImport'] as bool? ?? false,
      showReviewsCarousel: json['showReviewsCarousel'] as bool? ?? true,
      mobileHomepageHeightRatio: (json['mobileHomepageHeightRatio'] as num?)?.toDouble() ?? 0.6,
      disableModal: json['disableModal'] as bool? ?? false,
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

