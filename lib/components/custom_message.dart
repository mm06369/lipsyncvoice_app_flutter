import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class CustomMessageContainer extends StatefulWidget {

  final String message;
  const CustomMessageContainer({super.key, required this.message});

  @override
  State<CustomMessageContainer> createState() => _CustomMessageContainerState();
}

class _CustomMessageContainerState extends State<CustomMessageContainer> {
  bool _animationFinished = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
      ),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Center(
          child: _animationFinished
              ? Text(
                  widget.message,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText(
                      widget.message,
                      textStyle: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  totalRepeatCount: 1,
                  pause: const Duration(milliseconds: 0),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                  onFinished: () {
                    setState(() {
                      _animationFinished = true;
                    });
                  },
                ),
        ),
      ),
    );
  }
}