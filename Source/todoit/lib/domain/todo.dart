import 'package:uuid/uuid.dart';

class TodoItem {
  String id = const Uuid().toString();

  int id2;

  bool isComplete = false;
  late String name;

  DateTime? dueDate;
  String? notes;

  TodoItem(this.id2, this.name, [this.dueDate, this.notes]);
}
