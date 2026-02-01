import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/native_call_service.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_favorite_movies.dart';
import 'favorite_movies_event.dart';
import 'favorite_movies_state.dart';

class FavoriteMoviesBloc extends Bloc<FavoriteMoviesEvent, FavoriteMoviesState> {
  FavoriteMoviesBloc(
    this._getFavoriteMovies,
    this._nativeCallService,
  ) : super(const FavoriteMoviesInitial()) {
    on<LoadFavoriteMovies>(_onLoadFavoriteMovies);
    on<LoadMoreFavoriteMovies>(_onLoadMoreFavoriteMovies);
    on<RefreshFavoriteMovies>(_onRefreshFavoriteMovies);
  }

  final GetFavoriteMovies _getFavoriteMovies;
  final NativeCallService _nativeCallService;

  Future<void> _onLoadFavoriteMovies(
    LoadFavoriteMovies event,
    Emitter<FavoriteMoviesState> emit,
  ) async {
    emit(const FavoriteMoviesLoading());
    await _fetchPage(emit, 1, []);
  }

  Future<void> _onLoadMoreFavoriteMovies(
    LoadMoreFavoriteMovies event,
    Emitter<FavoriteMoviesState> emit,
  ) async {
    final current = state;
    if (current is! FavoriteMoviesLoaded) return;
    if (current.hasReachedMax || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));
    await _fetchPage(
      emit,
      current.currentPage + 1,
      List<Movie>.from(current.movies),
    );
  }

  Future<void> _onRefreshFavoriteMovies(
    RefreshFavoriteMovies event,
    Emitter<FavoriteMoviesState> emit,
  ) async {
    await _fetchPage(emit, 1, []);
  }

  Future<void> _fetchPage(
    Emitter<FavoriteMoviesState> emit,
    int page,
    List<Movie> existingMovies,
  ) async {
    try {
      final newMovies = await _getFavoriteMovies(page);
      final allMovies = page == 1 ? newMovies : [...existingMovies, ...newMovies];
      final hasReachedMax = newMovies.length < 20;

      emit(FavoriteMoviesLoaded(
        movies: allMovies,
        currentPage: page,
        hasReachedMax: hasReachedMax,
        isLoadingMore: false,
      ));

      // Broadcast all favorite movie IDs to native platform
      final movieIds = allMovies.map((movie) => movie.id).toList();
      await _nativeCallService.broadcastFavoriteMovieIds(movieIds);
    } catch (e, st) {
      if (existingMovies.isNotEmpty) {
        emit(FavoriteMoviesLoaded(
          movies: existingMovies,
          currentPage: page > 1 ? page - 1 : 1,
          hasReachedMax: false,
          isLoadingMore: false,
        ));
      }
      emit(FavoriteMoviesError(e.toString()));
      // ignore: avoid_print
      print(st);
    }
  }
}
