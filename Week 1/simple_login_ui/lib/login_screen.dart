import 'package:flutter/material.dart';
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
      backgroundColor: whiteColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/header.png',
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Sign In To Continue",
                      style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Email",
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    style: GoogleFonts.poppins(color: textColor),
                    cursorColor: buttonColor,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: borderSideColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: borderSideColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email cannot be empty";
                      } else if (!emailRegex.hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Password",
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Forgot Password?",
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    style: GoogleFonts.poppins(color: textColor),
                    cursorColor: buttonColor,
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: isobscureText,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: borderSideColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: borderSideColor),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isobscureText = !isobscureText;
                          });
                        },
                        icon: Icon(
                          isobscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password cannot be empty";
                      } else if (value.length < 8) {
                        return "Password must be at least 8 characters long";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 44,
                    width: 356,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        overlayColor: whiteColor,
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          await Future.delayed(Duration(seconds: 2));
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        }
                      },
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: whiteColor,
                              ),)
                          : Text(
                              "SIGN IN",
                              style: GoogleFonts.cambo(
                                  color: whiteColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Terms and Conditions | Privacy Policy",
                      style: GoogleFonts.poppins(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Image.asset(
            'assets/images/footer.png',
            width: double.infinity,
          )
        ],
      ),
    );
  }
}
