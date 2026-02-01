import 'package:flutter/services.dart';

/// Service for native platform communication via MethodChannel.
class NativeCallService {
  NativeCallService({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('com.movie.android/channel');

  final MethodChannel _channel;

  /// Invokes native navigation to movie detail screen.
  Future<void> navigateToMovieDetail(int movieId) {
    return _channel.invokeMethod('navigateToMovieDetail', movieId);
  }

  /// Broadcasts list of favorite movie IDs to native platform (MovieAndroid: broadcastFavList).
  Future<void> broadcastFavoriteMovieIds(List<int> movieIds) {
    return _channel.invokeMethod('broadcastFavList', movieIds);
  }
}
