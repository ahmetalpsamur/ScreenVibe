import 'package:flutter/material.dart';

class homeContainer extends StatelessWidget {
  const homeContainer({super.key,required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: const Color.fromRGBO(65, 72, 75, 1.0),
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Text(title,style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 40
                ),)),
            Expanded(
                flex: 2,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.grey,borderRadius: BorderRadiusDirectional.circular(5)),
                        width: 100,
                        child: const Padding(
                            padding:EdgeInsets.all(1.0) ,
                            child: Image(image: NetworkImage("https://image.tmdb.org/t/p/w600_and_h900_bestv2/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"),)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.grey,borderRadius: BorderRadiusDirectional.circular(5)),
                        width: 100,
                        child: const Padding(
                            padding:EdgeInsets.all(1.0) ,
                            child: Image(image: NetworkImage("https://image.tmdb.org/t/p/w600_and_h900_bestv2/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"),)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.grey,borderRadius: BorderRadiusDirectional.circular(5)),
                        width: 100,
                        child: const Padding(
                            padding:EdgeInsets.all(1.0) ,
                            child: Image(image: NetworkImage("https://image.tmdb.org/t/p/w600_and_h900_bestv2/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"),)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.grey,borderRadius: BorderRadiusDirectional.circular(5)),
                        width: 100,
                        child: const Padding(
                            padding:EdgeInsets.all(1.0) ,
                            child: Image(image: NetworkImage("https://image.tmdb.org/t/p/w600_and_h900_bestv2/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"),)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.grey,borderRadius: BorderRadiusDirectional.circular(5)),
                        width: 100,
                        child: const Padding(
                            padding:EdgeInsets.all(1.0) ,
                            child: Image(image: NetworkImage("https://image.tmdb.org/t/p/w600_and_h900_bestv2/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"),)),
                      ),
                    ),
                  ],
                ))
          ],
        ),

      ),
    );
  }
}