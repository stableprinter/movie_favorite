import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/event_channel_service.dart';
import '../bloc/favorite_movies_bloc.dart';
import '../bloc/favorite_movies_event.dart';
import '../bloc/favorite_movies_state.dart';
import '../widgets/favorite_movie_item.dart';

class FavoriteMoviesPage extends StatefulWidget {
  const FavoriteMoviesPage({
    super.key,
    required this.onMovieTap,
  });

  final void Function(int movieId) onMovieTap;

  @override
  State<FavoriteMoviesPage> createState() => _FavoriteMoviesPageState();
}

class _FavoriteMoviesPageState extends State<FavoriteMoviesPage> {
  final ScrollController _scrollController = ScrollController();
  final EventChannelService _eventChannelService = EventChannelService();
  StreamSubscription<void>? _toggleFavoriteSubscription;

  @override
  void initState() {
    super.initState();
    context.read<FavoriteMoviesBloc>().add(const LoadFavoriteMovies());
    _scrollController.addListener(_onScroll);
    _toggleFavoriteSubscription = _eventChannelService.onToggleFavoriteStream.listen((_) {
      if (mounted) {
        context.read<FavoriteMoviesBloc>().add(const RefreshFavoriteMovies());
      }
    });
  }

  @override
  void dispose() {
    _toggleFavoriteSubscription?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bloc = context.read<FavoriteMoviesBloc>();
    final state = bloc.state;
    if (state is! FavoriteMoviesLoaded) return;
    if (state.hasReachedMax || state.isLoadingMore) return;

    final position = _scrollController.position;
    final extent = position.maxScrollExtent;
    if (extent <= 0) return;
    final ratio = position.pixels / extent;
    if (ratio >= 0.9) {
      bloc.add(const LoadMoreFavoriteMovies());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorite Movies'),
      ),
      body: BlocBuilder<FavoriteMoviesBloc, FavoriteMoviesState>(
        builder: (context, state) {
          if (state is FavoriteMoviesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FavoriteMoviesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        context
                            .read<FavoriteMoviesBloc>()
                            .add(const LoadFavoriteMovies());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is FavoriteMoviesLoaded && state.movies.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No favorite movies yet',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start adding movies to your favorites!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is FavoriteMoviesLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<FavoriteMoviesBloc>()
                    .add(const RefreshFavoriteMovies());
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.movies.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.movies.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final movie = state.movies[index];
                  return FavoriteMovieItem(
                    movie: movie,
                    onTap: widget.onMovieTap,
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
