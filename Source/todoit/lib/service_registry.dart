import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todoit/features/main/todo_list_viewmodel.dart';
import 'package:todoit/repositories/todo_repo_cloud.dart';
import 'package:todoit/repositories/todo_repo_memory.dart';
import 'package:todoit/services/todo_service.dart';

class ServiceRegistry {
  final List<SingleChildWidget> providers;

  ServiceRegistry({required this.providers});

  static ServiceRegistry registerServices() {
    final log = Logger(
        printer: PrettyPrinter(),
        level: kDebugMode ? Level.verbose : Level.nothing);

    final todoRepo = TodoItemMemoryRepository(log: log);
    final todoService = TodoService(repo: todoRepo);

    return ServiceRegistry(providers: [
      Provider<Logger>.value(value: log),
      Provider<TodoService>.value(value: todoService),
      ChangeNotifierProvider<TodoListViewModel>.value(
          value: TodoListViewModel(service: todoService, log: log)),
    ]);
  }
}
