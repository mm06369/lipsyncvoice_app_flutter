import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lipsyncvoice_app/components/history_container.dart';
import 'package:lipsyncvoice_app/components/history_label.dart';
import 'package:lipsyncvoice_app/logic/database_helper.dart';
import 'package:lipsyncvoice_app/logic/model/history_model.dart';
import 'package:lipsyncvoice_app/screens/login_screen.dart';
import '../utils/global_constants.dart';
import 'package:universal_html/html.dart' as html;

class ViewHistoryPage extends StatefulWidget {
  final String userId;
  const ViewHistoryPage({super.key, required this.userId});

  @override
  State<ViewHistoryPage> createState() => _ViewHistoryPageState();
}

class _ViewHistoryPageState extends State<ViewHistoryPage> {
  bool arrowPressed = false;
  bool isLoading = false;
  List<HistoryModel> historyList = [];

  getHistoryLst() async {
    setState(() {
      isLoading = true;
    });
    historyList = await DatabaseHelper().getHistory(widget.userId);
    setState(() {
      isLoading = false;
    });
  }

  void removeData(String key) {
    html.window.localStorage.remove(key);
  }

  @override
  void initState() {
    super.initState();
    getHistoryLst();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          historyPageHeader(),
          historyText(),
          const HistoryLabel(),
          if (!isLoading) showHistoryList(),
          if (isLoading)
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget showHistoryList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.95,
      child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
          itemCount: historyList.length,
          itemBuilder: (context, index) {
            return HistoryContainer(
                serial: index,
                text: historyList[index].text ?? "Cannot Load the data",
                date: historyList[index].dateAdded ?? "00-00-00 00:00:00");
          }),
    );
  }

  Widget historyText() {
    return Padding(
      padding: const EdgeInsets.only(left: 70, top: 40, bottom: 10),
      child: Text(
        "History",
        style: GoogleFonts.poppins(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 28),
      ),
    );
  }

  Widget historyPageHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 13),
        width: MediaQuery.sizeOf(context).width,
        height: 50,
        decoration: BoxDecoration(
            color: Globals.pagebgColor,
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_circle_left_rounded,
                      color: Colors.white,
                      size: 25,
                    )),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "LipsSyncVoice.ai",
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Home",
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
                          DatabaseHelper().signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          );
                          try {
                            removeData('isLogin');
                            removeData('ID');
                          } catch (e) {
                            debugPrint(
                                "Cannot remove the fields from storage: ${e.toString()}");
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
