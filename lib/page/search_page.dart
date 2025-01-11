import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool isLoading = false;
  List<Film> searchFilms = [];
  String userQuery = '';
  String? selectedList;
  Map<String, dynamic> movieLists = {};

  @override
  void initState() {
    super.initState();
    _loadUserMovieLists();
  }

  Future<void> _loadUserMovieLists() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          movieLists = Map<String, dynamic>.from(doc['movieLists'] ?? {});
          if (movieLists.isNotEmpty) {
            selectedList = movieLists.keys.first;
          }
        });
      }
    }
  }

  Future<void> getSearchFilm() async {
    setState(() {
      isLoading = true;
    });

    final Uri url = Uri.https(
      hostUrl,
      searchPathUrl,
      {"query": userQuery, "api_key": apikey},
    );

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          searchFilms.clear();
          for (var eachFilm in jsonData['results']) {
            final film = Film(
              title: eachFilm['title'] ?? 'Not Found',
              poster_path: eachFilm['poster_path'] ?? notFoundFilmPoster,
              id: eachFilm['id'] ?? 0,
            );
            searchFilms.add(film);
          }
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load films');
      }
    } catch (e) {
      print("An error occurred: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addToMovieList(String movieId) async {
    if (selectedList == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

      await docRef.update({
        'movieLists.$selectedList': FieldValue.arrayUnion([movieId]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Movie added to $selectedList')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Search Movies', style: TextStyle(color: Colors.white)),
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
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search for a movie...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                ),
                onChanged: (value) {
                  userQuery = value;
                },
              ),
            ),

            const SizedBox(height: 20),

            // Search Button
            Center(
              child: ElevatedButton(
                onPressed: getSearchFilm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Search',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Dropdown for selecting movie list
            if (movieLists.isNotEmpty)
              DropdownButton<String>(
                value: selectedList,
                onChanged: (value) {
                  setState(() {
                    selectedList = value;
                  });
                },
                items: movieLists.keys.map<DropdownMenuItem<String>>((listName) {
                  return DropdownMenuItem<String>(
                    value: listName,
                    child: Text(listName),
                  );
                }).toList(),
              ),

            const SizedBox(height: 20),

            // Display Search Results
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : searchFilms.isEmpty
                  ? Center(
                child: Text(
                  'No results found.',
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
                    trailing: IconButton(
                      icon: const Icon(Icons.add, color: Colors.blue),
                      onPressed: () => _addToMovieList(film.id.toString()),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoviePage(
                            movieId: film.id.toString(),
                            username: 'YourUsername', // Replace with the actual username if needed
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
