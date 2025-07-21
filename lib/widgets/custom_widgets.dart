import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void statusbar(theme, {bool? colored}) {
  return SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: colored ?? true
          ? theme.colorScheme.surface
          : Colors.transparent, // Use selected color or theme color
      statusBarIconBrightness: theme.brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
    ),
  );
}

class ListConfig extends StatelessWidget {
  final Widget child;
  const ListConfig({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      removeTop: true,
      child: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(overscroll: false),
        child: child,
      ),
    );
  }
}

class Wpad extends StatelessWidget {
  final Widget child;
  const Wpad({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * .02),
      child: child,
    );
  }
}

class Hpad extends StatelessWidget {
  final Widget child;
  const Hpad({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * .02),
      child: child,
    );
  }
}
