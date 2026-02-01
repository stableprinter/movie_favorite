import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  const Movie({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.releaseDate,
    this.voteAverage,
    this.voteCount,
  });

  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? releaseDate;
  final double? voteAverage;
  final int? voteCount;

  @override
  List<Object?> get props => [id, title, overview, posterPath, releaseDate, voteAverage, voteCount];
}
