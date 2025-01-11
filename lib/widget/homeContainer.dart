import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:screen_vibe/API/apikey.dart';
import 'package:screen_vibe/API/apilink.dart';
import 'package:screen_vibe/model/film.dart';
import 'package:screen_vibe/page/movie_page.dart';
import 'package:http/http.dart' as http;

class homeContainer extends StatefulWidget {
  final String title;
  final List<String>? movieIds; // Optional for user-specific lists

  const homeContainer({super.key, required this.title, this.movieIds});

  @override
  _homeContainerState createState() => _homeContainerState();
}

class _homeContainerState extends State<homeContainer> {
  List<Film> films = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.movieIds != null && widget.movieIds!.isNotEmpty) {
      fetchMoviesByIds();
    } else {
      fetchMoviesByCategory(widget.title);
    }
  }

  Future<void> fetchMoviesByIds() async {
    List<Film> fetchedFilms = [];
    for (var movieId in widget.movieIds!) {
      final Uri url = Uri.https(
        hostUrl,
        '/3/movie/$movieId',
        {"api_key": apikey},
      );
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          fetchedFilms.add(Film(
            title: data['title'] ?? 'Unknown',
            poster_path: data['poster_path'] ?? '',
            id: data['id'],
          ));
        }
      } catch (e) {
        print("Error fetching movie with ID $movieId: $e");
      }
    }

    setState(() {
      films = fetchedFilms;
      isLoading = false;
    });
  }

  Future<void> fetchMoviesByCategory(String category) async {
    String path;
    switch (category) {
      case "Popular":
        path = popularPathUrl;
        break;
      case "Now Playing":
        path = nowPlayingPathUrl;
        break;
      case "Top Rated":
        path = topRatedPathUrl;
        break;
      case "Upcoming":
        path = upcomingPathUrl;
        break;
      case "Recommendation":
        path = recommendationPathUrl;
        break;
      default:
        return;
    }

    final Uri url = Uri.https(
      hostUrl,
      path,
      {"api_key": apikey},
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          for (var eachFilm in jsonData['results']) {
            films.add(Film(
              title: eachFilm['title'] ?? 'Unknown',
              poster_path: eachFilm['poster_path'] ?? '',
              id: eachFilm['id'],
            ));
          }
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load films');
      }
    } catch (e) {
      print("Error fetching movies by category: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  displayFilmCard(List<Film> films)
  {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(65, 72, 75, 1.0),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            // Film Kartları
            Expanded(
              flex: 2,
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: films.map((film) {
                    return MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          film.isHovered = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          film.isHovered = false;
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MoviePage(
                                movieId: film.id.toString(),
                                username: 'YourUsername',
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: film.isHovered
                                      ? (film.isWatched
                                      ? Colors.green
                                      : Colors.white)
                                      : Colors.transparent,
                                  width: film.isHovered ? 3 : 0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              width: 120,
                              height: 200,
                              child: Stack(
                                children: [
                                  // Film Posteri
                                  Transform.scale(
                                    scale: film.isHovered ? 1.05 : 1.0,
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(8), // Köşeleri yuvarlat.
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.network(
                                          "https://image.tmdb.org/t/p/w600_and_h900_bestv2/${film.poster_path}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // İzlenme Durumu İkonu
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          film.isWatched = !film.isWatched;
                                        });
                                        addFilmDatabase(film);

                                      },
                                      icon: Icon(
                                        film.isWatched ? Icons.check_circle : Icons.add_circle_outline_rounded,
                                        color: film.isWatched ? Colors.green : Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  addFilmDatabase(Film film) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

        if (film.isWatched) {
          await userDoc.update({
            'filmList': FieldValue.arrayUnion([film.id]),
          });
        } else {
          await userDoc.update({
            'filmList': FieldValue.arrayRemove([film.id]),
          });
        }
      }
    } catch (e) {
      print('Error updating film list: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update film list')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movieIds != null) {
      return displayFilmCard(films);
    }

    switch (widget.title) {
      case "Popular":
        return displayFilmCard(films);
      case "Now Playing":
        return displayFilmCard(films);
      case "Top Rated":
        return displayFilmCard(films);
      case "Upcoming":
        return displayFilmCard(films);
      case "Recommendation":
        return displayFilmCard(films);
      default:
        return const Center(child: Text("Invalid category"));
    }
  }
}
