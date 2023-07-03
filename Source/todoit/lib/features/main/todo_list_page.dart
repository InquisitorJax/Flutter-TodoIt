import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:great_list_view/great_list_view.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:todoit/domain/todo.dart';
import 'package:todoit/extensions/list_extensions.dart';
import 'package:todoit/features/main/add_todo_bottom_sheet_view.dart';
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
  bool _loading = false;
  final _controller = AnimatedListController();
  final _scrollController = ScrollController();
  final _textEditController = TextEditingController();
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
    _loading = true;
    _todoService.getTodoItems().then((response) {
      setState(() {
        _loading = false;
        _listItems = response.todoItems;
        _listItemsBackup = List.from(_listItems);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
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
              itemBuilder: (context, item, data) => _buildTodoCard(
                  item, _listItems.indexOf(item), _completeItem, _deleteItem),
              listController: _controller,
              addLongPressReorderable: false,
              // maybe try enable reorder limited to not completed? https://github.com/DavideBelsole/great_list_view/issues/16
              reorderModel: AutomaticAnimatedListReorderModel(_listItems),
              detectMoves: true,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        onPressed: () {
          HapticFeedback.heavyImpact();
          _buildTodoBottomSheet(
              AddTodoItemBottomSheetView(
                  addTodoItem: (addText) => _addItem(addText)),
              context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  //todo: could move items outside of build method if not using provider that relies on BuildContext
  Widget _buildTodoCard(
    TodoItem item,
    int index,
    ValueSetter<TodoItem> onComplete,
    ValueSetter<TodoItem> onDelete,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: TodoCard(
        model: item,
        onCompleted: () => onComplete(item),
        onDeleted: () => onDelete(item),
      ),
    );
  }

  void _buildTodoBottomSheet(Widget bottomSheetView, BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: ((context) {
          return bottomSheetView;
        }));
  }

  void _completeItem(TodoItem item) {
    int index = _listItems.indexOf(item);
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

//todo: _listItemsBackup should be in viewmodel which pushes state here
  void _addItem(String todoText) {
    setState(() {
      int id = _listItems.length + 1;
      _listItemsBackup.insert(0, TodoItem(id, todoText));
      _swapList(true);
    });
    _textEditController.clear();
  }

  void _deleteItem(TodoItem item) {
    setState(() {
      _listItemsBackup.remove(item);
      _swapList(false);
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
