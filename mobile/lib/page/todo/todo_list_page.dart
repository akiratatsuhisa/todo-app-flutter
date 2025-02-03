import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/model/todo.dart';
import 'package:mobile/page/todo/bloc/todo_list_bloc.dart';
import 'package:mobile/router.dart';
import 'package:mobile/widget/failure_content.dart';
import 'package:mobile/widget/profile_button.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  static const title = "Todo List";

  Future<void> _fetchData() async => context.read<TodoListBloc>().add(
        const TodoListDataFetched(),
      );

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  PreferredSizeWidget _buildDefaultAppBar(BuildContext context) {
    return AppBar(
      title: const Text(title),
    );
  }

  PreferredSizeWidget _buildLoadedtAppBar(BuildContext context) {
    return AppBar(
      title: const Text(title),
      actions: const <Widget>[ProfileButton()],
    );
  }

  Widget _buildDefaultBody(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListState>(
      builder: (context, state) => FailureContent(
        state: state,
        onRetryPressed: _fetchData,
      ),
    );
  }

  Future<bool?> _swipeItem(DismissDirection direction, String id) async {
    if (direction == DismissDirection.startToEnd) {
      context.read<TodoListBloc>().add(TodoListItemToggleArchived(id: id));
      return true;
    }

    if (direction == DismissDirection.endToStart) {
      context.read<TodoListBloc>().add(TodoListItemRemoved(id: id));
      return true;
    }

    return false;
  }

  Widget _buildLoadedBody(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListState>(builder: (context, state) {
      if (state is! TodoListSuccess) {
        return const SizedBox();
      }

      final theme = Theme.of(context);

      final list = ListView.separated(
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final currentItem = state.items.elementAt(index);

          final background = Container(
            color: theme.colorScheme.secondaryContainer,
            padding: const EdgeInsets.only(left: 28.0),
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.archive_outlined,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          );

          final secondaryBackground = Container(
            color: theme.colorScheme.errorContainer,
            padding: const EdgeInsets.only(right: 28.0),
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete_forever_outlined,
              color: theme.colorScheme.onErrorContainer,
            ),
          );

          return Dismissible(
            key: Key(currentItem.id),
            background: background,
            secondaryBackground: secondaryBackground,
            confirmDismiss: (direction) => _swipeItem(
              direction,
              currentItem.id,
            ),
            child: ListTile(
              title: Text(currentItem.text),
              subtitle: currentItem.description == null
                  ? null
                  : Text(currentItem.description!),
              leading: Checkbox(
                value: currentItem.done,
                onChanged: (value) => context.read<TodoListBloc>().add(
                      TodoListItemToggleCompleted(id: currentItem.id),
                    ),
              ),
              onTap: () => GoRouter.of(context).pushNamed(
                Routes.todoDetail.name,
                pathParameters: {'id': currentItem.id},
              ).then((_) => _fetchData()),
              onLongPress: () async {
                final todo = await GoRouter.of(context).pushNamed(
                  Routes.todoUpdate.name,
                  pathParameters: {'id': currentItem.id},
                );

                if (!context.mounted) {
                  return;
                }

                if (todo is Todo) {
                  context
                      .read<TodoListBloc>()
                      .add(TodoListItemUpdated(todo: todo));
                }
              },
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(height: 0.0),
      );

      return RefreshIndicator(
        onRefresh: _fetchData,
        child: list,
      );
    });
  }

  Widget _buildLoadedFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.note_add),
      onPressed: () async {
        final todo =
            await GoRouter.of(context).pushNamed(Routes.todoCreate.name);

        if (!context.mounted) {
          return;
        }

        if (todo is Todo) {
          context.read<TodoListBloc>().add(TodoListItemAdded(todo: todo));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListState>(
      buildWhen: (previous, current) {
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) => switch (state) {
        TodoListSuccess _ => Scaffold(
            appBar: _buildLoadedtAppBar(context),
            body: _buildLoadedBody(context),
            floatingActionButton: _buildLoadedFloatingActionButton(context),
          ),
        _ => Scaffold(
            appBar: _buildDefaultAppBar(context),
            body: _buildDefaultBody(context),
          ),
      },
    );
  }
}
