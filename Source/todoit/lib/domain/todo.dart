class TodoItem {
  bool isComplete = false;
  late String name;
  DateTime? dueDate;

  TodoItem(this.name, [this.dueDate]);
}
