import 'package:clikz_studio/app.dart';
import 'package:clikz_studio/core/constants/colors.dart';
import 'package:clikz_studio/core/constants/icons.dart';
import 'package:clikz_studio/core/constants/images.dart';
import 'package:clikz_studio/core/constants/sizes.dart';
import 'package:clikz_studio/features/auth/register_credential/register_screen.dart';
import 'package:clikz_studio/features/auth/register_credential/register_widget.dart';
import 'package:clikz_studio/features/dashboard/main_screen.dart';
import 'package:clikz_studio/widgets/button_style_widget.dart';
import 'package:clikz_studio/widgets/custom_widgets.dart';
import 'package:clikz_studio/widgets/txt_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final _focus_1 = FocusNode();
  final _focus_2 = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    emailcontroller.text = 'ajayjasperj@outlook.com';
    passwordcontroller.text = 'LetMeGo@7';
  }

  @override
  void dispose() {
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    _focus_1.dispose();
    _focus_2.dispose();
  }

  //Responce from Client Side
  void submit(login, password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: login.trim(),
        password: password.trim(),
      );
      if (!credential.user!.emailVerified) {
        await credential.user!.sendEmailVerification();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Email not verified'),
            content: Text(
              'A verification link has been sent to your email. Please verify before logging in.',
            ),
            actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))],
          ),
        );
        return;
      }
      // Navigate to main screen on successful login
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
    } on FirebaseException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text(e.message ?? 'Unknown error'),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    status_bar(theme);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ListConfig(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Wpad(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    backbutton(),
                    SizedBox(height: displaySize.height * .03),
                    txt(
                      'Hello, Welcome Back 👋🏻',
                      size: sizes.titleLarge(context),
                      font: Font.semiBold,
                    ),
                    SizedBox(height: displaySize.height * .02),
                    SizedBox(
                      width: displaySize.width * .8,
                      child: txt(
                        'Provide your email id & password to login and access your account.',
                        font: Font.medium,
                        size: sizes.bodySmall(context),
                      ),
                    ),
                    SizedBox(height: displaySize.height * .04),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: List.generate(2, (index) {
                          final fieldData = [
                            {
                              'key': _emailKey,
                              'focusnode': _focus_1,
                              'next_focus': _focus_2,
                              'hint_text': 'Email ID',
                              'isprefix': false,
                              'prefix': txtfieldicon(context, icons.mail),
                              'suffix': null,
                              'keyboard': TextInputType.emailAddress,
                              'controller': emailcontroller,
                              'input': null,
                              'validate': RegisterWidget.validateEmail,
                            },
                            {
                              'focusnode': _focus_2,
                              'next_focus': null,
                              'hint_text': 'Password',
                              'isprefix': false,
                              'prefix': txtfieldicon(context, icons.lock),
                              'suffix': GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.only(right: displaySize.height * .01),
                                  child: txtfieldicon(context, icons.hidden),
                                ),
                              ),
                              'keyboard': TextInputType.visiblePassword,
                              'controller': passwordcontroller,
                              'input': null,
                              'validate': RegisterWidget.validatePassword,
                              'hidden': false,
                            },
                          ];
                          return Column(
                            children: [
                              txtfield(
                                fieldkey: fieldData[index]['key'],
                                focusNode: fieldData[index]['focusnode'],
                                nextFocusNode: fieldData[index]['next_focus'],
                                hintText: fieldData[index]['hint_text'],
                                autoValid: fieldData[index]['autovalid'],
                                isPrefix: fieldData[index]['isprefix'],
                                prefixIcon: fieldData[index]['prefix'],
                                suffixIcon: fieldData[index]['suffix'],
                                keyboardtype: fieldData[index]['keyboard'],
                                controller: fieldData[index]['controller'],
                                inputformat: fieldData[index]['input'],
                                validator: fieldData[index]['validate'],
                                hidepass: fieldData[index]['hidden'],
                              ),
                              SizedBox(height: displaySize.height * .02),
                            ],
                          );
                        }),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: txt(
                          'Forgot Password ?',
                          size: sizes.bodySmall(context),
                          font: Font.medium,
                        ),
                      ),
                    ),
                    SizedBox(height: displaySize.height * .04),
                    SizedBox(
                      height: displaySize.height * .06,
                      width: displaySize.width,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            submit(emailcontroller.text, passwordcontroller.text);
                          }
                        },
                        style: ButtonstyleWidget().elevated_filled_apptheme(context),
                        child: txt(
                          'Login',
                          color: theme.colorScheme.onPrimary,
                          font: Font.medium,
                          size: sizes.titleMedium(context),
                        ),
                      ),
                    ),
                    SizedBox(height: displaySize.height * .03),
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
                    SizedBox(height: displaySize.height * .03),
                    SizedBox(
                      height: displaySize.height * .06,
                      width: displaySize.width,
                      child: ElevatedButton(
                        onPressed: () {},
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: displaySize.height * .08,
        padding: EdgeInsets.symmetric(horizontal: displaySize.width * .04),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          fontSize: displaySize.height * .016,
                          fontWeight: Font.medium.weight,
                        ),
                      ),
                      TextSpan(
                        text: "Sign Up",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen()),
                            );
                          },
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: displaySize.height * .016,
                          fontWeight: Font.semiBold.weight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: displaySize.height * .02),
          ],
        ),
      ),
    );
  }
}
