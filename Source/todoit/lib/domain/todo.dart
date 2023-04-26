import 'package:uuid/uuid.dart';

class TodoItem {
  String id = const Uuid().toString();

  bool isComplete = false;
  late String name;

  DateTime? dueDate;
  String? notes;

  TodoItem(this.name, [this.dueDate, this.notes]);
}
