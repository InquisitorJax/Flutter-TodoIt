import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:todoit/domain/todo.dart';
import 'package:todoit/widgets/todo_card.dart';

import '../../services/todo_service.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late final Logger _log;
  late final TodoService _todoService;
  late final List<TodoItem> _listItems;

  @override
  void initState() {
    super.initState();
    _todoService = Provider.of<TodoService>(context, listen: false);
    _log = Provider.of<Logger>(context, listen: false);
    _listItems = _todoService.getTodoItems();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
                  key: _listKey,
                  initialItemCount: _listItems.length,
                  itemBuilder: (context, index, animation) => _buildItem(
                        _listItems[index],
                        animation,
                        index,
                        _completeItem,
                      ))),
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

  //todo: could move items outside of build method if not using provider that relies on BuildContext
  Widget _buildItem(
    TodoItem item,
    Animation<double> animation,
    int index,
    ValueSetter<int> onComplete,
  ) {
    return SizeTransition(
      sizeFactor: animation,
      child: TodoCard(
        model: item,
        animation: animation,
        onCompleted: () => onComplete(index),
      ),
    );
  }

  void _completeItem(int index) {
    _log.w("Updating item at index: $index");
    setState(() {
      // Reorder the list
      TodoItem item = _listItems.removeAt(index);
      _listItems.insert(0, item);

      // Update the AnimatedList
      _listKey.currentState?.removeItem(
        index,
        (context, animation) =>
            _buildItem(item, animation, index, _completeItem),
        duration: const Duration(milliseconds: 300),
      );
      _listKey.currentState
          ?.insertItem(0, duration: const Duration(milliseconds: 300));
    });
  }
}
