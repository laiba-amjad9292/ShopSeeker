import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final String? heading;
  final String? initialText;
  final String hintText;
  final bool isRequired;
  final String keyName;
  final Color? fillColor;
  final Color? hintColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? cursorColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? focusedErrorBorderColor;
  final Color? errorBorderColor;
  final TextInputType keyboardType;
  final bool isPasswordField;
  final bool readOnly;
  final bool isNumericField;
  final bool showTitle;
  final int? minLines;
  final int? maxLength;
  final int? maxLines;
  TextEditingController? controller;
  final TextDirection? textDirection;
  final TextDirection? innerTextDirection;
  final Widget? prefixIcon;
  final Widget? headingAction;
  final Widget? suffixIcon;
  final String? Function(String? val)? validator;
  final void Function(String?)? onChanged;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;

  CustomTextField({
    super.key,
    this.heading,
    required this.hintText,
    this.isRequired = false,
    required this.keyName,
    this.initialText,
    this.validator,
    this.onChanged,
    this.onTap,
    this.fillColor,
    this.headingAction,
    this.textColor,
    this.hintColor,
    this.cursorColor,
    this.borderColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.focusedErrorBorderColor,
    this.errorBorderColor,
    this.controller,
    this.maxLength,
    this.isNumericField = false,
    this.readOnly = false,
    this.showTitle = true,
    this.textDirection,
    this.keyboardType = TextInputType.text,
    this.isPasswordField = false,
    this.prefixIcon,
    this.suffixIcon,
    this.minLines,
    this.maxLines,
    this.innerTextDirection,
    this.inputFormatters,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    log('init');
    // widget.controller =
    //     widget.controller ?? TextEditingController(text: widget.initialText);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTitle) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: widget.heading,
                    style: stylew600(size: 14),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.isRequired ? ' * ' : '',
                        style: const TextStyle(color: AppColors.colorF97970),
                      ),
                    ],
                  ),
                ),
              ),
              widget.headingAction ?? Container(),
            ],
          ),
          8.hp,
        ],
        FormBuilderTextField(
          inputFormatters: widget.inputFormatters ?? [],
          onTap: () {
            // print(widget.controller?.text.length ?? 0);
            // print(widget.controller);
            // widget.controller?.selection = TextSelection.fromPosition(
            //     TextPosition(offset: widget.controller?.text.length ?? 0));

            if (widget.onTap != null) {
              widget.onTap!();
            }
          },
          controller: widget.controller,
          initialValue: widget.initialText,
          readOnly: widget.readOnly,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          name: widget.keyName,
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          obscureText: widget.isPasswordField ? _obscureText : false,
          style: stylew500(size: 16, color: widget.textColor),
          maxLines: widget.maxLines ?? 1,
          cursorColor: widget.cursorColor,
          decoration: InputDecoration(
            hintText: widget.hintText,
            fillColor: widget.fillColor ?? Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 15,
            ),
            hintStyle: styleRegular(
              size: 14,
              color: widget.hintColor ?? AppColors.color98A2B3,
            ),
            errorStyle: styleRegular(size: 14, color: AppColors.colorF97970),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.colorEAECF0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.enabledBorderColor ?? AppColors.colorEAECF0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color:
                    widget.readOnly == true
                        ? AppColors.colorEAECF0
                        : widget.focusedBorderColor ?? AppColors.primary,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.focusedErrorBorderColor ?? AppColors.colorF97970,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.errorBorderColor ?? AppColors.colorF97970,
              ),
            ),
            suffixIcon:
                widget.isPasswordField
                    ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                    : widget.suffixIcon != null
                    ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: widget.suffixIcon,
                    )
                    : null,
            isDense: true,
            suffixIconColor: AppColors.colorD0D5DD,
            prefixIconColor: AppColors.primary,
            prefixIcon:
                widget.prefixIcon != null
                    ? Padding(
                      padding: const EdgeInsets.all(11),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [widget.prefixIcon ?? Container()],
                      ),
                    )
                    : null,
            counterText: '',
            prefixIconConstraints: BoxConstraints(
              // maxWidth: 40.w,
              maxHeight: 43.h,
            ),
            suffixIconConstraints: BoxConstraints(
              // maxWidth: 40.w,
              maxHeight: 43.h,
            ),
          ),
        ),
      ],
    );
  }
}

InputDecoration customInputDecoration(String error, {bool isCentered = false}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.all(0),
    error:
        error.isNotEmpty
            ? Container(
              alignment: isCentered ? Alignment.center : null,
              child: Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  error,
                  style: styleRegular(size: 12, color: AppColors.colorF97970),
                ),
              ),
            )
            : null,
    border: InputBorder.none,
  );
}
