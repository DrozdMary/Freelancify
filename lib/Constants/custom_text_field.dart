import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Constants/text_styles.dart';

import 'colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.validator,
    required this.controller,
    required this.hintText,
    this.onEditingComplete,
    this.keyboardType,
    this.hintStyle,
    this.style,
    this.suffixIcon,
    this.obscureText,
    this.focusNode,
  });

  final String? Function(String?) validator;

  final TextEditingController controller;
  final String hintText;
  final void Function()? onEditingComplete;
  final TextInputType? keyboardType;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final Widget? suffixIcon;
  final bool? obscureText;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      textInputAction: TextInputAction.next,
      //Это устанавливает действие, которое происходит при нажатии на кнопку "Next" на клавиатуре.
      //В данном случае, при нажатии на "Next" фокус переходит к следующему полю.
      onEditingComplete: onEditingComplete,

      keyboardType: keyboardType,
      focusNode: focusNode,
      //Устанавливает тип клавиатуры, в данном случае, для ввода электронной почты.
      controller: controller,
      //Привязывает TextEditingController _emailTextController к данному TextFormField, что позволяет управлять текстом в этом поле ввода.
      obscureText: obscureText ?? false,
      //это для пароля нужно
      style: _defaultTextStyle,
      // Цвет текста
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        filled: true,
        hintStyle: _defaultHintStyle,
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.lightGreen, width: 0),
          borderRadius: BorderRadius.circular(16.0),
        ),
        fillColor: MyColors.lightGreen,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.emeraldGreen, width: 2),
          borderRadius: BorderRadius.circular(16.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.red, width: 2),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  TextStyle get _defaultHintStyle => hintStyle ?? TextStyles.normText.copyWith(fontSize: 20);

  TextStyle get _defaultTextStyle => style ?? TextStyles.normText.copyWith(fontSize: 20);
}
