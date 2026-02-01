import '../../../../core/api_constants.dart';
import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    super.overview,
    super.posterPath,
    super.releaseDate,
    super.voteAverage,
    super.voteCount,
  });

  String? get posterUrl =>
      posterPath != null ? '${ApiConstants.instance.imageBaseUrl}$posterPath' : null;

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
    );
  }

  Movie toEntity() => Movie(
        id: id,
        title: title,
        overview: overview,
        posterPath: posterPath,
        releaseDate: releaseDate,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );
}
