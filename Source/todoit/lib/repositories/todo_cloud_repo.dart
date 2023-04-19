import 'package:logger/logger.dart';

import '../domain/todo.dart';

class TodoItemRepository {
  final Logger log;

  TodoItemRepository({required this.log});

  List<TodoItem> getTodoItems() {
    log.w("Fetching Todo Items in Repo");
    return <TodoItem>[
      TodoItem("Malcolm"),
      TodoItem("Adrian"),
      TodoItem("Jack")
    ];
  }
}
