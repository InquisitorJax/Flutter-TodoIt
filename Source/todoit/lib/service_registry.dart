import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todoit/src/repositories/todo_cloud_repo.dart';
import 'package:todoit/src/services/todo_service.dart';

class ServiceRegistry {
  final List<SingleChildWidget> providers;

  ServiceRegistry({required this.providers});

  static ServiceRegistry registerServices() {
    final log = Logger(
        printer: PrettyPrinter(),
        level: kDebugMode ? Level.verbose : Level.nothing);

    final todoRepo = TodoItemRepository(log: log);
    final todoService = TodoService(repo: todoRepo);

    return ServiceRegistry(providers: [
      Provider<Logger>.value(value: log),
      // should TodoService be ChangeNotifierProvider??
      Provider<TodoService>.value(value: todoService),
    ]);
  }
}
