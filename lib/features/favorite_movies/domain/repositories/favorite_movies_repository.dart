import '../entities/movie.dart';

abstract class FavoriteMoviesRepository {
  Future<List<Movie>> getFavoriteMovies(int page);
  Future<void> toggleFavorite(int mediaId, bool favorite);
}
