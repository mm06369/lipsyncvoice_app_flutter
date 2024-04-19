import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lipsyncvoice_app/components/history_label.dart';
import 'package:lipsyncvoice_app/screens/components/page_header.dart';
import 'package:lipsyncvoice_app/screens/login_screen.dart';
import 'package:lipsyncvoice_app/utils/global_constants.dart';

class AboutUsPage extends StatefulWidget {
  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  bool arrowPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        PageHeader(),
        const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'Our Mission',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'To create innovative solutions that empower individuals with aphonia and related conditions to communicate effectively, enhancing their ability to interact with the world around them. Our application aims to transform mute videos into a voice, providing a new dimension of expression for those who have lost their ability to speak.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Our Vision',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'To be at the forefront of assistive technology, offering groundbreaking tools that redefine the boundaries of communication. We envision a world where technology bridges the gap for those with speech impairments, ensuring everyone has the opportunity to be heard.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'About the Project',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'This application is the brainchild of final-year computer science students at Habib University, developed as part of our capstone project. It represents not just our academic journey, but our commitment to making a meaningful contribution to society. By leveraging our skills and passion for computer science, we aim to create a tool that can change lives, enhance security surveillance, and offer a voice to those on their deathbeds.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
