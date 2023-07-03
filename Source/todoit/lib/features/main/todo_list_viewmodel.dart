import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:todoit/domain/todo.dart';

import '../../services/todo_service.dart';

// see: https://github.com/martusheff/flutter-to-do-list

class TodoListViewModel extends ChangeNotifier {
  // how to get dependencies in here? context from widget when it constructs VM?
  //final Logger _log = Provider.of<Logger>(context, listen: false);
  //final TodoService _todoService = Provider.of<TodoService>(context, listen: false);

  List<TodoItem> todoItems = <TodoItem>[];

  void addItem(TodoItem todoItem) {
    todoItems.add(todoItem);
    notifyListeners();
  }

  void deleteItem(TodoItem todoItem) {
    todoItems.remove(todoItem);
    notifyListeners();
  }

  void completeItem(TodoItem todoItem) {
    todoItem.isComplete = !todoItem.isComplete;
  }
}
