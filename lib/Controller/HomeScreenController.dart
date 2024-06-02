import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/HomescreenModel.dart';

class ToDoController extends GetxController {
  RxList<ToDoModel> todoList = <ToDoModel>[].obs;
  TextEditingController taskController = TextEditingController();
  var filteredToDoList = <ToDoModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchToDoList();
  }

  Future<void> fetchToDoList() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<ToDoModel> tasks =
        jsonData.map((json) => ToDoModel.fromJson(json)).toList();

        todoList.assignAll(tasks);
        filteredToDoList.assignAll(tasks);
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Error response body: ${response.body}');
        // Show user feedback for failed request
        Get.snackbar(
          'Error',
          'Failed to fetch ToDo list. Please try again later.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Show user feedback for error
      Get.snackbar(
        'Error',
        'Failed to fetch ToDo list. Please check your internet connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void addTask(String title) {
    if (title.isNotEmpty) {
      todoList.add(ToDoModel(
        userId: 1,
        id: todoList.length + 1,
        title: title,
        completed: false,
      ));
      filteredToDoList.assignAll(todoList);
    }
  }

  void markAsCompleted(int index, bool bool) {
    todoList[index].completed = true;
    todoList.refresh();
    filteredToDoList.refresh();
  }

  void deleteTask(int index) {
    todoList.removeAt(index);
    filteredToDoList.assignAll(todoList);
  }

  void searchTask(String query) {
    if (query.isEmpty) {
      filteredToDoList.assignAll(todoList);
    } else {
      filteredToDoList.assignAll(
        todoList.where((task) => task.title!.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }
}
