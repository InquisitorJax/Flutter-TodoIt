import 'package:todoit/src/domain/todo.dart';
import 'package:todoit/src/repositories/todo_cloud_repo.dart';

class TodoService {
  final TodoItemRepository repo;
  TodoService({required this.repo});

  List<TodoItem> getTodoItems() => repo.getTodoItems();
}
