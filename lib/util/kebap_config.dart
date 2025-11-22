class KebapConfig {
  static KebapConfig _instance = KebapConfig._();
  KebapConfig._();

  static String? get baseUrl => _instance._baseUrl;
  static set baseUrl(String? value) => _instance._baseUrl = value;
  String? _baseUrl;

  static void fromJson(Map<String, dynamic> json) => _instance = KebapConfig._fromJson(json);

  factory KebapConfig._fromJson(Map<String, dynamic> json) {
    final config = KebapConfig._();
    final newUrl = json['baseUrl'] as String?;
    config._baseUrl = newUrl?.isEmpty == true ? null : newUrl;
    return config;
  }
}
