import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/auth/login_screen.dart';
import 'package:task_management_app/colors.dart';
import 'package:task_management_app/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isobscureText = true;
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  bool isLoading = false;

  String generateRandomPassword({int length = 8}) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    Random random = Random.secure();

    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  void _generatePassword() {
    String newPassword = generateRandomPassword();
    passwordController.text = newPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image
            Stack(
              children: [
                ClipRRect(
                  child: Image.asset(
                    'assets/images/header.png',
                    width: double.infinity,
                    height: 235.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 35.h,
                  right: 20.w,
                  child: buildSigninButton(),
                ),
              ],
            ),

            // Form Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 30.h),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                      "New User? Get Started Now",
                      style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 35.h),
                    buildLabel("User Name"),
                    SizedBox(height: 5.h),
                    buildUserNameField(),
                    SizedBox(height: 20.h),
                    buildLabel("Email"),
                    SizedBox(height: 5.h),
                    buildEmailField(),
                    SizedBox(height: 20.h),
                    buildLabel("Password"),
                    SizedBox(height: 5.h),
                    buildPasswordField(),
                    SizedBox(height: 45.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildSignupButton(),
                        buildGeneratePasswordButton(),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Terms and Conditions | Privacy Policy",
                      style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

  Widget buildUserNameField() => TextFormField(
        style: GoogleFonts.poppins(color: textColor),
        cursorColor: blackColor,
        controller: nameController,
        keyboardType: TextInputType.name,
        decoration: inputDecoration(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "User name cannot be empty";
          }
          return null;
        },
      );

  Widget buildEmailField() => TextFormField(
        style: GoogleFonts.poppins(color: textColor),
        cursorColor: blackColor,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: inputDecoration(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Email cannot be empty";
          } else if (!emailRegex.hasMatch(value)) {
            return "Enter a valid email";
          }
          return null;
        },
      );

  Widget buildPasswordField() => TextFormField(
        style: GoogleFonts.poppins(color: textColor),
        cursorColor: blackColor,
        controller: passwordController,
        obscureText: isobscureText,
        obscuringCharacter: '*',
        decoration: inputDecoration().copyWith(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isobscureText = !isobscureText;
              });
            },
            icon: Icon(
              isobscureText ? Icons.visibility_off : Icons.visibility,
              color: blackColor,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Password cannot be empty";
          } else if (value.length < 8) {
            return "Password must be at least 8 characters";
          }
          return null;
        },
      );

  Widget buildSignupButton() => SizedBox(
        height: 50.h,
        width: 160.w,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            overlayColor: whiteColor,
            backgroundColor: primaryButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              setState(() => isLoading = true);
              await Future.delayed(Duration(seconds: 2));
              setState(() => isLoading = false);
              Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (_) => HomeScreen(userName: nameController.text,)),
              );
            }
          },
          child: isLoading
              ? CircularProgressIndicator(color: whiteColor, strokeWidth: 2)
              : Text(
                  "SIGN UP",
                  style: GoogleFonts.cambo(
                    color: primaryButtonTextColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      );

  Widget buildSigninButton() => SizedBox(
        height: 40.h,
        width: 122.w,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            overlayColor: blackColor,
            backgroundColor: secondaryButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Text(
            "SIGN IN",
            style: GoogleFonts.cambo(
              color: secondaryButtonTextColor,
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );

  Widget buildGeneratePasswordButton() => SizedBox(
        height: 50.h,
        width: 160.w,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            overlayColor: whiteColor,
            backgroundColor: primaryButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          onPressed: () {
            
              _generatePassword();
            
          },
          child: Text(
            "Generate",
            style: GoogleFonts.cambo(
              color: primaryButtonTextColor,
              fontSize: 22.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );

  InputDecoration inputDecoration() => InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: inputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: blackColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.red),
        ),
      );
}
