import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/page/todo/bloc/todo_list_bloc.dart';
import 'package:mobile/router.dart';
import 'package:mobile/widget/ErrorContent.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  static const title = "Todo List";

  late final TodoListBloc bloc;

  Future<void> _fetchData() async => bloc.add(const TodoListDataFetched());

  @override
  initState() {
    super.initState();
    bloc = context.read<TodoListBloc>();

    if (bloc.state is TodoListInitial) {
      _fetchData();
    }
  }

  PreferredSizeWidget _buildDefaultAppBar(BuildContext context) {
    return AppBar(
      title: const Text(title),
    );
  }

  PreferredSizeWidget _buildLoadedtAppBar(BuildContext context) {
    return AppBar(
      title: const Text(title),
    );
  }

  Widget _buildDefaultBody(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListState>(
      builder: (context, state) => ErrorContent(
        state: state,
        onRetryPressed: () => _fetchData,
      ),
    );
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
          final currentItem = state.items[index];

          final background = Container(
            color: theme.colorScheme.secondaryContainer,
            padding: const EdgeInsets.only(left: 24.0),
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.archive_outlined,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          );

          final secondaryBackground = Container(
            color: theme.colorScheme.errorContainer,
            padding: const EdgeInsets.only(right: 24.0),
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
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                bloc.add(TodoListItemToggleArchived(id: currentItem.id));
                return true;
              }

              if (direction == DismissDirection.endToStart) {
                bloc.add(TodoListItemRemoved(id: currentItem.id));
                return true;
              }

              return false;
            },
            child: ListTile(
              title: Text(currentItem.text),
              subtitle: currentItem.description == null
                  ? null
                  : Text(currentItem.description!),
              leading: Checkbox(
                value: currentItem.done,
                onChanged: (value) => bloc.add(
                  TodoListItemToggleCompleted(id: currentItem.id),
                ),
              ),
              onLongPress: () => GoRouter.of(context).pushNamed(
                Routes.todoUpdate.name,
                pathParameters: {'id': currentItem.id},
              ),
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
      onPressed: () => GoRouter.of(context).pushNamed(Routes.todoCreate.name),
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
