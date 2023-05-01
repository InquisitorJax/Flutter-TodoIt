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
  final ScrollController _scrollController = ScrollController();
  //great_list_view works by animating diff of 2 lists, hence A & B instance
  late List<TodoItem> _listItems;
  late List<TodoItem> _listItemsBackup;

  void _scrollToTop() {
    // scroll to index not available - boooo!
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    super.initState();
    _todoService = Provider.of<TodoService>(context, listen: false);
    _log = Provider.of<Logger>(context, listen: false);
    _listItems = _todoService.getTodoItems();
    _listItemsBackup = List.from(_listItems);
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
              scrollController: _scrollController,
              animator: const DefaultAnimatedListAnimator(
                dismissIncomingDuration: Duration(milliseconds: 150),
                resizeDuration: Duration(milliseconds: 200),
              ),
              comparator: AnimatedListDiffListComparator<TodoItem>(
                  sameItem: (a, b) => a.id2 == b.id2,
                  sameContent: (a, b) =>
                      a.isComplete == b.isComplete && a.name == b.name),
              itemBuilder: (context, item, data) => _buildItem(
                item,
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
        onPressed: () => _addItem(),
        child: const Icon(Icons.add),
      ),
    );
  }

  //todo: could move items outside of build method if not using provider that relies on BuildContext
  Widget _buildItem(
    TodoItem item,
    int index,
    ValueSetter<int> onComplete,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 96,
      child: TodoCard(
        model: item,
        onCompleted: () => onComplete(index),
      ),
    );
  }

  void _completeItem(int index) {
    _log.w("Updating item at index: $index");

    setState(() {
      // Reorder the list
      TodoItem item = _listItemsBackup.removeAt(index);
      TodoItem? firstCompleted =
          _listItemsBackup.safeFirstWhere((todo) => todo.isComplete);
      int insertIndex = _listItemsBackup.length;
      if (firstCompleted != null) {
        insertIndex = _listItemsBackup.indexOf(firstCompleted);
      }
      _listItemsBackup.insert(insertIndex, item);

      _swapList(item.isComplete);
    });
  }

  void _addItem() {
    setState(() {
      _listItemsBackup.insert(0, TodoItem(1, "New Item"));
      _swapList(true);
    });
  }

  void _swapList(bool scrollList) {
    _listItems = _listItemsBackup;

    if (!scrollList) {
      _scrollToTop();
    }

    // copy live list into backup
    _listItemsBackup = List.from(_listItems);
  }
}
