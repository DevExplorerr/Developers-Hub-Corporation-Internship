// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/auth/auth_service.dart';
import 'package:task_management_app/auth/login_screen.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'package:task_management_app/screens/home_screen.dart';
import '../global/toast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isobscureText = true;
  bool isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      showToast(message: "Please fill in all fields.");
      return;
    }

    setState(() => isLoading = true);
    final user = await _authService.signUp(username, email, password);

    if (user != null) {
      await FirebaseAuth.instance.currentUser?.reload();
      showToast(message: "Registration successful!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
    setState(() => isLoading = false);
  }

  String generateRandomPassword({int length = 8}) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    Random random = Random.secure();

    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  void _generatePassword() {
    String newPassword = generateRandomPassword();
    _passwordController.text = newPassword;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    child: Image.asset(
                      'assets/images/header.png',
                      width: double.infinity,
                      height: 265.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 60.h,
                    right: 20.w,
                    child: buildSigninButton(),
                  ),
                ],
              ),

              // Form Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 30.h),
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
            ],
          ),
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
        controller: _usernameController,
        keyboardType: TextInputType.name,
        decoration: inputDecoration(),
      );

  Widget buildEmailField() => TextFormField(
        style: GoogleFonts.poppins(color: textColor),
        cursorColor: blackColor,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: inputDecoration(),
      );

  Widget buildPasswordField() => TextFormField(
        style: GoogleFonts.poppins(color: textColor),
        cursorColor: blackColor,
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
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
          onPressed: _register,
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
            Navigator.pushReplacement(
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
              fontSize: 24.sp,
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
