import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/page/todo/bloc/archived_list_bloc.dart';
import 'package:mobile/router.dart';
import 'package:mobile/widget/failure_content.dart';

class ArchivedListPage extends StatefulWidget {
  const ArchivedListPage({super.key});

  @override
  State<ArchivedListPage> createState() => _ArchivedListPageState();
}

class _ArchivedListPageState extends State<ArchivedListPage> {
  static const title = "Archived Todo List";

  Future<void> _fetchData() async => context.read<ArchivedListBloc>().add(
        const ArchivedListDataFetched(),
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
    );
  }

  Widget _buildDefaultBody(BuildContext context) {
    return BlocBuilder<ArchivedListBloc, ArchivedListState>(
      builder: (context, state) => FailureContent(
        state: state,
        onRetryPressed: _fetchData,
      ),
    );
  }

  Widget _buildLoadedBody(BuildContext context) {
    return BlocBuilder<ArchivedListBloc, ArchivedListState>(
        builder: (context, state) {
      if (state is! ArchivedListSuccess) {
        return const SizedBox();
      }

      final list = ListView.separated(
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final currentItem = state.items[index];

          return ListTile(
            title: Text(currentItem.text),
            subtitle: currentItem.description == null
                ? null
                : Text(currentItem.description!),
            leading: Checkbox(
              value: currentItem.done,
              onChanged: null,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.restore,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => context.read<ArchivedListBloc>().add(
                    ArchivedListItemToggleArchived(id: currentItem.id),
                  ),
            ),
            onTap: () => GoRouter.of(context).pushNamed(
              Routes.todoDetail.name,
              pathParameters: {'id': currentItem.id},
            ).then((_) => _fetchData()),
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArchivedListBloc, ArchivedListState>(
      buildWhen: (previous, current) {
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) => switch (state) {
        ArchivedListSuccess _ => Scaffold(
            appBar: _buildLoadedtAppBar(context),
            body: _buildLoadedBody(context),
          ),
        _ => Scaffold(
            appBar: _buildDefaultAppBar(context),
            body: _buildDefaultBody(context),
          ),
      },
    );
  }
}
