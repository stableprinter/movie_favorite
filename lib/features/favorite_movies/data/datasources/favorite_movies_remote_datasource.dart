import '../models/movie_model.dart';

abstract class FavoriteMoviesRemoteDataSource {
  Future<List<MovieModel>> getFavoriteMovies(int page);
  Future<void> toggleFavorite(int mediaId, bool favorite);
}
