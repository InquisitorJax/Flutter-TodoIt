import 'package:logger/logger.dart';

import '../domain/todo.dart';

class TodoItemRepository {
  final Logger log;

  TodoItemRepository({required this.log});

  List<TodoItem> getTodoItems() {
    log.w("Fetching Todo Items in Repo");
    return <TodoItem>[
      TodoItem(1, "Malcolm"),
      TodoItem(2, "Jack 1"),
      TodoItem(3, "Jack 2"),
      TodoItem(4, "Jack 3"),
      TodoItem(5, "Jack 4"),
      TodoItem(6, "Jack 5"),
      TodoItem(7, "Jack 6"),
      TodoItem(8, "Jack 7"),
      TodoItem(9, "Jack 8"),
      TodoItem(10, "Jack 9"),
      TodoItem(11, "Jack 10"),
      TodoItem(12, "Jack 11"),
      TodoItem(13, "Jack 12"),
    ];
  }
}
