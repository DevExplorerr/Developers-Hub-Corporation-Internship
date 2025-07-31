import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_app/colors.dart';
import 'package:task_management_app/widgets/custom_appbar.dart';
import 'widgets/custom_listtile.dart';
import 'widgets/sub_heading.dart';

class HomeScreen extends StatefulWidget {
  final String? userName;
  const HomeScreen({super.key, this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> tasks = [];
  List<String> incompleteTasks = [];
  List<String> completedTasks = [];
  String _searchQuery = '';

  void addTask(String task) async {
    setState(() {
      tasks.add(task);
      incompleteTasks.add(task);
    });
    await saveTasks(tasks, incompleteTasks, completedTasks);
  }

  void deleteTask(int index) async {
    String taskToDelete = tasks[index];
    setState(() {
      tasks.removeAt(index);
      completedTasks.remove(taskToDelete);
      incompleteTasks.remove(taskToDelete);
    });
    await saveTasks(tasks, incompleteTasks, completedTasks);
  }

  void deleteAllTask() async {
    setState(() {
      tasks.clear();
    });
    await saveTasks(tasks, incompleteTasks, completedTasks);
  }

  void editTask(int index, String newTask) async {
    String oldTask = tasks[index];

    setState(() {
      tasks[index] = newTask;

      if (completedTasks.contains(oldTask)) {
        completedTasks.remove(oldTask);
        completedTasks.add(newTask);
      } else if (incompleteTasks.contains(oldTask)) {
        incompleteTasks.remove(oldTask);
        incompleteTasks.add(newTask);
      }
    });

    await saveTasks(tasks, incompleteTasks, completedTasks);
  }

  void updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  Future<void> saveTasks(List<String> tasks, List<String> incompleteTasks,
      List<String> completedTasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', tasks);
    await prefs.setStringList('incompleteTasks', incompleteTasks);
    await prefs.setStringList('completedTasks', completedTasks);
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> loadSaveTask = prefs.getStringList('tasks') ?? [];
    List<String> incomplete = prefs.getStringList('incompleteTasks') ?? [];
    List<String> completed = prefs.getStringList('completedTasks') ?? [];

    setState(() {
      tasks = loadSaveTask;
      incompleteTasks = incomplete;
      completedTasks = completed;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppbar(
                  onAddTask: addTask, onSearchChanged: updateSearchQuery, userName: widget.userName!,),
              SizedBox(height: 30.h),
              SubHeading(
                  ondeleteAll: () {
                    deleteAllTask();
                  },
                  taskCount: tasks.length),
              SizedBox(height: 40.h),
              ...tasks
                  .asMap()
                  .entries
                  .where((entry) =>
                      entry.value.toLowerCase().contains(_searchQuery))
                  .map((entry) {
                int index = entry.key;
                String task = entry.value;
                bool isTaskCompleted = completedTasks.contains(task);

                return CustomListTile(
                  taskTitle: task,
                  isCompleted: isTaskCompleted,
                  onStatusToggle: (value) async {
                    setState(() {
                      if (value) {
                        // Mark as completed
                        incompleteTasks.remove(task);
                        completedTasks.add(task);
                      } else {
                        // Mark as incomplete
                        completedTasks.remove(task);
                        incompleteTasks.add(task);
                      }
                    });
                    await saveTasks(tasks, incompleteTasks, completedTasks);
                  },
                  onDelete: () {
                    deleteTask(index);
                  },
                  onEdit: (updateTask) {
                    editTask(index, updateTask);
                  },
                );
              })
            ],
          ),
        ),
      ]),
    );
  }
}
