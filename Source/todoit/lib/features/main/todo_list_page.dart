import 'package:flutter/material.dart';
import 'package:great_list_view/great_list_view.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:todoit/domain/todo.dart';
import 'package:todoit/extensions/list_extensions.dart';
import 'package:todoit/widgets/todo_card.dart';

import '../../services/todo_service.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  late final Logger _log;
  late final TodoService _todoService;
  final _controller = AnimatedListController();
  //great_list_view works be animating diff of 2 lists, hence A & B instance
  late List<TodoItem> _listItems;
  late List<TodoItem> _listItemsA;
  late List<TodoItem> _listItemsB;

  @override
  void initState() {
    super.initState();
    _todoService = Provider.of<TodoService>(context, listen: false);
    _log = Provider.of<Logger>(context, listen: false);
    _listItemsA = _todoService.getTodoItems();
    _listItemsB = List.from(_listItemsA);
    _listItems = _listItemsA;
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
            child: AutomaticAnimatedListView<TodoItem>(
              list: _listItems,
              animator: const DefaultAnimatedListAnimator(
                dismissIncomingDuration: Duration(milliseconds: 150),
                resizeDuration: Duration(milliseconds: 200),
              ),
              comparator: AnimatedListDiffListComparator<TodoItem>(
                  sameItem: (a, b) => a.id == b.id,
                  sameContent: (a, b) =>
                      a.isComplete == b.isComplete && a.name == b.name),
              itemBuilder: (context, item, data) => _buildItem(
                item,
                data.animation,
                _listItems.indexOf(item),
                _completeItem,
              ),
              listController: _controller,
              addLongPressReorderable: false,
              // maybe try enable reorder limited to not completed? https://github.com/DavideBelsole/great_list_view/issues/16
              reorderModel: AutomaticAnimatedListReorderModel(_listItems),
              detectMoves: true,
            ),
          ),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 96,
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
      var listToDisplayNext =
          _listItems == _listItemsA ? _listItemsB : _listItemsA;

      TodoItem item = listToDisplayNext.removeAt(index);
      TodoItem? firstCompleted =
          listToDisplayNext.safeFirstWhere((todo) => todo.isComplete);
      int insertIndex = listToDisplayNext.length;
      if (firstCompleted != null) {
        insertIndex = listToDisplayNext.indexOf(firstCompleted);
      }
      listToDisplayNext.insert(insertIndex, item);
      swapList();
      if (_listItems == _listItemsA) {
        _listItemsB = List.from(_listItems);
      } else {
        _listItemsA = List.from(_listItems);
      }
    });
  }

  void swapList() {
    setState(() {
      _listItems = _listItems == _listItemsA ? _listItemsB : _listItemsA;
    });
  }
}
