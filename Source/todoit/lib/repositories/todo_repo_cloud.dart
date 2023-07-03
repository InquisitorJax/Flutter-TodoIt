import 'package:logger/logger.dart';
import 'package:todoit/repositories/todo_repository.dart';

import '../domain/todo.dart';

class TodoItemCloudRepository implements TodoItemRepository {
  final Logger log;

  TodoItemCloudRepository({required this.log});

  @override
  Future<GetTodoItemsResponse> getTodoItems() async {
    log.w("Fetching Todo Items in Repo");
    List<TodoItem> items = [
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
    GetTodoItemsResponse response = GetTodoItemsResponse();
    response.todoItems = items;
    return response;
  }
}
