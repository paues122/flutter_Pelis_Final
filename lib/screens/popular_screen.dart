import 'package:flutter/material.dart';
import 'package:tap2025/models/popular_model.dart';
import 'package:tap2025/network/api_popular.dart';
import 'package:tap2025/screens/trailer_screen.dart';
import 'package:tap2025/utils/global_values.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({super.key});

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  ApiPopular? apiPopular;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Películas Populares")),
      body: FutureBuilder<List<PopularModel>>(
        future: apiPopular!.getPopularMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos'));
          }

          final movies = snapshot.data!;

          return ValueListenableBuilder<List<int>>(
            valueListenable: GlobalValues.favoriteMovieIds,
            builder: (context, favoriteIds, _) {
              return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Card(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: movie,
                            );
                          },
                          child: Hero(
                            tag: 'movie-poster-${movie.id}',
                            child: Image.network(movie.backdropPath),
                          ),
                        ),
                        ListTile(
                          title: Text(movie.title),
                          subtitle: Text(
                            movie.overview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              favoriteIds.contains(movie.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              final updatedFavorites = List<int>.from(favoriteIds);
                              if (updatedFavorites.contains(movie.id)) {
                                updatedFavorites.remove(movie.id);
                              } else {
                                updatedFavorites.add(movie.id);
                              }
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