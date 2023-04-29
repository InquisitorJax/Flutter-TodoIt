import 'package:flutter/material.dart';
import 'package:todoit/domain/todo.dart';

class TodoCard extends StatefulWidget {
  const TodoCard({
    required this.model,
    required this.animation,
    required this.onCompleted,
    super.key,
  });

  final TodoItem model;
  final Animation<double> animation;
  final VoidCallback? onCompleted;

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  void updateState(bool? value) {
    setState(() {
      widget.model.isComplete = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.onBackground,
        decoration: widget.model.isComplete
            ? TextDecoration.lineThrough
            : TextDecoration.none);
    return Card(
      margin: const EdgeInsets.all(8),
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Checkbox(
              value: widget.model.isComplete,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0)),
              onChanged: (bool? value) {
                updateState(value);
                widget.onCompleted?.call();
              },
            ),
            const SizedBox(width: 8),
            Text(
              widget.model.name,
              style: style,
              semanticsLabel: "todo name: ${widget.model.name}",
            ),
          ],
        ),
      ),
    );
  }
}
