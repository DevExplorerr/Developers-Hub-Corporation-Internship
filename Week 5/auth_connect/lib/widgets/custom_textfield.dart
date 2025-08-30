import 'package:auth_connect/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final TextInputType? keyboardType;
  final IconButton? suffixIcon;
  final Icon? prefixIcon;
  final bool? obsecureText;

  const CustomTextfield({
    super.key,
    required this.hintText,
    required this.labelText,
    this.keyboardType,
    this.suffixIcon,
    this.obsecureText,
    this.prefixIcon, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      textInputAction: TextInputAction.next,
      obscureText: obsecureText ?? false,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.rubik(color: secondaryColor),
        labelText: labelText,
        labelStyle: GoogleFonts.rubik(color: secondaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        enabledBorder: authOutlineInputBorder,
        focusedBorder: authOutlineInputBorder.copyWith(
          borderSide: const BorderSide(color: primaryColor),
        ),
      ),
    );
  }
}

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: secondaryColor),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);
