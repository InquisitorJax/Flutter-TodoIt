import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoit/domain/todo.dart';

class TodoCard extends StatefulWidget {
  const TodoCard({
    required this.model,
    required this.onCompleted,
    required this.onDeleted,
    super.key,
  });

  final TodoItem model;
  final VoidCallback? onCompleted;
  final VoidCallback? onDeleted;

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
    return GestureDetector(
        //onTap: expand / contract card,
        child: Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (press) => widget.onDeleted?.call(),
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: Card(
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
      ),
    ));
  }
}
