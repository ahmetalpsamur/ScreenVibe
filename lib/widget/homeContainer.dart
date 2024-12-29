import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:screen_vibe/API/apikey.dart';
import 'package:screen_vibe/API/apilink.dart';
import 'package:screen_vibe/model/film.dart';
import 'package:screen_vibe/page/movie_page.dart';
import 'package:screen_vibe/page/home_page.dart';
import 'package:http/http.dart' as http;

class homeContainer extends StatefulWidget {
  final String title;

  homeContainer({super.key, required this.title});

  @override
  _homeContainerState createState() => _homeContainerState();
}

class _homeContainerState extends State<homeContainer> {
  List<Film> popularFilms = [];
  List<Film> nowPlayingFilms = [];
  List<Film> topRatedFilms = [];
  List<Film> upcomingFilms = [];
  List<Film> recommendationFilms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPopularFilms();
    getNowPlayingFilms();
    getTopRatedFilms();
    getUpcomingFilms();
    getRecommendationFilms();
  }

  Future<void> getPopularFilms() async {
    final Uri url = Uri.https(
      hostUrl, // Host
      popularPathUrl, // Path
      {"api_key": apikey}, // Query parameters
    );

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          for (var eachFilm in jsonData['results']) {
            final film = Film(
              title: eachFilm['title'],
              poster_path: eachFilm['poster_path'],
              id: eachFilm['id']
            );
            popularFilms.add(film);
          }
          isLoading = false; // Data is loaded, set isLoading to false
        });
      } else {
        throw Exception('Failed to load films');
      }
    } catch (e) {
      print("An error occurred: $e");
      setState(() {
        isLoading = false; // Handle error, stop loading
      });
    }
  }
  Future<void> getNowPlayingFilms() async {
    final Uri url = Uri.https(
      hostUrl, // Host
      nowPlayingPathUrl, // Path
      {"api_key": apikey}, // Query parameters
    );

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          for (var eachFilm in jsonData['results']) {
            final film = Film(
              title: eachFilm['title'],
              poster_path: eachFilm['poster_path'],
                id: eachFilm['id']
            );
            nowPlayingFilms.add(film);
          }
          isLoading = false; // Data is loaded, set isLoading to false
        });
      } else {
        throw Exception('Failed to load films');
      }
    } catch (e) {
      print("An error occurred: $e");
      setState(() {
        isLoading = false; // Handle error, stop loading
      });
    }
  }
  Future<void> getTopRatedFilms() async {
    final Uri url = Uri.https(
      hostUrl, // Host
      topRatedPathUrl, // Path
      {"api_key": apikey}, // Query parameters
    );

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          for (var eachFilm in jsonData['results']) {
            final film = Film(
              title: eachFilm['title'],
              poster_path: eachFilm['poster_path'],
                id: eachFilm['id']
            );
            topRatedFilms.add(film);
          }
          isLoading = false; // Data is loaded, set isLoading to false
        });
      } else {
        throw Exception('Failed to load films');
      }
    } catch (e) {
      print("An error occurred: $e");
      setState(() {
        isLoading = false; // Handle error, stop loading
      });
    }
  }
  Future<void> getUpcomingFilms() async {
    final Uri url = Uri.https(
      hostUrl, // Host
      upcomingPathUrl, // Path
      {"api_key": apikey}, // Query parameters
    );

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          for (var eachFilm in jsonData['results']) {
            final film = Film(
              title: eachFilm['title'],
              poster_path: eachFilm['poster_path'],
                id: eachFilm['id']
            );
            upcomingFilms.add(film);
          }
          isLoading = false; // Data is loaded, set isLoading to false
        });
      } else {
        throw Exception('Failed to load films');
      }
    } catch (e) {
      print("An error occurred: $e");
      setState(() {
        isLoading = false; // Handle error, stop loading
      });
    }
  }
  Future<void> getRecommendationFilms() async {
    final Uri url = Uri.https(
      hostUrl, // Host
      recommendationPathUrl, // Path
      {"api_key": apikey}, // Query parameters
    );

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          for (var eachFilm in jsonData['results']) {
            final film = Film(
              title: eachFilm['title'],
              poster_path: eachFilm['poster_path'],
                id: eachFilm['id']
            );
            recommendationFilms.add(film);
          }
          isLoading = false; // Data is loaded, set isLoading to false
        });
      } else {
        throw Exception('Failed to load films');
      }
    } catch (e) {
      print("An error occurred: $e");
      setState(() {
        isLoading = false; // Handle error, stop loading
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
                                      onPressed: () {
                                        setState(() {
                                          film.isWatched =
                                          !film.isWatched;
                                        });
                                      },
                                      icon: Icon(
                                        film.isWatched
                                            ? Icons.check_circle
                                            : Icons
                                            .add_circle_outline_rounded,
                                        color: film.isWatched
                                            ? Colors.green
                                            : Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  )
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

  @override
  Widget build(BuildContext context) {

    //POPULAR MOVIE
    if(widget.title=="Popular")
    {
      return displayFilmCard(popularFilms);
    }
    if(widget.title=="Now Playing")
    {
      return displayFilmCard(nowPlayingFilms);

    }
    if(widget.title=="Top Rated")
    {
      return displayFilmCard(topRatedFilms);
    }
    if(widget.title=="Upcoming")
    {
     return displayFilmCard(upcomingFilms);

    }
    if (widget.title == "Recommendation") {
     return displayFilmCard(recommendationFilms);
    }
    else{
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: const Color.fromRGBO(65, 72, 75, 1.0),
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 40,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
                scrollDirection: Axis.horizontal,
                children: popularFilms.map((film) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey,
                          borderRadius:
                          BorderRadiusDirectional.circular(5)),
                      width: 100,
                      child: Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Image.network(
                          "https://image.tmdb.org/t/p/w600_and_h900_bestv2/${film.poster_path}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  }
}
