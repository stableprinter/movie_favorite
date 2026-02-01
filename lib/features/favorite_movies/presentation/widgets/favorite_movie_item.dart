import 'package:flutter/material.dart';

import '../../../../core/api_constants.dart';
import '../../domain/entities/movie.dart';

class FavoriteMovieItem extends StatelessWidget {
  const FavoriteMovieItem({
    super.key,
    required this.movie,
    required this.onTap,
  });

  final Movie movie;
  final void Function(int movieId) onTap;

  String? get _posterUrl =>
      movie.posterPath != null
          ? '${ApiConstants.instance.imageBaseUrl}${movie.posterPath}'
          : null;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onTap(movie.id),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Poster(url: _posterUrl),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (movie.releaseDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        movie.releaseDate!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                    if (movie.voteAverage != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            movie.voteAverage!.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (movie.voteCount != null) ...[
                            Text(
                              ' (${movie.voteCount})',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ],
                    if (movie.overview != null && movie.overview!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        movie.overview!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 12),
              child: Icon(
                Icons.favorite,
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4),
        bottomLeft: Radius.circular(4),
      ),
      child: Image.network(
        url ?? '',
        width: 100,
        height: 150,
        fit: BoxFit.cover,
        errorBuilder: (_, error, stackTrace) => Container(
          width: 100,
          height: 150,
          color: Colors.grey.shade300,
          child: Icon(
            Icons.movie_outlined,
            size: 48,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
