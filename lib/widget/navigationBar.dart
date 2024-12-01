import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class navigationBar extends StatelessWidget {
  const navigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5
        ),
        child: GNav(
            gap: 5,
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade900,
            padding:const EdgeInsets.all(15),
            tabs: const [

              GButton(
                icon: Icons.home,
                text: "Home",
              ),
              GButton(
                icon: Icons.search,
                text: "Search",
              ),
              GButton(
                  icon: Icons.account_box,
                  text: "Profile"
              ),
            ]),
      ),
    );
  }
}
