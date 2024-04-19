import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lipsyncvoice_app/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
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
  bool finished = false;

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 5));
    if (context.mounted) {
      if (finished) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
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
