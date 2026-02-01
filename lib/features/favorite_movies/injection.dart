import '../../core/api_client.dart';
import '../../core/native_call_service.dart';
import 'data/datasources/favorite_movies_remote_datasource_impl.dart';
import 'data/repositories/favorite_movies_repository_impl.dart';
import 'domain/repositories/favorite_movies_repository.dart';
import 'domain/usecases/get_favorite_movies.dart';
import 'presentation/bloc/favorite_movies_bloc.dart';

/// Creates and returns [FavoriteMoviesRepository] for reuse.
FavoriteMoviesRepository createFavoriteMoviesRepository() {
  final apiClient = ApiClient();
  final datasource = FavoriteMoviesRemoteDataSourceImpl(apiClient);
  return FavoriteMoviesRepositoryImpl(datasource);
}

/// Builds ApiClient → datasource → repository → use case → bloc.
FavoriteMoviesBloc createFavoriteMoviesBloc() {
  final repository = createFavoriteMoviesRepository();
  final getFavoriteMovies = GetFavoriteMovies(repository);
  final nativeCallService = NativeCallService();
  return FavoriteMoviesBloc(getFavoriteMovies, nativeCallService);
}
