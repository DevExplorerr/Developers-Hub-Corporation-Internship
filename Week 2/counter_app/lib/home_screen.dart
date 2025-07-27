import 'package:counter_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int counter = 0;
  static const String counterKey = 'counter';
  late SharedPreferences prefs;

  void increment() {
    setState(() {
      counter++;
    });
    prefs.setInt(counterKey, counter);
  }

  void decrement() {
    setState(() {
      counter--;
    });
    prefs.setInt(counterKey, counter);
  }

  void reset() {
    setState(() {
      counter = 0;
    });
    prefs.setInt(counterKey, counter);
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    counter = prefs.getInt(counterKey) ?? 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: EdgeInsets.only(top: 100.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Tally",
              style: TextStyle(
                color: blackColor,
                fontSize: 52.sp,
                fontFamily: 'DigitalNumbers',
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "Counter",
              style: TextStyle(
                color: blackColor,
                fontSize: 56.sp,
                fontFamily: 'DigitalNumbers',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.only(left: 65.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        style: IconButton.styleFrom(overlayColor: blackColor),
                        onPressed: () {
                          increment();
                        },
                        icon: Icon(
                          Icons.expand_less_sharp,
                          size: 60.sp,
                          color: blackColor,
                        ),
                      ),
                      Text(
                        counter.toString(),
                        style: TextStyle(
                          color: blackColor,
                          fontSize: 65.sp,
                          fontFamily: 'DigitalNumbers',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      IconButton(
                        style: IconButton.styleFrom(overlayColor: blackColor),
                        onPressed: () {
                          decrement();
                        },
                        icon: Icon(
                          Icons.expand_more_sharp,
                          size: 60.sp,
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 5),
                  IconButton(
                    style: IconButton.styleFrom(overlayColor: blackColor),
                    onPressed: () {
                      reset();
                    },
                    icon: Icon(
                      Icons.refresh,
                      size: 56.sp,
                      color: blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
