import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/auth/signup_screen.dart';
import 'package:task_management_app/colors.dart';
import 'package:task_management_app/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isobscureText = true;
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  bool isLoading = false;

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
                  child: buildSignupButton(),
                ),
              ],
            ),

            // Form Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 40.h),
              child: Form(
                key: _formKey,
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
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              setState(() => isLoading = true);
              await Future.delayed(Duration(seconds: 2));
              setState(() => isLoading = false);
              Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            }
          },
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
            Navigator.push(
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
