import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class profileSection extends StatefulWidget {
  const profileSection({super.key});

  @override
  State<profileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<profileSection> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? displayName;
  int? filmsWatched;
  List<String>? filmList;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }


  Future<void> _loadUserData() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      setState(() {
        displayName = currentUser.displayName ?? "Guest";
      });
      print("Logged-in user's name: $displayName");


      int? films = await getFilmsWatched();
      List<String>? filmsList = await getFilmList();
      setState(() {
        filmsWatched = films;
        filmList = filmsList;
      });
    } else {
      print("No user is currently logged in.");
      setState(() {
        displayName = "No user logged in";
        filmsWatched = 0;
        filmList = [];
      });
    }
  }

  Future<int?> getFilmsWatched() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {

        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {

          int filmsWatched = userDoc['filmList']?.length ?? 0;
          return filmsWatched;
        } else {
          print("User document does not exist.");
          return 0;
        }
      } catch (e) {
        print("Error fetching films_watched: $e");
        return null;
      }
    } else {
      print("No user is logged in.");
      return null;
    }
  }


  Future<List<String>?> getFilmList() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {

        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {

          List<String> films = List<String>.from(userDoc['filmList'] ?? []);
          return films;
        } else {
          print("User document does not exist.");
          return [];
        }
      } catch (e) {
        print("Error fetching filmList: $e");
        return null;
      }
    } else {
      print("No user is logged in.");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.orange,
          height: 120,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const Image(
                image: NetworkImage(
                    "https://t4.ftcdn.net/jpg/04/97/86/15/360_F_497861573_EX9cjKXjVLBhbHrawjVK8M3BthLDS5lE.jpg"),
                fit: BoxFit.fill,
              ),
              const Padding(
                padding: EdgeInsets.all(2),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        "https://image.tmdb.org/t/p/w600_and_h900_bestv2/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                displayName ?? "No name available",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Write a description for you!",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                "Films Watched: ${filmsWatched ?? 0}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Text(
                "Film List: ${filmList?.join(', ') ?? 'No films watched'}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
