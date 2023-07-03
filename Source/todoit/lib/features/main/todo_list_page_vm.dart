import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoit/features/main/todo_list_viewmodel.dart';

class TodoListVMPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TodoListViewModel viewModel = context.watch<TodoListViewModel>();

    return Scaffold();
  }
}
