import 'package:flutter/material.dart';

class LanguageToggle extends StatefulWidget {
  final Function(String)? onPressed;
  String btnSelected;
  LanguageToggle({super.key, this.onPressed, this.btnSelected = 'None'});
  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {

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
              (widget.btnSelected == "Urdu") ? Colors.black : Colors.white),
          foregroundColor: MaterialStateProperty.all(
              (widget.btnSelected == "Urdu") ? Colors.white : Colors.black),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        ),
        onPressed: () {
          if (widget.btnSelected == "Urdu") {
            setState(() {
              if (widget.onPressed != null) widget.onPressed!('None');
              widget.btnSelected = "None";
            });
            return;
          } else {
            setState(() {
              if (widget.onPressed != null) widget.onPressed!('Urdu');
              widget.btnSelected = "Urdu";
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
              (widget.btnSelected == "English") ? Colors.black : Colors.white),
          foregroundColor: MaterialStateProperty.all(
              (widget.btnSelected == "English") ? Colors.white : Colors.black),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        ),
        onPressed: () {
          if (widget.btnSelected == "English") {
            setState(() {
              if (widget.onPressed != null) widget.onPressed!('None');
              widget.btnSelected = "None";
            });
            return;
          } else {
            setState(() {
              if (widget.onPressed != null) widget.onPressed!('English');
              widget.btnSelected = "English";
            });
            return;
          }
        },
        child: const Text("English", style: TextStyle(fontSize: 18),));
  }
}
