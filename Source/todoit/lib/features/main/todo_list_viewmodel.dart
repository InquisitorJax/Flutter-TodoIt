import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:todoit/domain/todo.dart';

import '../../core/notification.dart';
import '../../services/todo_service.dart';
import '../../services/todo_service.dart';

// see: https://github.com/martusheff/flutter-to-do-list

class TodoListViewModel extends ChangeNotifier {
  // how to get dependencies in here? context from widget when it constructs VM?
  //final Logger _log = Provider.of<Logger>(context, listen: false);
  //final TodoService _todoService = Provider.of<TodoService>(context, listen: false);

  final TodoService service;
  final Logger log;
  TodoListViewModel({required this.service, required this.log});

  bool _loading = false;
  final LogicNotification _notification = LogicNotification.success();
  final List<TodoItem> _todoItems = [];

  bool get loading => _loading;
  List<TodoItem> get todoItems => _todoItems;
  LogicNotification get notification => _notification;

  getTodoItems() async {
    toggleLoading(true);

    // get the todo items from the repository here

    toggleLoading(false);
  }

  void addItem(TodoItem todoItem) {
    _todoItems.add(todoItem);
    notifyListeners();
  }

  void deleteItem(TodoItem todoItem) {
    _todoItems.remove(todoItem);
    notifyListeners();
  }

  void completeItem(TodoItem todoItem) {
    todoItem.isComplete = !todoItem.isComplete;
  }

  toggleLoading(bool isLoading) {
    _loading = isLoading;
    notifyListeners();
  }
}
