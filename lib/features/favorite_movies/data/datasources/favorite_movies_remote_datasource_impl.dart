import '../../../../core/api_client.dart';
import '../../../../core/api_constants.dart';
import '../models/movie_model.dart';
import 'favorite_movies_remote_datasource.dart';

class FavoriteMoviesRemoteDataSourceImpl
    implements FavoriteMoviesRemoteDataSource {
  FavoriteMoviesRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<MovieModel>> getFavoriteMovies(int page) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      '/account/${ApiConstants.instance.accountId}/favorite/movies',
      queryParameters: <String, dynamic>{
        'language': 'en-US',
        'page': page,
        'sort_by': 'created_at.desc',
      },
    );
    final data = response.data;
    if (data == null) return [];
    final results = data['results'] as List<dynamic>? ?? [];
    return results
        .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> toggleFavorite(int mediaId, bool favorite) async {
    await _apiClient.dio.post<Map<String, dynamic>>(
      '/account/${ApiConstants.instance.accountId}/favorite',
      data: <String, dynamic>{
        'media_type': 'movie',
        'media_id': mediaId,
        'favorite': favorite,
      },
    );
  }
}
