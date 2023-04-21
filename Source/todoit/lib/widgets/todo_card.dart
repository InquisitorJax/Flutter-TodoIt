import 'package:flutter/material.dart';
import 'package:todoit/domain/todo.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({
    required this.model,
    required this.animation,
    required this.onClicked,
    super.key,
  });

  final TodoItem model;
  final Animation<double> animation;
  final VoidCallback? onClicked;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return GestureDetector(
        child: Card(
          margin: const EdgeInsets.all(8),
          color: theme.colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Text(
              model.name,
              style: style,
              semanticsLabel: "todo name: ${model.name}",
            ),
          ),
        ),
        onTap: () => onClicked);
  }
}
