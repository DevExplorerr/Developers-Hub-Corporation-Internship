
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/screens/home_screen.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/header.png",
            height: 180.h,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              children: [
                Text(
                  "Task Management",
                  style: GoogleFonts.akayaTelivigala(
                    fontSize: 30.sp,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 25.h),
                Image.asset(
                  "assets/logo.png",
                  height: 220.h,
                  width: 239.w,
                ),
                SizedBox(height: 35.h),
                const CircularProgressIndicator(
                  color: blackColor,
                )
              ],
            ),
          ),
          Image.asset(
            "assets/images/footer.png",
            height: 180.h,
            width: double.infinity,
            fit: BoxFit.fill,
          )
        ],
      ),
    );
  }
}
