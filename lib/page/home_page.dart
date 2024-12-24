import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:screen_vibe/API/apikey.dart';
import 'package:screen_vibe/API/apilink.dart';
import 'package:screen_vibe/model/film.dart';
import 'package:screen_vibe/widget/homeContainer.dart';
import 'package:screen_vibe/widget/navigationBar.dart';
import 'package:http/http.dart' as http;


class home_page extends StatelessWidget {
  home_page({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          homeContainer(title:"Popular"),
          homeContainer(title:"Now Playing"),
          homeContainer(title:"Top Rated"),
          homeContainer(title:"Upcoming"),
          homeContainer(title:"Recommendation"),
          //homeContainer(title:"Action Movie"),
          //homeContainer(title:"Watch Again"),
        ],
      ),

      
    );
  }
}


