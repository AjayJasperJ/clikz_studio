import 'package:clikz_studio/app.dart';
import 'package:clikz_studio/core/constants/images.dart';
import 'package:clikz_studio/features/auth/auth_screen.dart';
import 'package:clikz_studio/features/dashboard/main_screen.dart';
import 'package:clikz_studio/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus(context);
  }

  Future<void> _checkLoginStatus(context) async {
    final user = FirebaseAuth.instance.currentUser;
    await Future.delayed(Duration(milliseconds: 3000));
    if (user != null && user.emailVerified) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    status_bar(theme);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SizedBox(
            height: displaySize.height * .15,
            width: displaySize.height * .15,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: .1),
                    blurRadius: displaySize.height * .15 / 4,
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(images.applogo, isAntiAlias: true, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
