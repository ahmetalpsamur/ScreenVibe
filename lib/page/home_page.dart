import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:screen_vibe/widget/homeContainer.dart';
import 'package:screen_vibe/widget/navigationBar.dart';

class home_page extends StatelessWidget {
  const home_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          homeContainer(title:"Popular"),
          homeContainer(title:"Horror"),
          homeContainer(title:"Action"),
          homeContainer(title:"Comedy"),
          homeContainer(title:"Romantic"),
          homeContainer(title:"Suggestion"),
          homeContainer(title:"Watch Again"),
        ],
      ),
      bottomNavigationBar: navigationBar()
      
    );
  }
}


