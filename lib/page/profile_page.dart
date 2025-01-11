import 'package:flutter/material.dart';
import 'package:screen_vibe/widget/homeContainer.dart';
import 'package:screen_vibe/widget/profileSection.dart';
import 'package:screen_vibe/page/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class profile_page extends StatefulWidget {
  const profile_page({super.key});

  @override
  State<profile_page> createState() => _profile_pageState();
}

class _profile_pageState extends State<profile_page> {
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
        });
      }
    }
  }

  Future<void> _createNewList(String listName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

      await docRef.set({
        'movieLists': {
          listName: [],
        },
      }, SetOptions(merge: true));

      setState(() {
        movieLists[listName] = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('List "$listName" created!')),
      );
    }
  }

  void _showCreateListDialog() {
    final TextEditingController listNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New List'),
        content: TextField(
          controller: listNameController,
          decoration: const InputDecoration(labelText: 'List Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final listName = listNameController.text.trim();
              if (listName.isNotEmpty) {
                _createNewList(listName);
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          profileSection(),
          const SizedBox(height: 10),
          if (movieLists.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: movieLists.keys.map((listName) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      homeContainer(
                        title: listName,
                        movieIds: List<String>.from(movieLists[listName]),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'createList',
            onPressed: _showCreateListDialog,
            child: const Icon(Icons.add),
            backgroundColor: Colors.green,
            tooltip: 'Create New List',
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'searchMovies',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const search_page()),
              );
            },
            child: const Icon(Icons.search),
            backgroundColor: Colors.blue,
            tooltip: 'Search Movies',
          ),
        ],
      ),
    );
  }
}
