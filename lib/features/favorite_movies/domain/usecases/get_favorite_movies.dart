import '../entities/movie.dart';
import '../repositories/favorite_movies_repository.dart';

class GetFavoriteMovies {
  GetFavoriteMovies(this._repository);

  final FavoriteMoviesRepository _repository;

  Future<List<Movie>> call(int page) => _repository.getFavoriteMovies(page);
}
