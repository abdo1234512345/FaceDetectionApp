import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:facedetection/Features/Home/Presention/Views/home_view.dart';
import 'package:flutter/material.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        child: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              'Face Detection',
              speed: const Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 1,
          onFinished: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeView()),
            );
          },
        ),
      ),
    );
  }
}
