import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MoviePage extends StatefulWidget {
  final String movieId;
  final String username;

  const MoviePage({
    super.key,
    required this.movieId,
    required this.username,
  });

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final String apiKey = 'bbbbd36068dade744df4d8f1a6e04a06';
  Map<String, dynamic>? movieData;
  List<Map<String, String>> comments = [];
  final TextEditingController _commentController = TextEditingController();

  String? displayName;
  String? profilePhotoUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
    fetchComments();
    _loadUserData();
  }

  Future<void> fetchMovieDetails() async {
    final url =
        'https://api.themoviedb.org/3/movie/${widget.movieId}?api_key=$apiKey&language=en-US';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          movieData = json.decode(response.body);
        });
      } else {
        print('Failed to fetch movie details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching movie details: $e');
    }
  }
  Future<void> _loadUserData() async {
    User? currentUser = _auth.currentUser;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.uid)
        .get();

    if (currentUser != null) {
      setState(() {
        displayName = currentUser.displayName ?? "Guest";
        profilePhotoUrl = userDoc['profilePhoto'] ??
            "https://static.vecteezy.com/system/resources/thumbnails/008/442/086/small/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg";

      });
      print("Logged-in user's name: $displayName");

    } else {
      print("No user is currently logged in.");
      setState(() {
        displayName = "No user logged in";
        profilePhotoUrl = userDoc['profilePhoto'] ??
            "https://static.vecteezy.com/system/resources/thumbnails/008/442/086/small/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg";
      });
    }
  }
  Future<void> fetchComments() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('comments')
          .where('movieId', isEqualTo: widget.movieId)
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        comments = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'username': data['username']?.toString() ?? 'Guest',
            'comment': data['comment']?.toString() ?? '',
            'profilePhotoUrl': data['profilePhotoUrl']?.toString() ?? '', // Add photoURL
          };
        }).toList().cast<Map<String, String>>();
      });
    } catch (e) {
      print("Error fetching comments: $e");
    }
  }

  void addComment(String comment) async {
    try {
      final newComment = {
        'username': displayName ?? 'Guest',
        'comment': comment,
        'movieId': widget.movieId,
        'timestamp': FieldValue.serverTimestamp(),
        'profilePhotoUrl':profilePhotoUrl
      };

      await FirebaseFirestore.instance.collection('comments').add(newComment);

      setState(() {
        comments.add({
          'username': displayName ?? 'Guest',
          'comment': comment,
          'movieId': widget.movieId
        });
        _commentController.clear();
      });

      print("Comment added to Firestore!");
    } catch (e) {
      print("Error adding comment to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          movieData != null ? movieData!['title'] ?? 'Movie' : 'Loading...',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: movieData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (movieData!['poster_path'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w300${movieData!['poster_path']}',
                        width: 150,
                        height: 225,
                        fit: BoxFit.cover,
                      ),
                    ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movieData!['title'] ?? '',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber),
                            SizedBox(width: 4),
                            Text(
                              movieData!['vote_average']?.toString() ??
                                  'N/A',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Genres: ${movieData!['genres'] != null ? (movieData!['genres'] as List).map((genre) => genre['name']).join(', ') : 'N/A'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Description:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          movieData!['overview'] ??
                              'No description available',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Write a Comment:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _commentController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Comment',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (_commentController.text.trim().isNotEmpty) {
                    addComment(_commentController.text.trim());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                child: Text('Post Comment'),
              ),
              SizedBox(height: 16),
              Text(
                'Comments:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              ...comments.map((comment) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: comment['profilePhotoUrl'] != null && comment['profilePhotoUrl']!.isNotEmpty
                          ? NetworkImage(comment['profilePhotoUrl']!)
                          : const NetworkImage(
                        'https://static.vecteezy.com/system/resources/thumbnails/008/442/086/small/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg',
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment['username']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          comment['comment']!,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),]
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
