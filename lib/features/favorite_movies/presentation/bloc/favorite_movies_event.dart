import 'package:equatable/equatable.dart';

sealed class FavoriteMoviesEvent extends Equatable {
  const FavoriteMoviesEvent();

  @override
  List<Object?> get props => [];
}

final class LoadFavoriteMovies extends FavoriteMoviesEvent {
  const LoadFavoriteMovies();
}

final class LoadMoreFavoriteMovies extends FavoriteMoviesEvent {
  const LoadMoreFavoriteMovies();
}

final class RefreshFavoriteMovies extends FavoriteMoviesEvent {
  const RefreshFavoriteMovies();
}
