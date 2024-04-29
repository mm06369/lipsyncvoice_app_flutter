import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lipsyncvoice_app/screens/about_us.dart';
import 'package:lipsyncvoice_app/screens/demo_page.dart';
import 'package:lipsyncvoice_app/utils/global_constants.dart';
import 'package:universal_html/html.dart' as html;

// ignore: must_be_immutable
class PageHeader extends StatefulWidget {
  final Function()? resetStates;
  bool isHomepage;

  PageHeader({Key? key, this.resetStates, this.isHomepage = false}) : super(key: key);

  @override
  State<PageHeader> createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {
  bool arrowPressed = false;

  void removeData(String key) {
  html.window.localStorage.remove(key);
}

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
            Text(
              widget.isHomepage ? "LipsSyncVoice.ai" : "About Us",
              style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            Row(
              children: [
                if (widget.isHomepage) GestureDetector(
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
                if (widget.isHomepage) TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => AboutUsPage()));
                    },
                    child: Text(
                      "About Us",
                      style: GoogleFonts.poppins(color: Colors.white),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoPage()));
                    },
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
                            removeData('ID');
                            removeData('isLogin');
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
