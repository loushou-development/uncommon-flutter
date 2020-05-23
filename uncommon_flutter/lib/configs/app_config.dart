enum Environment {
  Production,
  Staging,
  Development,
}

class AppConfig {
  factory AppConfig() => _instance;

  AppConfig._internal();

  static final AppConfig _instance = AppConfig._internal();

  Environment _environment;
  String _apiBaseUrl;
  String _apiKey;

  Environment get environment => _environment;
  String get apiBaseUrl => _apiBaseUrl;
  String get apiKey => _apiKey;

  void setConfig({
    Environment environment,
    String apiBaseUrl,
    String apiKey,
  }) {
    _environment = environment ?? _environment;
    _apiBaseUrl = apiBaseUrl ?? _apiBaseUrl;
    _apiKey = apiKey ?? _apiKey;
  }
}
