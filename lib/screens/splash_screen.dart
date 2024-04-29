import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lipsyncvoice_app/screens/homepage.dart';
import 'package:lipsyncvoice_app/screens/login_screen.dart';
import 'package:universal_html/html.dart' as html;


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _navigateToHome();
    super.initState();
  }

  bool showSecondText = false;

  String? retrieveData(String key) {
    return html.window.localStorage[key];
  }

  _navigateToHome() async {
    
    String isLogin = retrieveData('isLogin') ?? 'False';
    print(retrieveData('isLogin'));  
    print(isLogin);
    
    await Future.delayed(const Duration(seconds: 5)); 

    if (context.mounted) {
      if (isLogin == 'False') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else if (isLogin == 'True'){
        String userId = retrieveData('ID') ?? '';
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage(userId: userId,)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText(
                  'Lip Sync Voice',
                  textStyle: const TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
              onFinished: () {
                setState(() {
                  showSecondText = true;
                });
              },
            ),
            if (showSecondText)
              AnimatedTextKit(
                onFinished: () {
                  _navigateToHome();
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Give voice to the voiceless',
                    textStyle: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 1000),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
          ],
        ),
      ),
    );
  }
}
