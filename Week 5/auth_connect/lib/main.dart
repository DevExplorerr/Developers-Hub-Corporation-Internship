// ignore_for_file: deprecated_member_use

import 'package:auth_connect/firebase_options.dart';
import 'package:auth_connect/screens/login_screen.dart';
import 'package:auth_connect/screens/profile_screen.dart';
import 'package:auth_connect/services/auth_service.dart';
import 'package:auth_connect/widgets/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Auth Connect",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: blackColor,
          selectionHandleColor: primaryColor,
          selectionColor: primaryColor.withOpacity(0.1),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
              primaryColor.withOpacity(0.1),
            ),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
              primaryColor.withOpacity(0.1),
            ),
          ),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: authservice.value.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          } else if (snapshot.hasData) {
            return const ProfileScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
