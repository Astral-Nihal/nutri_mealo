import 'package:flutter/material.dart';
import 'package:nutri_mealo/splash_screen.dart';
// import 'package:nutri_mealo/widgets/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: MainNavigation(),
      home: SplashScreen(),
    );
  }
}
