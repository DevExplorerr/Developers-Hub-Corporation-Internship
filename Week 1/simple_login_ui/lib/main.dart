import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_login_ui/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        title: 'Simple Login UI App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
