import 'package:exp_tracker/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../common/app_text_style.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    this.height = 50,
    this.width,
    this.hint = "hint",
    this.suffixTxt,
    required this.controller,
    this.disabled = false,
    this.onchange,
    this.inputType,
    this.stroke = true,
    this.prefixIcon,
    this.suffixIcon,
    this.hideText = false,
    this.onTap,
    this.darkText = true,
    this.validator,
    this.readOnly = false,
    this.error = false,
    this.onEditingComplete,
    this.focusNode,
    this.autoValiation = false,
    this.autofocus = false,
    this.inputFormatter,
    this.charLength = 50,
    this.extendable = false,
    this.maxLine,
    this.minLine,
    this.phoneField = false,
    this.onCountryChanged,
    this.countryCode,
    this.centerText = false,
    this.style,
    this.borderOnlyDown = false,
    this.lable = "",
  });
  final double? height;
  final double? width;
  final String hint;
  final String lable;
  final String? suffixTxt;
  final TextEditingController controller;
  final bool disabled;
  final Function(dynamic)? onchange;
  final TextInputType? inputType;
  final bool stroke;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool hideText;
  final VoidCallback? onTap;
  final bool darkText;
  final dynamic Function(dynamic)? validator;
  final bool readOnly;
  final bool error;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final bool autoValiation;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatter;
  final int charLength;
  final bool extendable;
  final int? maxLine;
  final bool phoneField;
  final Function(dynamic)? onCountryChanged;
  final String? countryCode;
  final bool centerText;
  final TextStyle? style;
  final bool borderOnlyDown;
  final dynamic minLine;

  @override
  Widget build(BuildContext context) {
    if (phoneField) {
      return intelPhoneField();
    } else if (extendable) {
      return expandableField();
    }
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      child: TextFormField(
        
        textAlign: centerText ? TextAlign.center : TextAlign.left,
        maxLength: charLength,
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        validator: (value) => validator!(value),
        keyboardType: inputType ?? TextInputType.text,
        onChanged: onchange,
        onEditingComplete: onEditingComplete,
        focusNode: focusNode,
        autofocus: autofocus,
        textAlignVertical: TextAlignVertical.bottom,
        obscureText: hideText,
        inputFormatters: inputFormatter ?? [],
        style: style ??
            (darkText
                ? AppTextStyle.withColor(
                    color: whiteColor.withOpacity(.8),
                    style: AppTextStyle.h4Bold,
                  )
                : AppTextStyle.withColor(
                    color: Colors.white,
                    style: AppTextStyle.h4Bold,
                  )),
        decoration: InputDecoration(
          counterText: '',
          enabled: !disabled,
          focusColor: primaryColor,
          fillColor: primaryColor,
          border: stroke
              ? borderOnlyDown
                  ? const UnderlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    )
                  : const OutlineInputBorder(
                      gapPadding: 100,
                      borderSide: BorderSide(width: 1, color: whiteColor),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )
              : InputBorder.none,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hint,
          hintStyle: style ??
              (darkText
                  ? AppTextStyle.withColor(
                      color: whiteColor.withOpacity(.5),
                      style: AppTextStyle.h4Bold,
                    )
                  : AppTextStyle.withColor(
                      color: Colors.white,
                      style: AppTextStyle.h4Bold,
                    )),
          suffixText: suffixTxt ?? '',
          enabledBorder: stroke
              ? borderOnlyDown
                  ? const UnderlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    )
                  : OutlineInputBorder(
                      borderSide: BorderSide(
                          width: error ? 1.5 : .8,
                          color: error ? dangerColor : whiteColor),
                      borderRadius: const BorderRadius.all(Radius.circular(10)))
              : InputBorder.none,
        ),
      ),
    );
  }

  Widget expandableField() {
    // wrap this widget with Expanded to use for multiple line text and
    // wrap it with Sized box with a specific height. recommended 50
    return TextFormField(
      maxLines: maxLine ?? (hideText ? 1 : null),
      minLines: minLine,
      //expands: true,
      maxLength: charLength,
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      controller: controller,
      onTap: onTap,
      readOnly: readOnly,
      validator: (value) => validator!(value),
      keyboardType: inputType ?? TextInputType.text,
      onChanged: onchange,
      autofocus: false,
      textAlignVertical: TextAlignVertical.center,
      inputFormatters: inputFormatter ?? [],
      obscureText: hideText,
      style: darkText
          ? AppTextStyle.withColor(
              color: whiteColor.withOpacity(.8),
              style: AppTextStyle.h4Bold,
            )
          : AppTextStyle.withColor(
              color: Colors.white,
              style: AppTextStyle.h4Bold,
            ),
      decoration: InputDecoration(
        counterText: '',
        enabled: !disabled,
        isDense: true,
        border: stroke
            ? OutlineInputBorder(
                borderSide: BorderSide(
                    width: 5, color: error ? Colors.red : whiteColor),
                borderRadius: const BorderRadius.all(Radius.circular(10)))
            : InputBorder.none,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: darkText
            ? AppTextStyle.withColor(
                color: whiteColor.withOpacity(.5),
                style: AppTextStyle.h4Bold,
              )
            : AppTextStyle.withColor(
                color: Colors.white,
                style: AppTextStyle.h4Bold,
              ),
        suffixText: suffixTxt ?? '',
        enabledBorder: stroke
            ? OutlineInputBorder(
                borderSide: BorderSide(
                    width: error ? 1 : .5,
                    color: error ? Colors.red : whiteColor),
                borderRadius: const BorderRadius.all(Radius.circular(10)))
            : InputBorder.none,
      ),
    );
  }

  Widget intelPhoneField() {
    return IntlPhoneField(
      controller: controller,
      inputFormatters: inputFormatter ?? [],
      decoration: InputDecoration(
          counterText: '',
          isDense: true,
          focusColor: primaryColor,
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 5, color: error ? dangerColor : whiteColor),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          hintText: hint,
          hintStyle: AppTextStyle.withColor(
              color: whiteColor.withOpacity(.5), style: AppTextStyle.h4Normal),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: error ? 1 : .5,
                  color: error ? dangerColor : whiteColor),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          errorStyle: const TextStyle(color: Colors.red, fontSize: 0.0)),
      initialCountryCode: countryCode ?? 'ET',
      onChanged: onchange,
      onCountryChanged: onCountryChanged,
    );
  }
}
