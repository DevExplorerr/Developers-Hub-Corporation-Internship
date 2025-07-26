import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_login_ui/colors.dart';
import 'package:simple_login_ui/home_screen.dart';

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
      resizeToAvoidBottomInset: true,
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Image
            Image.asset(
              'assets/images/header.png',
              width: double.infinity,
              height: 220.h,
              fit: BoxFit.fill,
            ),

            // Form Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                      "Sign In To Continue",
                      style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 25.h),
                    buildLabel("Email"),
                    buildEmailField(),
                    SizedBox(height: 20.h),
                    buildPasswordHeader(),
                    buildPasswordField(),
                    SizedBox(height: 30.h),
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
            SizedBox(height: 22.h),
            // Footer Image
            Image.asset(
              'assets/images/footer.png',
              width: double.infinity,
              height: 230.h,
              fit: BoxFit.fill,
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
        cursorColor: buttonColor,
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
        cursorColor: buttonColor,
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
              color: Colors.black,
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
        height: 44.h,
        width: 356.w,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
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
                    color: whiteColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      );

  InputDecoration inputDecoration() => InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: borderSideColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(color: borderSideColor),
        ),
      );
}
