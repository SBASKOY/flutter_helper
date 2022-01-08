import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatelessWidget {
  final String? labelText;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final InputDecoration? customDecoration;
  final double? padding;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? errorText;
  final bool? isPassword;
  final String? hintText;
  final TextInputType? type;
  final VoidCallback? suffixoNTap;
  final int? maxLines;
  final int? maxLenght;
  final bool? readOnly;
  final Color? focusedBorderColor;

  final List<TextInputFormatter>? formatter;

  final String? Function(String?)? validator;
  // ignore: use_key_in_widget_constructors
  const CustomFormField(
      {this.labelText,
      this.onChanged,
      this.controller,
      this.customDecoration,
      this.padding,
      this.onTap,
      this.prefixIcon,
      this.suffixIcon,
      this.errorText,
      this.isPassword,
      this.suffixoNTap,
      this.hintText,
      this.formatter,
      this.type,
      this.maxLines,
      this.readOnly,
      this.validator,
      this.maxLenght,
      this.focusedBorderColor});

  @override
  Widget build(BuildContext context) {
    var _decoration = InputDecoration(
        labelText: labelText,
        errorText: errorText,
        hintText: hintText,
        counterText: "",
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: focusedBorderColor ?? Colors.blue)),
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        suffixIcon: GestureDetector(onTap: suffixoNTap, child: Icon(suffixIcon)));
    return Padding(
      padding: EdgeInsets.all(padding ?? 8.0),
      child: validator == null
          ? TextField(
              onChanged: onChanged,
              onTap: onTap,
              controller: controller,
              obscureText: isPassword ?? false,
              inputFormatters: formatter,
              maxLines: maxLines ?? 1,
              keyboardType: type,
              readOnly: readOnly ?? false,
              maxLength: maxLenght,
              decoration: customDecoration ?? _decoration)
          : TextFormField(
              onChanged: onChanged,
              onTap: onTap,
              controller: controller,
              obscureText: isPassword ?? false,
              inputFormatters: formatter,
              maxLines: maxLines ?? 1,
              keyboardType: type,
              validator: validator,
              readOnly: readOnly ?? false,
              maxLength: maxLenght,
              decoration: customDecoration ?? _decoration,
            ),
    );
  }
}
