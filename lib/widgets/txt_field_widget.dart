import 'package:clikz_studio/app.dart';
import 'package:clikz_studio/core/constants/colors.dart';
import 'package:clikz_studio/core/constants/sizes.dart';
import 'package:clikz_studio/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class txtfield extends StatefulWidget {
  final Key? fieldkey;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;
  final bool? isPrefix;
  final List<TextInputFormatter>? inputformat;
  final TextInputType? keyboardtype;
  final bool? hidepass;
  final GestureTapCallback? onTap;
  final bool? readonly;
  final void Function(String)? onSubmit;
  final void Function(String)? onChange;
  final AutovalidateMode? autoValid;

  const txtfield({
    super.key,
    this.fieldkey,
    this.onTap,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction,
    this.isPrefix,
    this.inputformat,
    this.keyboardtype,
    this.hidepass,
    this.readonly,
    this.onSubmit,
    this.autoValid,
    this.onChange,
  });

  @override
  State<txtfield> createState() => _txtfieldState();
}

class _txtfieldState extends State<txtfield> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller.addListener(_handleTextChanged);
  }

  void _handleTextChanged() {
    if (_hasSubmitted) {
      _validate();
    }
  }

  void _validate() {
    if (widget.validator == null) return;
    widget.validator!(_controller.text);
  }

  String? _validator(String? value) {
    return widget.validator?.call(value);
  }

  void _handleSubmitted(String value) {
    setState(() => _hasSubmitted = true);
    _validate();

    if (widget.nextFocusNode != null) {
      widget.nextFocusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          onChanged: widget.onChange,
          key: widget.fieldkey,
          obscureText: widget.hidepass ?? false,
          onTap: widget.onTap,
          controller: _controller,
          focusNode: _focusNode,
          textInputAction:
              widget.textInputAction ??
              (widget.nextFocusNode != null ? TextInputAction.next : TextInputAction.done),
          onFieldSubmitted:
              widget.onSubmit ??
              (value) {
                setState(() => _hasSubmitted = true);
                _handleSubmitted(value);
              },
          validator: _validator,
          readOnly: widget.readonly ?? false,
          inputFormatters: widget.inputformat,
          keyboardType: widget.keyboardtype,
          autovalidateMode: widget.autoValid ?? AutovalidateMode.onUnfocus,
          decoration: InputDecoration(
            isDense: true, // Reduce vertical height
            contentPadding: EdgeInsets.symmetric(
              vertical: displaySize.height * 0.012,
              horizontal: 16,
            ),
            prefixIcon: !(widget.isPrefix ?? false)
                ? Container(
                    margin: EdgeInsets.only(
                      left: displaySize.height * .025,
                      right: displaySize.height * .01,
                    ),
                    height: displaySize.height * .025,
                    width: displaySize.height * .025,
                    child: widget.prefixIcon,
                  )
                : SizedBox(
                    width: displaySize.height * .13,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: displaySize.height * .015),
                        child: widget.prefixIcon,
                      ),
                    ),
                  ),
            suffixIcon: widget.suffixIcon,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: colors.clikz_grey_1,
              fontWeight: Font.medium.weight,
              wordSpacing: 2,
              fontSize: displaySize.height * .016,
            ),
            errorStyle: TextStyle(
              fontSize: sizes.labelSmall(context),
              height: .8,
              fontWeight: Font.medium.weight,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(displaySize.width / 4),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(displaySize.width / 4),
              borderSide: BorderSide(color: colors.clikz_grey, width: .5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(displaySize.width / 4),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(displaySize.width / 4),
              borderSide: BorderSide(color: theme.colorScheme.error, width: .5),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }
}

txtfieldicon(context, String imagepath) {
  return SizedBox(
    height: displaySize.height * .022,
    width: displaySize.height * .022,
    child: Center(
      child: Image.asset(imagepath, height: displaySize.height * .022, color: colors.clikz_grey),
    ),
  );
}
