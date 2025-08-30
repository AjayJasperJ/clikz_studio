import 'package:clikz_studio/app.dart';
import 'package:clikz_studio/core/constants/colors.dart';
import 'package:clikz_studio/core/constants/icons.dart';
import 'package:clikz_studio/core/constants/images.dart';
import 'package:clikz_studio/core/constants/sizes.dart';
import 'package:clikz_studio/features/auth/login_credential/login_screen.dart';
import 'package:clikz_studio/features/auth/register_credential/register_widget.dart';
import 'package:clikz_studio/widgets/button_style_widget.dart';
import 'package:clikz_studio/widgets/custom_widgets.dart';
import 'package:clikz_studio/widgets/txt_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _focus_1 = FocusNode();
  final _focus_2 = FocusNode();
  final _focus_3 = FocusNode();
  final _focus_4 = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Map<String, dynamic>> fieldData = [
      {
        'hinttext': 'Username',
        'controller': _nameController,
        'validate': RegisterWidget.validateName,
        'keyboard': null,
        'prefix': icons.person,
        'suffix': null,
        'c_node': _focus_1,
        'n_node': _focus_2,
      },
      {
        'hinttext': 'Email Id',
        'controller': _emailController,
        'validate': RegisterWidget.validateEmail,
        'keyboard': null,
        'prefix': icons.mail,
        'suffix': null,
        'c_node': _focus_2,
        'n_node': _focus_3,
      },
      {
        'hinttext': 'Password',
        'controller': _passwordController,
        'validate': RegisterWidget.validatePassword,
        'keyboard': null,
        'prefix': icons.lock,
        'suffix': icons.unhide,
        'c_node': _focus_3,
        'n_node': _focus_4,
      },
      {
        'hinttext': 'Confirm Password',
        'controller': _confirmPasswordController,
        'validate': RegisterWidget.validatePassword,
        'keyboard': null,
        'prefix': icons.lock,
        'suffix': icons.hidden,
        'c_node': _focus_4,
        'n_node': null,
      },
    ];
    return Scaffold(
      body: SafeArea(
        child: Wpad(
          child: SingleChildScrollView(
            child: Column(
              children: [
                backbutton(),
                SizedBox(height: displaySize.height * .02),
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      Container(
                        height: displaySize.height * .14,
                        width: displaySize.height * .14,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: ClipOval(child: Image.asset(images.emptyprofile, fit: BoxFit.cover)),
                      ),
                      SizedBox(height: displaySize.height * .01),
                      txt("+ Add Image", font: Font.medium),
                    ],
                  ),
                ),
                SizedBox(height: displaySize.height * .02),
                Form(
                  key: _formKey,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: fieldData.length,
                    itemBuilder: (context, index) {
                      final value = fieldData[index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: displaySize.height * .01),
                          txtfield(
                            hintText: value['hinttext'],
                            validator: value['validate'],
                            controller: value['controller'],
                            keyboardtype: value['keyboard'],
                            focusNode: value['c_node'],
                            nextFocusNode: value['n_node'],
                            prefixIcon: txtfieldicon(context, value['prefix']),
                            suffixIcon: value['suffix'] != null
                                ? txtfieldicon(context, value['suffix'])
                                : null,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: displaySize.height * .03),
                Column(
                  children: [
                    SizedBox(
                      height: displaySize.height * .06,
                      width: displaySize.width,
                      child: ElevatedButton(
                        onPressed: () => _register(context),
                        style: ButtonstyleWidget().elevated_filled_apptheme(context),
                        child: txt(
                          'Sign Up',
                          color: theme.colorScheme.onPrimary,
                          font: Font.medium,
                          size: sizes.titleMedium(context),
                        ),
                      ),
                    ),
                    SizedBox(height: displaySize.height * .02),
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
                    SizedBox(height: displaySize.height * .02),
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
              ],
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
                        text: "Already have an account? ",
                        style: TextStyle(
                          fontSize: displaySize.height * .016,
                          fontWeight: Font.medium.weight,
                        ),
                      ),
                      TextSpan(
                        text: "Log In",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
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

  Future<void> _register(context) async {
    if (!_formKey.currentState!.validate()) return;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Set displayName for the user
      await userCredential.user?.updateDisplayName(_nameController.text.trim());
      await userCredential.user?.reload();
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'Username': _nameController.text.trim(),
        'Email': _emailController.text.trim(),
        'Role': 'Member',
        'CreatedAt': FieldValue.serverTimestamp(),
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } on FirebaseException catch (e) {
      scaffoldMsg(context: context, content: e.message ?? e.toString());
    }
  }
}
