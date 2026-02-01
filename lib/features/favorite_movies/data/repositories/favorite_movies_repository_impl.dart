import '../../domain/entities/movie.dart';
import '../../domain/repositories/favorite_movies_repository.dart';
import '../datasources/favorite_movies_remote_datasource.dart';
import '../models/movie_model.dart';

class FavoriteMoviesRepositoryImpl implements FavoriteMoviesRepository {
  FavoriteMoviesRepositoryImpl(this._remoteDataSource);

  final FavoriteMoviesRemoteDataSource _remoteDataSource;

  @override
  Future<List<Movie>> getFavoriteMovies(int page) async {
    final models = await _remoteDataSource.getFavoriteMovies(page);
    return models.map((MovieModel m) => m.toEntity()).toList();
  }

  @override
  Future<void> toggleFavorite(int mediaId, bool favorite) =>
      _remoteDataSource.toggleFavorite(mediaId, favorite);
}
