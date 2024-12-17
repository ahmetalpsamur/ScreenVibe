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
          homeContainer(title: "My Favorite Films"),
          homeContainer(title: "Liked Films"),
          homeContainer(title: "Liste1"),
          homeContainer(title: "Liste2")
        ],
      ),
      bottomNavigationBar: const navigationBar(),
    );
  }
}
