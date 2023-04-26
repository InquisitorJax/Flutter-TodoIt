import 'package:logger/logger.dart';

import '../domain/todo.dart';

class TodoItemRepository {
  final Logger log;

  TodoItemRepository({required this.log});

  List<TodoItem> getTodoItems() {
    log.w("Fetching Todo Items in Repo");
    return <TodoItem>[
      TodoItem("Malcolm"),
      TodoItem("Jack 1"),
      TodoItem("Jack 2"),
      TodoItem("Jack 3"),
      TodoItem("Jack 4"),
      TodoItem("Jack 5"),
      TodoItem("Jack 6"),
      TodoItem("Jack 7"),
      TodoItem("Jack 8"),
      TodoItem("Jack 9"),
      TodoItem("Jack 10"),
      TodoItem("Jack 11"),
      TodoItem("Jack 12"),
    ];
  }
}
