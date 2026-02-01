import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/api_constants.dart';
import 'core/native_call_service.dart';
import 'features/favorite_movies/injection.dart';
import 'features/favorite_movies/presentation/bloc/favorite_movies_bloc.dart';
import 'features/favorite_movies/presentation/pages/favorite_movies_page.dart';

/// Super-App Documentation:
/// [args]: [apiToken, accountId, baseUrl, appName, imageBaseUrl]
void _initFromSuperAppArgs(List<String> args) {
  ApiConstants.init(
    apiToken: args[0],
    accountId: args[1],
    baseUrl: args[2],
    appName: args[3],
    imageBaseUrl: args[4],
  );
}

@pragma('vm:entry-point')
void mainFavorite(List<String> args) {
  _initFromSuperAppArgs(args);

  final nativeCallService = NativeCallService();

  runApp(
    MaterialApp(
      home: BlocProvider<FavoriteMoviesBloc>(
        create: (_) => createFavoriteMoviesBloc(),
        child: FavoriteMoviesPage(
          onMovieTap: (movieId) {
            nativeCallService.navigateToMovieDetail(movieId);
          },
        ),
      ),
    ),
  );
}
