import 'package:todoit/domain/todo.dart';
import 'package:todoit/repositories/todo_cloud_repo.dart';

// todo: should be class TodoService with ChangeNotifier?
// so any todo list crud can be watched?
class TodoService {
  final TodoItemRepository repo;
  TodoService({required this.repo});

  List<TodoItem> getTodoItems() => repo.getTodoItems();
}
