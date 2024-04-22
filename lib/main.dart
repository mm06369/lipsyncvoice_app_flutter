import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lipsyncvoice_app/screens/view_history.dart';
import 'package:lipsyncvoice_app/screens/webcam.dart';
import 'package:lipsyncvoice_app/screens/camera_screen__.dart';
import 'package:lipsyncvoice_app/screens/homepage.dart';
import 'package:lipsyncvoice_app/screens/login_screen.dart';
import 'package:lipsyncvoice_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lip Sync Voice Application',
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      // home:ViewHistoryPage("")
      // home: HomePage(userId: 1)
      // home: Camera()

    );
  }
}
