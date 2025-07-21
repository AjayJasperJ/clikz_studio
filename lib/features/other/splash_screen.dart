import 'package:clikz_studio/app.dart';
import 'package:clikz_studio/core/constants/images.dart';
import 'package:clikz_studio/features/dashboard/main_screen.dart';
import 'package:clikz_studio/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    GetIn();
  }

  Future<void> GetIn() async {
    await Future.delayed(Duration(milliseconds: 3000));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    statusbar(theme);
    return SafeArea(
      child: Scaffold(
        body: Center(child: Image.asset(cimages.applogo, height: displaySize.height * .15)),
      ),
    );
  }
}
