/// TMDB API configuration singleton. Call [init] once before use.
class ApiConstants {
  ApiConstants._();

  static ApiConstants? _instance;
  static ApiConstants get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'ApiConstants not initialized. Call ApiConstants.init() first.',
      );
    }
    return i;
  }

  /// Initialize the singleton. Call once at app startup.
  static void init({
    required String apiToken,
    required String accountId,
    required String baseUrl,
    required String appName,
    required String imageBaseUrl,
    required String brandFontFamily,
  }) {
    _instance = ApiConstants._()
      .._apiToken = apiToken
      .._accountId = accountId
      .._baseUrl = baseUrl
      .._appName = appName
      .._imageBaseUrl = imageBaseUrl
      .._brandFontFamily = brandFontFamily;
  }

  late final String _apiToken;
  late final String _accountId;
  late final String _baseUrl;
  late final String _imageBaseUrl;
  late final String _brandFontFamily;
  late final String _appName;
  String get apiToken => _apiToken;
  String get accountId => _accountId;
  String get baseUrl => _baseUrl;
  String get imageBaseUrl => _imageBaseUrl;
  String get appName => _appName;
  String get brandFontFamily => _brandFontFamily;
}
