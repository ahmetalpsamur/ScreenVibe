import 'package:flutter/material.dart';
import 'package:screen_vibe/widget/homeContainer.dart';
import 'package:screen_vibe/widget/navigationBar.dart';
import 'package:screen_vibe/widget/profileSection.dart';

class profile_page extends StatelessWidget {

  const profile_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children:  [
          profileSection(),
          homeContainer(title: "Popular"),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Define what happens when the button is pressed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Floating Action Button Pressed')),
          );
        },
        child: const Icon(Icons.add), // Customize the icon as needed
        backgroundColor: Colors.blue, // Customize the color of the button
      ),
    );

  }
}
