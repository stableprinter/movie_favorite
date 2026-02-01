import 'package:flutter/services.dart';

/// EventChannel name. Must match [com.movie.android.Constants.EventChannel.NAME].
const String _eventChannelName = 'com.movie.android/events';

/// Listens to native EventChannel events (e.g. onToggleFavorite from MovieAndroid).
/// When the Browse module toggles a favorite, native sends event via map protocol:
/// {"method": "onToggleFavorite", "param": ...}
/// to the Favorite engine so this page can reload the list.
class EventChannelService {
  EventChannelService() : _channel = const EventChannel(_eventChannelName);

  final EventChannel _channel;

  /// Stream that emits when native sends "onToggleFavorite" (user toggled favorite from Browse).
  /// Subscribe in the page; cancel when the page is disposed.
  Stream<void> get onToggleFavoriteStream {
    return _channel.receiveBroadcastStream().where(_isOnToggleFavorite).map((_) {});
  }

  /// Checks if the event is an "onToggleFavorite" event.
  /// Native sends events as Map: {"method": "...", "param": ...}
  static bool _isOnToggleFavorite(dynamic value) {
    print('fav event channel value: $value');
    if (value is Map) {
      return value['method'] == 'shouldReloadFavorite';
    }
    return false;
  }
}
