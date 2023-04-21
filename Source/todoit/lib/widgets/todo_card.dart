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

  void setIsComplete(bool? value) {
    model.isComplete = value!;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge!.copyWith(
      color: theme.colorScheme.onBackground,
    );
    return GestureDetector(
        onTap: onClicked,
        child: Card(
          margin: const EdgeInsets.all(8),
          color: theme.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Checkbox(
                  value: model.isComplete,
                  shape: const CircleBorder(),
                  onChanged: (bool? value) {
                    setIsComplete(value);
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  model.name,
                  style: style,
                  semanticsLabel: "todo name: ${model.name}",
                ),
              ],
            ),
          ),
        ));
  }
}
