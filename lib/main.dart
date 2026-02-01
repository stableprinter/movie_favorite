import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/api_constants.dart';
import 'core/native_call_service.dart';
import 'features/favorite_movies/injection.dart';
import 'features/favorite_movies/presentation/bloc/favorite_movies_bloc.dart';
import 'features/favorite_movies/presentation/pages/favorite_movies_page.dart';

@pragma('vm:entry-point')
/// Super-App Documentation:
/// First array of arguments is the API token
/// Second array of arguments is the account ID
void mainFavorite(List<String> args) {
  final apiToken = args.first;
  final accountId = args[1];

  ApiConstants.init(apiToken: apiToken, accountId: accountId);

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
