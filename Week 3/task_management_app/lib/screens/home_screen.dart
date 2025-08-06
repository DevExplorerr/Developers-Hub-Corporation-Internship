import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'package:task_management_app/widgets/custom_appbar.dart';
import '../widgets/custom_listtile.dart';
import '../widgets/sub_heading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> tasks = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTasksFromFirestore();
  }

  Future<void> loadTasksFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .get();

    setState(() {
      tasks = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'isCompleted': doc['isCompleted'],
        };
      }).toList();
      _isLoading = false;
    });
  }

  Future<void> addTask(String taskTitle) async {
    final taskRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .add({
      'title': taskTitle,
      'isCompleted': false,
    });

    setState(() {
      tasks.add({
        'id': taskRef.id,
        'title': taskTitle,
        'isCompleted': false,
      });
    });
  }

  Future<void> deleteTask(String taskId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .delete();

    setState(() {
      tasks.removeWhere((task) => task['id'] == taskId);
    });
  }

  Future<void> deleteAllTasks() async {
    final batch = FirebaseFirestore.instance.batch();
    for (var task in tasks) {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(task['id']);
      batch.delete(docRef);
    }

    await batch.commit();
    setState(() {
      tasks.clear();
    });
  }

  Future<void> editTask(String taskId, String newTitle) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .update({'title': newTitle});

    setState(() {
      final index = tasks.indexWhere((task) => task['id'] == taskId);
      if (index != -1) {
        tasks[index]['title'] = newTitle;
      }
    });
  }

  Future<void> toggleTaskStatus(String taskId, bool isCompleted) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .update({'isCompleted': isCompleted});

    setState(() {
      final index = tasks.indexWhere((task) => task['id'] == taskId);
      if (index != -1) {
        tasks[index]['isCompleted'] = isCompleted;
      }
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 20.w),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              CustomAppbar(
                  onAddTask: addTask, onSearchChanged: updateSearchQuery),
              SizedBox(height: 30.h),
              SubHeading(
                ondeleteAll: deleteAllTasks,
                taskCount: tasks.length,
              ),
              SizedBox(height: 40.h),
              if (_isLoading)
                Center(child: CircularProgressIndicator(color: blackColor))
              else ...[
                ...tasks
                    .where((task) =>
                        task['title'].toLowerCase().contains(_searchQuery))
                    .map((task) => CustomListTile(
                          taskTitle: task['title'],
                          isCompleted: task['isCompleted'],
                          onStatusToggle: (value) {
                            toggleTaskStatus(task['id'], value);
                          },
                          onDelete: () {
                            deleteTask(task['id']);
                          },
                          onEdit: (updatedTitle) {
                            editTask(task['id'], updatedTitle);
                          },
                        ))
              ]
            ],
          ),
        ],
      ),
    );
  }
}
