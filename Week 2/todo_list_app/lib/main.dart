import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/colors.dart';
import 'package:todo_list_app/home_screen.dart';
import 'package:todo_list_app/provider/task_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider())
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        splitScreenMode: true,
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          title: "Todo List App",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: blackColor,
                // ignore: deprecated_member_use
                selectionColor: whiteColor.withOpacity(0.5),
                selectionHandleColor: whiteColor,
              )),
          home: HomeScreen(),
        ),
      ),
    );
  }
}
