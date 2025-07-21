import 'package:clikz_studio/features/other/splash_screen.dart';
import 'package:flutter/material.dart';

late Size displaySize;

class AppEngine extends StatelessWidget {
  const AppEngine({super.key});

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      themeMode: ThemeMode.light,
      theme: ThemeData(colorScheme: ColorScheme.light(surface: Colors.white)),
      darkTheme: ThemeData(colorScheme: ColorScheme.dark(surface: Colors.black)),
    );
  }
}
