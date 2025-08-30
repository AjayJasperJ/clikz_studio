import 'package:clikz_studio/app.dart';
import 'package:clikz_studio/core/constants/colors.dart';
import 'package:clikz_studio/core/constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void status_bar(theme, {bool? color, Colors? status_color}) {
  return SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: color ?? true
          ? theme.colorScheme.surface
          : Colors.transparent, // Use selected color or theme color
      statusBarIconBrightness: theme.brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarColor: color ?? true
          ? theme.colorScheme.surface
          : Colors.transparent, // Use selected color or theme color
      systemNavigationBarIconBrightness: theme.brightness == Brightness.dark
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

enum Font {
  bold(FontWeight.w700),
  medium(FontWeight.w500),
  regular(FontWeight.w400),
  semiBold(FontWeight.w600);

  final FontWeight weight;
  const Font(this.weight);
}

enum Decorate {
  underline(TextDecoration.underline),
  overline(TextDecoration.overline),
  lineThrough(TextDecoration.lineThrough),
  none(TextDecoration.none);

  final TextDecoration value;
  const Decorate(this.value);
}

Widget txt(
  String content, {
  Color? color,
  double? size,
  Font? font,
  Decorate? decorate,
  int? max,
  TextAlign? align,
  TextOverflow? clip,
  double? spacing,
  double? height,
  String? family,
}) {
  return Text(
    content,
    style: TextStyle(
      fontFamily: family,
      fontSize: size,
      height: height,
      decoration: decorate?.value,
      color: color,
      fontWeight: font?.weight,
      wordSpacing: spacing,
    ),
    maxLines: max,
    overflow: clip,
    textAlign: align,
  );
}

class backbutton extends StatelessWidget {
  final dynamic title;
  final bool? centeredtitle;
  final bool? isSuffix;
  final String? suffixiconpath;
  final VoidCallback? onPressed;
  final VoidCallback? ontap;

  const backbutton({
    super.key,
    this.title,
    this.centeredtitle,
    this.isSuffix,
    this.suffixiconpath,
    this.onPressed,
    this.ontap,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double containerSize = displaySize.height * .03 * 2;

    Widget buildIconButton({String? iconPath, VoidCallback? onTap}) {
      return GestureDetector(
        onTap: () async {
          if (onTap != null) onTap();
        },
        child: Container(
          height: containerSize,
          width: containerSize,
          decoration: BoxDecoration(
            border: Border.fromBorderSide(BorderSide(color: colors.clikz_grey)),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              iconPath ?? icons.left_arrow,
              height: displaySize.height * .025,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(height: displaySize.height * .02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            centeredtitle ?? false
                ? buildIconButton(onTap: onPressed ?? () => Navigator.pop(context))
                : Row(
                    children: [
                      buildIconButton(onTap: onPressed ?? () => Navigator.pop(context)),
                      SizedBox(width: displaySize.height * .02),
                      SizedBox(
                        width: displaySize.width * .6,
                        child: txt(
                          title ?? '',
                          align: TextAlign.center,
                          max: 1,
                          size: displaySize.height * .02,
                          font: Font.medium,
                        ),
                      ),
                    ],
                  ),
            centeredtitle ?? false
                ? txt(
                    title ?? '',
                    align: TextAlign.center,
                    max: 2,
                    size: displaySize.height * .024,
                    font: Font.medium,
                  )
                : SizedBox.shrink(),
            isSuffix ?? false
                ? buildIconButton(iconPath: suffixiconpath, onTap: ontap)
                : CircleAvatar(
                    radius: displaySize.height * .025,
                    backgroundColor: theme.colorScheme.onPrimary.withAlpha(0),
                  ),
          ],
        ),
      ],
    );
  }
}
