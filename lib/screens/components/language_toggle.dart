import 'package:flutter/material.dart';

class LanguageToggle extends StatefulWidget {
  final Function(String)? onPressed;
  const LanguageToggle({super.key, this.onPressed});
  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {
  String btnSelected = "None";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        selectLanguageText(),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            englishButton(),
            const SizedBox(
              width: 30,
            ),
            urduButton()
          ],
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget selectLanguageText() {
    return const Text(
      "Select a Language",
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    );
  }

  Widget urduButton() {
    return ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(120,50)),
          elevation: MaterialStateProperty.all(5),
          backgroundColor: MaterialStateProperty.all(
              (btnSelected == "Urdu") ? Colors.black : Colors.white),
          foregroundColor: MaterialStateProperty.all(
              (btnSelected == "Urdu") ? Colors.white : Colors.black),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        ),
        onPressed: () {
          if (btnSelected == "Urdu") {
            setState(() {
              if (widget.onPressed != null) widget.onPressed!('None');
              btnSelected = "None";
            });
            return;
          } else {
            setState(() {
              if (widget.onPressed != null) widget.onPressed!('Urdu');
              btnSelected = "Urdu";
            });
            return;
          }
        },
        child: const Text("Urdu", style: TextStyle(fontSize: 18),));
  }

  Widget englishButton() {
    return ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(120,50)),
          elevation: MaterialStateProperty.all(5),
          backgroundColor: MaterialStateProperty.all(
              (btnSelected == "English") ? Colors.black : Colors.white),
          foregroundColor: MaterialStateProperty.all(
              (btnSelected == "English") ? Colors.white : Colors.black),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        ),
        onPressed: () {
          if (btnSelected == "English") {
            setState(() {
              if (widget.onPressed != null) widget.onPressed!('None');
              btnSelected = "None";
            });
            return;
          } else {
            setState(() {
              if (widget.onPressed != null) widget.onPressed!('English');
              btnSelected = "English";
            });
            return;
          }
        },
        child: const Text("English", style: TextStyle(fontSize: 18),));
  }
}
