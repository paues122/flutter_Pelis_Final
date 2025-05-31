import 'package:flutter/material.dart';
import 'package:tap2025/models/popular_model.dart';
import 'package:tap2025/network/api_popular.dart';
import 'package:tap2025/screens/trailer_screen.dart'; // asegúrate de crear esta pantalla

class DetailPopularMovie extends StatefulWidget {
  const DetailPopularMovie({super.key});

  @override
  State<DetailPopularMovie> createState() => _DetailPopularMovieState();
}

class _DetailPopularMovieState extends State<DetailPopularMovie> {
  ApiPopular apiPopular = ApiPopular();

  @override
  Widget build(BuildContext context) {
    final popular = ModalRoute.of(context)!.settings.arguments as PopularModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(popular.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(popular.backdropPath),
            ),
            const SizedBox(height: 20),

            // Título
            Text(
              popular.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Descripción
            Text(
              popular.overview,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            // Botón para ver tráiler
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.play_circle_fill),
                label: Text("Ver tráiler"),
                onPressed: () async {
                  final trailerKey = await apiPopular.getTrailerKey(popular.id);

                  if (trailerKey != null) {
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
    );
  }
}
