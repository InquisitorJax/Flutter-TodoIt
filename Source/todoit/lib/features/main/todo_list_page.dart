import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:todoit/widgets/todo_card.dart';

import '../../services/todo_service.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final todoService = Provider.of<TodoService>(context, listen: false);
    final Logger log = Provider.of<Logger>(context, listen: false);
    final listItems = todoService.getTodoItems();
    String addTodoText;

    return Scaffold(
      appBar: AppBar(
        title: const Text("TodoIt App"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              // try https://pub.dev/packages/flutter_reorderable_grid_view?
              child: AnimatedList(
            initialItemCount: listItems.length,
            itemBuilder: (context, index, animation) => TodoCard(
              model: listItems[index],
              animation: animation,
              onClicked: () => {
                log.w("Tapped on index $index"),
              },
            ),
          )),
          const Align(
            // should be horizontal stack
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 80, 0),
              child: SizedBox(
                height: 80,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
