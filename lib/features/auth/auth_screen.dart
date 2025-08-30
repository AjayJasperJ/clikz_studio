import 'package:clikz_studio/app.dart';
import 'package:clikz_studio/core/constants/colors.dart';
import 'package:clikz_studio/core/constants/images.dart';
import 'package:clikz_studio/core/constants/sizes.dart';
import 'package:clikz_studio/features/auth/login_credential/login_screen.dart';
import 'package:clikz_studio/features/auth/register_credential/register_screen.dart';
import 'package:clikz_studio/features/dashboard/main_screen.dart';
import 'package:clikz_studio/widgets/button_style_widget.dart';
import 'package:clikz_studio/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:clikz_studio/features/auth/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //ui
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    status_bar(theme);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: displaySize.width * .04,
            vertical: displaySize.height * .02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: displaySize.height * .02),
              SizedBox(
                height: displaySize.height * .25,
                width: displaySize.height * .25,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: .1),
                        blurRadius: displaySize.height * .25 / 4,
                      ),
                    ],
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(images.applogo, isAntiAlias: true, fit: BoxFit.contain),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: displaySize.width * .8,
                    child: txt(
                      'Welcome to Clikz Wedding Films',
                      color: theme.colorScheme.primary,
                      font: Font.semiBold,
                      align: TextAlign.center,
                      size: sizes.titleLarge(context),
                    ),
                  ),
                  SizedBox(height: displaySize.height * .025),
                  txt(
                    'Manage, audit, and grow your business with ease all in one Solution.',
                    font: Font.medium,
                    size: sizes.bodySmall(context),
                    align: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: displaySize.height * .06,
                    width: displaySize.width,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      style: ButtonstyleWidget().elevated_filled_apptheme(context),
                      child: txt(
                        'Login',
                        color: Theme.of(context).colorScheme.onPrimary,
                        font: Font.medium,
                        size: sizes.titleMedium(context),
                      ),
                    ),
                  ),
                  SizedBox(height: displaySize.height * .015),
                  SizedBox(
                    height: displaySize.height * .06,
                    width: displaySize.width,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      style: ButtonstyleWidget().elevated_boardered_apptheme(context),
                      child: txt(
                        'Sign Up',
                        color: Theme.of(context).colorScheme.primary,
                        font: Font.medium,
                        size: sizes.titleMedium(context),
                      ),
                    ),
                  ),
                  SizedBox(height: displaySize.height * .01),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          indent: displaySize.height * .01,
                          endIndent: displaySize.height * .01,
                          thickness: .5,
                          color: colors.clikz_grey_1,
                        ),
                      ),
                      txt('Or', color: colors.clikz_grey_1),
                      Expanded(
                        child: Divider(
                          indent: displaySize.height * .01,
                          endIndent: displaySize.height * .01,
                          thickness: .5,
                          color: colors.clikz_grey_1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: displaySize.height * .015),
                  SizedBox(
                    height: displaySize.height * .06,
                    width: displaySize.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        final provider = Provider.of<AuthCredentialProvider>(
                          context,
                          listen: false,
                        );
                        final result = await provider.signInWithGoogle(context);
                        if (result != null && mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MainScreen()),
                          );
                        }
                      },
                      style: ButtonstyleWidget().elevated_boardered_sociallogin(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: displaySize.height * .03,
                            width: displaySize.height * .03,
                            child: Image.asset(images.googlelogo),
                          ),
                          SizedBox(width: displaySize.height * .01),
                          txt(
                            'Continue with google',
                            font: Font.medium,
                            color: theme.colorScheme.onSurface,
                            size: sizes.titleMedium(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: displaySize.height * .02),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
