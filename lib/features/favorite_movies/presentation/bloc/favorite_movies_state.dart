import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';

sealed class FavoriteMoviesState extends Equatable {
  const FavoriteMoviesState();

  @override
  List<Object?> get props => [];
}

final class FavoriteMoviesInitial extends FavoriteMoviesState {
  const FavoriteMoviesInitial();
}

final class FavoriteMoviesLoading extends FavoriteMoviesState {
  const FavoriteMoviesLoading();
}

final class FavoriteMoviesLoaded extends FavoriteMoviesState {
  const FavoriteMoviesLoaded({
    required this.movies,
    required this.currentPage,
    required this.hasReachedMax,
    this.isLoadingMore = false,
  });

  final List<Movie> movies;
  final int currentPage;
  final bool hasReachedMax;
  final bool isLoadingMore;

  FavoriteMoviesLoaded copyWith({
    List<Movie>? movies,
    int? currentPage,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return FavoriteMoviesLoaded(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [movies, currentPage, hasReachedMax, isLoadingMore];
}

final class FavoriteMoviesError extends FavoriteMoviesState {
  const FavoriteMoviesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
