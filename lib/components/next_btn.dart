import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lipsyncvoice_app/screens/homepage.dart';

class NextButton extends StatefulWidget {
  const NextButton(
      {super.key,
      required this.onPressed});
  final Function() onPressed;

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          final response = await widget.onPressed();
          if (response['message'] == "Login successful"){
            setState(() {
              isLoading = false;
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomePage(userId: response['user_id'],)));
            });
          }
          else{
            setState(() {
            isLoading = false;
          });
          }

          setState(() {
            isLoading = false;
            print(response['message']);
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xFF1C1C1C)), // Background color
          minimumSize: MaterialStateProperty.all<Size>(
              const Size(300.0, 50.0)), // Button width
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Circular border radius
            ),
          ),
        ),
        child: !isLoading
            ? Text(
                'Next',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),
              )
            : const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )),
      ),
    );
  }
}
