import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:screen_vibe/API/apikey.dart';
import 'package:screen_vibe/API/apilink.dart';
import 'package:http/http.dart' as http;
import 'package:screen_vibe/model/film.dart';
import 'package:screen_vibe/page/movie_page.dart';

class search_page extends StatefulWidget {
  const search_page({super.key});

  @override
  State<search_page> createState() => _search_pageState();
}

class _search_pageState extends State<search_page> {
  bool isLoading = true;
  List<Film> searchFilms = [];
  String userQuery='';
  Future<void> getSearchFilm() async {
    final Uri url = Uri.https(
      hostUrl, // Host
      searchPathUrl, // Path
      {"query": userQuery,"api_key": apikey}, // Query parameters
    );
    print(url);

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          searchFilms.clear();
          for (var eachFilm in jsonData['results']) {
            final film = Film(
              title: eachFilm['title'] ?? 'Not Found', // Varsayılan değer
              poster_path: eachFilm['poster_path'] ?? notFoundFilmPoster, // Varsayılan değer
              id: eachFilm['id'] ?? 0, // Varsayılan değer
            );
            searchFilms.add(film);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Film Ara', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Film veya dizi ara...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                ),
                onChanged: (value) {
                  // Arama işlemi için gerekli kodlar
                  userQuery=value;
                },
              ),
            ),

            const SizedBox(height: 20),

            // Search Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Arama butonuna tıklandığında yapılacak işlemler
                  getSearchFilm();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Ara',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Results Section (placeholder)
            Expanded(
              child: isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : searchFilms.isEmpty
                  ? Center(
                child: Text(
                  'Sonuç bulunamadı.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
                  : ListView.builder(
                itemCount: searchFilms.length,
                itemBuilder: (context, index) {
                  final film = searchFilms[index];
                  return ListTile(
                    leading: Image.network(
                      "https://image.tmdb.org/t/p/w92/${film.poster_path}",
                      fit: BoxFit.cover,
                      width: 50,
                      height: 75,
                    ),
                    title: Text(film.title),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoviePage(
                            movieId: film.id.toString(),
                            username: 'YourUsername', // Replace dynamically
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
