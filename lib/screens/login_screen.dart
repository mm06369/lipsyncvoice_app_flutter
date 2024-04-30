import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lipsyncvoice_app/components/auth_textfield.dart';
import 'package:lipsyncvoice_app/components/next_btn.dart';
import 'package:lipsyncvoice_app/components/password_textfield.dart';
import 'package:lipsyncvoice_app/logic/database_helper.dart';
import 'package:lipsyncvoice_app/screens/homepage.dart';
import 'package:lipsyncvoice_app/utils/global_constants.dart';
import 'package:universal_html/html.dart' as html;


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isSignIn = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Globals.pagebgColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            headingText(),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                height: 430,
                width: 800,
                decoration: BoxDecoration(
                    color: Globals.bgColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            welcomeText(),
                            AuthTextField(
                              controller: usernameController,
                            ),
                            PasswordTextField(
                              controller: passwordController,
                            ),
                            NextButton(
                              isLoading: isLoading,
                              isSign: isSignIn,
                              onPressed: isSignIn ? signIn : signUp,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            signUpPrompt()
                          ],
                        )),
                    bannerImage()
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: bottomText());
  }

  clearControllers(){
    usernameController.clear();
    passwordController.clear();
  }

  signUp() async {
    String message = "";

    setState(() {
      isLoading = true;
    });

    final response = await DatabaseHelper()
        .signUp(usernameController.text, passwordController.text);

    if (response == true) {
      setState(() {
        isLoading = false;
      });
      message = "Account Created Successfully!";
    } else {
      setState(() {
        isLoading = false;
      });
      message = "Not able to create account";
    }

    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void storeData(String key, String value) {
    html.window.localStorage[key] = value;
}

  signIn() async {
    setState(() {
      isLoading = true;
    });

    final response = await DatabaseHelper()
        .signIn(usernameController.text, passwordController.text);

    try{
      storeData('isLogin', 'True');
      storeData('ID', DatabaseHelper().getUserId());
    } catch (e){
      debugPrint(e.toString());
    }
    
    clearControllers();

        if (response == true) {
      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    HomePage(userId: DatabaseHelper().getUserId())));
      }
    } else {
      setState(() {
        isLoading = false;
      });

      const snackBar = SnackBar(
        content: Text('Username or password not recognized'),
        duration: Duration(seconds: 2),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Widget signUpPrompt() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isSignIn = !isSignIn;
            });
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            isSignIn ? 'Sign up' : 'Sign in',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}

Widget headingText() {
  return Text(
    "Lips Sync Voice",
    style: GoogleFonts.smoochSans(fontSize: 70, color: Colors.white),
  );
}

Widget bannerImage() {
  return Expanded(
    flex: 1,
    child: Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Image.asset(
        "assets/ScreenHome.png",
        width: 400,
        height: 400,
      ),
    ),
  );
}

Widget welcomeText() {
  return Column(children: [
    Container(
      margin: const EdgeInsets.only(top: 40),
      child: Text("Welcome",
          style: GoogleFonts.smoochSans(
              fontSize: 70, fontWeight: FontWeight.bold)),
    ),
    Text(
      "We are glad to see you back with us",
      style: GoogleFonts.poppins(fontSize: 14),
    ),
  ]);
}

Widget bottomText() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      "\u00A9 2023 Habib University Capstone Project. All Rights Reserved",
      style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
      textAlign: TextAlign.center,
    ),
  );
}
