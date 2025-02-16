import 'package:facedetection/Features/Splash/Presention/Views/Widgets/splash_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashView(),
        darkTheme: ThemeData.dark(),
      ),
    );
  }
}
