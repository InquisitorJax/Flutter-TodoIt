import '../core/notification.dart';
import '../domain/todo.dart';

/// Sample "interface" declaration
class TodoItemRepository {
  Future<GetTodoItemsResponse> getTodoItems() async {
    GetTodoItemsResponse response = GetTodoItemsResponse();
    response.todoItems = [];
    return response;
  }
}

class GetTodoItemsResponse extends LogicNotification {
  List<TodoItem> todoItems = [];
}
