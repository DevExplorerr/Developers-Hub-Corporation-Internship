import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider extends ChangeNotifier {
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> get task => tasks;

  late SharedPreferences prefs;

  TaskProvider() {
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
      notifyListeners();
    }
  }

  // Save tasks to SharedPreferences
  void _saveTasks() {
    prefs.setStringList('tasks', tasks.map((e) => jsonEncode(e)).toList());
  }

  // Add new task
  void addTask(String title, String time) {
    if (title.isNotEmpty) {
      tasks.add({'title': title, 'time': time, 'isCompleted': false});
      _saveTasks();
      notifyListeners();
    }
  }

   // Toggle complete
  void toggleTask(int index) {
    tasks[index]['isCompleted'] = !tasks[index]['isCompleted'];
    _saveTasks();
    notifyListeners();
  }

  // Delete task
  void deleteTask(int index) {
    tasks.removeAt(index);
    _saveTasks();
    notifyListeners();
  }
}
