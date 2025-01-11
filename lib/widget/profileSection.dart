import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class profileSection extends StatefulWidget {
  const profileSection({super.key});

  @override
  State<profileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<profileSection> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? displayName;
  String? displayDescription;
  String? profilePhotoUrl;
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
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      setState(() {
        displayName = currentUser.displayName ??
            userDoc['name']?.toString() ??
            "No name available"; // Fallback to Firestore 'name' field
        displayDescription =
            userDoc['description']?.toString() ?? "No Description Available";
        profilePhotoUrl = userDoc['profilePhoto'] ??
            "https://static.vecteezy.com/system/resources/thumbnails/008/442/086/small/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg";
      });

      print("Logged-in user's name: $displayName $displayDescription $profilePhotoUrl");

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
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

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
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

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

  Future<void> _showEditDialog() async {
    TextEditingController descriptionController =
    TextEditingController(text: displayDescription);
    String? selectedImagePath;
    String? newPhotoUrl;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> pickImage() async {
              final ImagePicker picker = ImagePicker();
              final XFile? pickedFile = await picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 70,
              );

              if (pickedFile != null) {
                setState(() {
                  selectedImagePath = pickedFile.path;
                });

                try {
                  // Firebase Storage'a yükleme
                  String userId = _auth.currentUser!.uid;
                  Reference storageRef = FirebaseStorage.instance
                      .ref()
                      .child('profilePhoto/$userId/${DateTime.now().toIso8601String()}');
                  UploadTask uploadTask = storageRef.putFile(File(selectedImagePath!));

                  TaskSnapshot snapshot = await uploadTask;
                  String downloadUrl = await snapshot.ref.getDownloadURL();
                  print("Image uploaded successfully. URL: $downloadUrl");

                  // Resim URL'sini değişkene ata
                  setState(() {
                    newPhotoUrl = downloadUrl;
                  });
                } catch (e) {
                  print("Error uploading image: $e");
                }
              }
            }


            return AlertDialog(
              title: const Text("Edit Profile"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Click image to upload new profile page"),
                  GestureDetector(
                    onTap: pickImage,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: selectedImagePath != null
                              ? FileImage(File(selectedImagePath!))
                              : profilePhotoUrl != null
                              ? NetworkImage(profilePhotoUrl!)
                              : null,
                          child: selectedImagePath == null && profilePhotoUrl == null
                              ? const Icon(Icons.person, size: 40) // Default icon if no photo exists
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String newDescription = descriptionController.text;

                    try {
                      // Update Firestore with new description and photo URL
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(_auth.currentUser!.uid)
                          .update({
                        'description': newDescription,
                        if (newPhotoUrl != null) 'profilePhoto': newPhotoUrl,
                      });

                      // Immediately update the UI
                      setState(() {
                        displayDescription = newDescription;
                        if (newPhotoUrl != null) {

                          profilePhotoUrl = newPhotoUrl;
                        }
                      });

                      await _loadUserData();

                      print("User profile updated successfully.");
                      Navigator.pop(context);
                    } catch (e) {
                      print("Error updating Firestore: $e");
                    }
                  },
                  child: const Text("Save"),
                ),

              ],
            );
          },
        );
      },
    );
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
              Image.network("https://t4.ftcdn.net/jpg/04/97/86/15/360_F_497861573_EX9cjKXjVLBhbHrawjVK8M3BthLDS5lE.jpg",
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: profilePhotoUrl != null
                        ? NetworkImage(profilePhotoUrl!)
                        : const NetworkImage('https://media.istockphoto.com/id/1223671392/fr/vectoriel/photo-de-profil-par-d%C3%A9faut-avatar-photo-placeholder-illustration-de-vecteur.jpg?s=612x612&w=0&k=20&c=iLDNfo8MGvF_Srti46vL4iyYbHB4bUK5iv6V7c4Pj80=') as ImageProvider,
                  ),
              ),
              )],
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
              Text(
                displayDescription ?? "No description available",
                style: const TextStyle(fontSize: 16),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showEditDialog,
                child: const Text("Edit Profile"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
