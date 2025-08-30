import 'package:clikz_studio/core/constants/colors.dart';
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
      theme: Light_Mode(),
      darkTheme: Dark_Mode(),
    );
  }
}

Light_Mode() {
  return ThemeData(
    fontFamily: 'general_sans',
    colorScheme: ColorScheme.light(
      primary: colors.clikz_orange_2,
      onPrimary: colors.clikz_white,
      surface: colors.clikz_white,
      onSurface: colors.clikz_darkblue,
      secondary: colors.clikz_grey_1,
      secondaryContainer: colors.clikz_violet_1,
      error: colors.clikz_error_red,
      onError: colors.clikz_white,
    ),
  );
}

Dark_Mode() {
  return ThemeData(
    fontFamily: 'general_sans',
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: const Color.fromARGB(255, 255, 195, 126),
      onPrimary: colors.clikz_white,
      surface: colors.clikz_surface,
      onSurface: colors.clikz_light_grey,
      secondaryContainer: colors.clikz_violet_1.withValues(alpha: .2),
      secondary: colors.clikz_grey_1,
      error: colors.clikz_error_red,
      onError: colors.clikz_white,
    ),
  );
}
