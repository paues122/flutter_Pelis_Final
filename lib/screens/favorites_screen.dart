import 'package:flutter/material.dart';
import 'package:tap2025/models/popular_model.dart';
import 'package:tap2025/network/api_popular.dart';
import 'package:tap2025/screens/trailer_screen.dart';
import 'package:tap2025/utils/global_values.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  ApiPopular? apiPopular;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
  }

  Future<List<PopularModel>> _getFavoriteMovies() async {
    final allMovies = await apiPopular!.getPopularMovies();
    // Filtrar películas para incluir solo las que están en favoriteMovieIds
    return allMovies.where((movie) => GlobalValues.favoriteMovieIds.value.contains(movie.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Películas Favoritas")),
      body: ValueListenableBuilder<List<int>>(
        valueListenable: GlobalValues.favoriteMovieIds,
        builder: (context, favoriteIds, _) {
          if (favoriteIds.isEmpty) {
            return const Center(child: Text('No hay películas favoritas'));
          }

          return FutureBuilder<List<PopularModel>>(
            future: _getFavoriteMovies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay películas favoritas'));
              }

              final movies = snapshot.data!;

              return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Card(
                    child: Column(
                      children: [
                        Image.network(movie.backdropPath),
                        ListTile(
                          title: Text(movie.title),
                          subtitle: Text(
                            movie.overview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              // Quitar de favoritos
                              final updatedFavorites = List<int>.from(GlobalValues.favoriteMovieIds.value)
                                ..remove(movie.id);
                              GlobalValues.favoriteMovieIds.value = updatedFavorites;
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final trailerKey = await apiPopular!.getTrailerKey(movie.id);
                            if (trailerKey != null && context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TrailerScreen(youtubeKey: trailerKey),
                                ),
                              );
                            }
                          },
                          child: const Text("Ver Tráiler"),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}