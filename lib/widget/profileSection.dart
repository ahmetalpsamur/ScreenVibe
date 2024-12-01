import 'package:flutter/material.dart';

class profileSection extends StatelessWidget {
  const profileSection({super.key});

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
              //alignment: Alignment.bottomCenter,
              children: [
                Container(
                  child: const Image(
                      image: NetworkImage(
                          "https://t4.ftcdn.net/jpg/04/97/86/15/360_F_497861573_EX9cjKXjVLBhbHrawjVK8M3BthLDS5lE.jpg"),
                      fit: BoxFit.fill),
                ),
                const Padding(
                  padding: EdgeInsets.all(2),
                  child: Align(
                    alignment:
                        Alignment.bottomCenter, // Avatar'ın konumunu ayarlar
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                          "https://image.tmdb.org/t/p/w600_and_h900_bestv2/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"),
                    ),
                  ),
                ),
              ]),
        ),
        Container(
          child: const Column(
            children: [
              Text("Ahmet Alp SAMUR"),
              Text("My Favorite film is blblblblablablabla")
            ],
          ),
        ),
      ],
    );
  }
}
