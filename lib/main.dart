import 'package:flutter/material.dart';
import 'package:screen_vibe/page/login_page.dart';
import 'package:screen_vibe/widget/homeContainer.dart';
import 'package:screen_vibe/widget/navigationBar.dart';
import 'package:screen_vibe/widget/profileSection.dart';
import 'package:screen_vibe/page/register_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Kendi yaptığın sayfayı direk görmek
      // için home_page yerine login_page yaz
      // öyle test et. Geçişleri sonra yaparız.
      home: register_page(), //BU KISIMI DEĞİŞTİR.
    );
  }
}

