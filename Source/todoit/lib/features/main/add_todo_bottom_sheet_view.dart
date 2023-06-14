import 'package:flutter/material.dart';

class AddTodoItemBottomSheetView extends StatelessWidget {
  const AddTodoItemBottomSheetView({
    required this.addTodoItem,
    super.key,
  });

  final void Function(String addText) addTodoItem;

  @override
  Widget build(BuildContext context) {
    final TextEditingController entryController = TextEditingController();
    var theme = Theme.of(context);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: 80,
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
            child: TextField(
              onSubmitted: (value) {
                if (entryController.text.isNotEmpty) {
                  addTodoItem(entryController.text);
                  entryController.clear();
                }
                Navigator.of(context).pop();
              },
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 5),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none))),
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: theme.colorScheme.surfaceTint,
              autofocus: true,
              autocorrect: false,
              controller: entryController,
            ),
          ),
        )),
      ),
    );
  }
}
