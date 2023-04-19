
import 'package:flutter/material.dart';
import 'package:todoit/src/domain/todo.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({
    super.key,
    required this.model,
  });

  final TodoItem model;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      margin: const EdgeInsets.all(16),
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(48, 24, 48, 24),
        child: Text(
          model.name,
          style: style,
          semanticsLabel: "todo name: ${model.name}",
        ),
      ),
    );
  }
}
