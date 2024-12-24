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

  @override
  Widget build(BuildContext context) {
    //POPULAR MOVIE
    if(widget.title=="Popular")
    {
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoviePage(
                              movieId: '22', // Ensure you pass the correct type for movieId
                              username: 'YourUsername', // Replace with the actual username or pass dynamically
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey,
                            borderRadius: BorderRadiusDirectional.circular(5),
                          ),
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Image.network(
                              "https://image.tmdb.org/t/p/w600_and_h900_bestv2/${film.poster_path}",
                              fit: BoxFit.cover,
                            ),
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
    if(widget.title=="Now Playing")
    {
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
                  children: nowPlayingFilms.map((film) {
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
    if(widget.title=="Top Rated")
    {
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
                  children: topRatedFilms.map((film) {
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
    if(widget.title=="Upcoming")
    {
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
                  children: upcomingFilms.map((film) {
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
    if(widget.title=="Recommendation")
    {
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
                  children: recommendationFilms.map((film) {
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
  }}
}
