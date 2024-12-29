import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screen_vibe/page/login_page.dart';
import 'package:screen_vibe/page/register_page.dart';
import 'package:screen_vibe/widget/navigationBar.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(
        apiKey: "AIzaSyDWkGMMhq_8IQ9xdz-EXUId8kW7w1HndPk",
        authDomain: "screenvibe-4876f.firebaseapp.com",
        projectId: "screenvibe-4876f",
        storageBucket: "screenvibe-4876f.firebasestorage.app",
        messagingSenderId: "19290217136",
        appId: "1:19290217136:web:61b4df582a5ab81dc8b975",
        measurementId: "G-J1H5D9RN44"
    ));
    print("firebase bağlandı");
  }
  else{
    await Firebase.initializeApp();
    print("firebase bağlanmadı");
  }
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      // Kendi yaptığın sayfayı direk görmek
      // için home_page yerine login_page yaz
      // öyle test et. Geçişleri sonra yaparız.
      home: login_page(), //BU KISIMI DEĞİŞTİR.

    );
  }
}

