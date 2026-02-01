/// TMDB API configuration singleton. Call [init] once before use.
class ApiConstants {
  ApiConstants._();

  static ApiConstants? _instance;
  static ApiConstants get instance {
    final i = _instance;
    if (i == null) {
      throw StateError('ApiConstants not initialized. Call ApiConstants.init() first.');
    }
    return i;
  }

  /// Initialize the singleton. Call once at app startup.
  static void init({
    required String apiToken,
    required String accountId,
    String baseUrl = 'https://api.themoviedb.org/3',
    String imageBaseUrl = 'https://image.tmdb.org/t/p/w500',
  }) {
    _instance = ApiConstants._()
      .._apiToken = apiToken
      .._accountId = accountId
      .._baseUrl = baseUrl
      .._imageBaseUrl = imageBaseUrl;
  }

  late final String _apiToken;
  late final String _accountId;
  late final String _baseUrl;
  late final String _imageBaseUrl;

  String get apiToken => _apiToken;
  String get accountId => _accountId;
  String get baseUrl => _baseUrl;
  String get imageBaseUrl => _imageBaseUrl;
}
