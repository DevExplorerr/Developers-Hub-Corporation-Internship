// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/auth/auth_service.dart';
import 'package:task_management_app/auth/signup_screen.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'package:task_management_app/global/toast.dart';
import 'package:task_management_app/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isobscureText = true;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      isLoading = true;
    });
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      showToast(message: "Please enter email and password");
      setState(() => isLoading = false);
      return;
    }

    final user = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (user != null) {
      await FirebaseAuth.instance.currentUser?.reload();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }

    setState(() => isLoading = false);
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
                    child: buildSignupButton(),
                  ),
                ],
              ),

              // Form Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 40.h),
                child: Column(
                  children: [
                    SizedBox(height: 15.h),
                    Text(
                      "Sign In To Continue",
                      style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 35.h),
                    buildLabel("Email"),
                    SizedBox(height: 5.h),
                    buildEmailField(),
                    SizedBox(height: 20.h),
                    buildPasswordHeader(),
                    SizedBox(height: 5.h),
                    buildPasswordField(),
                    SizedBox(height: 45.h),
                    buildSignInButton(),
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

  Widget buildEmailField() => TextFormField(
        style: GoogleFonts.poppins(color: textColor),
        cursorColor: blackColor,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: inputDecoration(),
      );

  Widget buildPasswordHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildLabel("Password"),
          Text(
            "Forgot Password?",
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );

  Widget buildPasswordField() => TextFormField(
        style: GoogleFonts.poppins(color: textColor),
        cursorColor: blackColor,
        keyboardType: TextInputType.visiblePassword,
        controller: _passwordController,
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

  Widget buildSignInButton() => SizedBox(
        height: 50.h,
        width: 356.w,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            overlayColor: whiteColor,
            backgroundColor: primaryButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
            ),
          ),
          onPressed: _login,
          child: isLoading
              ? CircularProgressIndicator(color: whiteColor, strokeWidth: 2)
              : Text(
                  "SIGN IN",
                  style: GoogleFonts.cambo(
                    color: primaryButtonTextColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      );

  Widget buildSignupButton() => SizedBox(
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
              MaterialPageRoute(builder: (context) => SignupScreen()),
            );
          },
          child: Text(
            "SIGN UP",
            style: GoogleFonts.cambo(
              color: secondaryButtonTextColor,
              fontSize: 17.sp,
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
