import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:facedetection/Features/Home/Presention/Views/Widgets/home_view_body.dart';
import 'package:flutter/material.dart';

class HomeAnimation extends StatelessWidget {
  const HomeAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'Face Detection',
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: Duration.secondsPerHour,
              onFinished: () {},
            ),
          ),
        ),
      ),
      body: HomeViewBody(),
    );
  }
}
