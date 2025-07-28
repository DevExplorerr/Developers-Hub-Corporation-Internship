import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  List<Map<String, dynamic>> tasks = [];
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  // Load tasks from SharedPreferences
  Future<void> loadTasks() async {
    prefs = await SharedPreferences.getInstance();
    final savedTasks = prefs.getStringList('tasks');
    if (savedTasks != null) {
      tasks = savedTasks
          .map<Map<String, dynamic>>((taskStr) => jsonDecode(taskStr))
          .toList();
      setState(() {});
    }
  }

  // Add new task
  void addTask() {
    final title = titleController.text.trim();
    if (title.isNotEmpty) {
      final time = _formattedTime();
      setState(() {
        tasks.add({'title': title, 'time': time, 'isCompleted': false});
      });
      titleController.clear();
      _saveTasks();
    }
  }

  // Save tasks to SharedPreferences
  void _saveTasks() {
    prefs.setStringList('tasks', tasks.map((e) => jsonEncode(e)).toList());
  }

  String _formattedDate() => DateFormat('yMMMMd').format(DateTime.now());
  String _formattedTime() => DateFormat.jm().format(DateTime.now());

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        toolbarHeight: 80.h,
        backgroundColor: greenColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Todo List',
          style: GoogleFonts.raleway(
            color: blackColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Icon(
              Icons.menu,
              size: 30.sp,
              color: blackColor,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        children: [
          SizedBox(height: 20.h),
          Text(
            'Tasks',
            style: GoogleFonts.raleway(
              color: whiteColor,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            _formattedDate(),
            style: GoogleFonts.raleway(
              color: greyColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 30.h),
          tasks.isEmpty
              ? Center(
                  child: Text(
                    'No tasks added yet!',
                    style: GoogleFonts.raleway(
                      color: whiteColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : Column(
                  children: tasks.asMap().entries.map((entry) {
                    final index = entry.key;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 13.h),
                      child: buildTaskList(context, index),
                    );
                  }).toList(),
                ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 70.h,
        width: 70.h,
        child: FloatingActionButton(
          splashColor: greenColor,
          backgroundColor: greenColor,
          shape: const CircleBorder(),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => dialogBox(context),
            );
          },
          child: Icon(
            Icons.add,
            color: blackColor,
            size: 30.sp,
          ),
        ),
      ),
    );
  }

  Widget dialogBox(BuildContext context) {
    return AlertDialog(
      backgroundColor: greenColor,
      title: Text(
        'Add New Task',
        style: GoogleFonts.raleway(
          color: blackColor,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Title",
            style: GoogleFonts.raleway(
              color: blackColor,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 5.h),
          TextField(
            controller: titleController,
            cursorColor: blackColor,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: blackColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: blackColor),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(overlayColor: blackColor),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: GoogleFonts.raleway(
              color: blackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            addTask();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            overlayColor: whiteColor,
            backgroundColor: blackColor,
          ),
          child: Text(
            'Add',
            style: GoogleFonts.raleway(
              color: whiteColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTaskList(BuildContext context, int index) {
    final task = tasks[index];

    return ListTile(
      tileColor: listViewColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      minTileHeight: 60,
      leading: IconButton(
        onPressed: () {
          setState(() {
            task['isCompleted'] = !task['isCompleted'];
            _saveTasks();
          });
        },
        icon: Icon(
          task['isCompleted']
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          color: task['isCompleted'] ? greyColor : whiteColor,
          size: 25.sp,
        ),
      ),
      title: Text(
        task['title'],
        style: GoogleFonts.raleway(
          color: task['isCompleted'] ? greyColor : whiteColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.w400,
          decoration: task['isCompleted'] ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Text(
        task['time'],
        style: GoogleFonts.raleway(
          color: task['isCompleted'] ? greyColor : whiteColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
