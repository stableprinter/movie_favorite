import 'package:dio/dio.dart';

import 'api_constants.dart';

/// Dio wrapper with baseUrl, timeouts, auth and logging interceptors.
/// Uses [ApiConstants.instance] for configuration.
class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    final constants = ApiConstants.instance;
    _dio
      ..options.baseUrl = constants.baseUrl
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.sendTimeout = const Duration(seconds: 30)
      ..interceptors.addAll([
        _AuthInterceptor(constants.apiToken),
        _LoggingInterceptor(),
      ]);
  }

  final Dio _dio;

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._token);

  final String _token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $_token';
    handler.next(options);
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ignore: avoid_print
    print('[Dio] REQUEST: ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // ignore: avoid_print
    print('[Dio] RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print('[Dio] ERROR: ${err.type} ${err.message} ${err.requestOptions.uri}');
    handler.next(err);
  }
}
