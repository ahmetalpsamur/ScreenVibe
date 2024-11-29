import 'package:flutter/material.dart';
import 'package:screen_vibe/page/home_page.dart';
import 'package:screen_vibe/page/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Kendi yaptığın sayfayı direk görmek
      // için home_page yerine login_page yaz
      // öyle test et. Geçişleri sonra yaparız.
      home: profile_page(), //BU KISIMI DEĞİŞTİR.
    );
  }
}

