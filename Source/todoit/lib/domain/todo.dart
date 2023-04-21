class TodoItem {
  bool isComplete = false;
  late String name;
  DateTime? dueDate;
  String? notes;

  TodoItem(this.name, [this.dueDate]);
}
