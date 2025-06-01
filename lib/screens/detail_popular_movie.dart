import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tap2025/models/actor_model.dart';
import 'package:tap2025/models/popular_model.dart';
import 'package:tap2025/network/api_popular.dart';
import 'package:tap2025/screens/trailer_screen.dart';

class DetailPopularMovie extends StatefulWidget {
  const DetailPopularMovie({super.key});

  @override
  State<DetailPopularMovie> createState() => _DetailPopularMovieState();
}

class _DetailPopularMovieState extends State<DetailPopularMovie> {
  ApiPopular apiPopular = ApiPopular();
  List<ActorModel> actors = [];

  @override
  void initState() {
    super.initState();
    _loadCast();
  }

  Future<void> _loadCast() async {
    final popular = ModalRoute.of(context)!.settings.arguments as PopularModel;
    try {
      final cast = await apiPopular.getMovieCast(popular.id);
      if (mounted) {
        setState(() {
          actors = cast;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar el elenco: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final popular = ModalRoute.of(context)!.settings.arguments as PopularModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(popular.title),
      ),
      body: Stack(
        children: [
          
          Positioned.fill(
            child: Image.network(
              'https://image.tmdb.org/t/p/w500/${popular.posterPath}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Hero(
                  tag: 'movie-poster-${popular.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      popular.backdropPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Center(child: Text('Imagen no disponible')),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                Text(
                  popular.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: popular.voteAverage / 2, 
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                      direction: Axis.horizontal,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${popular.voteAverage.toStringAsFixed(1)}/10',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
               
                Text(
                  popular.overview,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
               
                Text(
                  'Elenco',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: actors.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: actors.length,
                          itemBuilder: (context, index) {
                            final actor = actors[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: actor.profilePath != null
                                        ? NetworkImage(actor.profilePath!)
                                        : AssetImage('assets/placeholder_actor.png')
                                            as ImageProvider,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    actor.name,
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 30),
                
                Center(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.play_circle_fill),
                    label: Text("Ver tráiler"),
                    onPressed: () async {
                      final trailerKey = await apiPopular.getTrailerKey(popular.id);
                      if (trailerKey != null && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TrailerScreen(youtubeKey: trailerKey),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Tráiler no disponible")),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}