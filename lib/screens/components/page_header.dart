import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lipsyncvoice_app/utils/global_constants.dart';

class PageHeader extends StatefulWidget {
  final Function()? resetStates;

  PageHeader({Key? key, this.resetStates}) : super(key: key);

  @override
  State<PageHeader> createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {
  bool arrowPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
        width: MediaQuery.sizeOf(context).width,
        height: 50,
        decoration: BoxDecoration(
            color: Globals.pagebgColor,
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "LipsSyncVoice.ai",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      if (widget.resetStates != null) {
                        widget.resetStates!();
                        setState(() {
                          arrowPressed = false;
                        });
                      }
                    },
                    child: const Icon(
                      Icons.restart_alt,
                      color: Colors.white,
                    )),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "About Us",
                      style: GoogleFonts.poppins(color: Colors.white),
                    )),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Demo",
                      style: GoogleFonts.poppins(color: Colors.white),
                    )),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        arrowPressed = !arrowPressed;
                      });
                      showMenu(
                        context: context,
                        position: const RelativeRect.fromLTRB(400, 60, 0, 0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        items: <PopupMenuItem<String>>[
                          const PopupMenuItem<String>(
                            value: 'Sign Out',
                            child: SizedBox(
                              width: 95,
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.logout_sharp),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text('Sign Out'),
                                    SizedBox(
                                      width: 2,
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ).then((value) async {
                        if (value != null) {
                          if (value == "Sign Out") {
                            Navigator.of(context).pop();
                          }
                        }
                        await Future.delayed(const Duration(milliseconds: 100));
                        setState(() {
                          arrowPressed = !arrowPressed;
                        });
                      });
                    },
                    child: !arrowPressed
                        ? const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white,
                          ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
