
import 'package:flutter/material.dart';
import 'package:tap2025/models/popular_model.dart';
import 'package:tap2025/network/api_popular.dart';
import 'package:tap2025/screens/trailer_screen.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({super.key});

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  ApiPopular? apiPopular;
  List<int> favoriteMovieIds = [];

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Películas Populares")),
      body: FutureBuilder<List<PopularModel>>(
        future: apiPopular!.getPopularMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos'));
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
                      subtitle: Text(movie.overview, maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: IconButton(
                        icon: Icon(
                          favoriteMovieIds.contains(movie.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            if (favoriteMovieIds.contains(movie.id)) {
                              favoriteMovieIds.remove(movie.id);
                            } else {
                              favoriteMovieIds.add(movie.id);
                            }
                          });
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
                      child: Text("Ver Tráiler"),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
